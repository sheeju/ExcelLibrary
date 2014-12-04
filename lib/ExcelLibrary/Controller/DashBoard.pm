package ExcelLibrary::Controller::DashBoard;
use Moose;
use namespace::autoclean;
use DateTime;
use Data::Dumper;
use Email::MIME;
use Email::Sender::Simple qw(sendmail);
use Session::Token;
use String::CamelCase qw(camelize);
use JSON;
use Digest::MD5 qw(md5_hex);
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ExcelLibrary::Controller::DashBoard - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~code block written by venkatesan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

my $generator = Session::Token->new(length => 20);

sub excellibrarysendmail : Local
{
    my $len = @_;
    my ($contenttype, $subject, $body, $to);
    if ($len != 4) {

        my $self = shift(@_);
        my $c    = shift(@_);
        $contenttype = shift(@_);
        $subject     = shift(@_);
        $body        = shift(@_);
        $to          = shift(@_);

        #($contenttype, $subject, $body, $to) = @{@_};
    }
    else {
        ($contenttype, $subject, $body, $to) = @_;
    }
    my $message = Email::MIME->create(
        header_str => [
            From    => 'ExcelLibrary@exceleron.com',
            To      => $to,
            Subject => $subject,
        ],
        attributes => {
            encoding => 'quoted-printable',
            charset  => 'UTF-8'
        },
    );
    $message->content_type_set($contenttype);
    $message->body_str_set($body);
    sendmail($message);

}

sub dashboard : Path : Args(0)
{
    my ($self, $c) = @_;
    if ($c->user) {
        $c->stash->{username} = $c->user->Name;
        $c->stash->{role}     = $c->user->Role;
        $c->stash->{email}    = $c->user->Email;

        $c->forward('View::TT');
    }
    else {
        $c->response->body('Page not found');
        $c->response->status(404);
    }
}

sub request : Path('/request')
{
    my ($self, $c) = @_;
    my $count;
    my $transaction;
    my $status;
    $count = 1;
    my $transaction_rs = $c->model('Library::Transaction')->search(
        {

            "me.Status"       => 'Requested',
            "employee.Status" => 'Active'
        },
        {
            join      => ['employee',      'book'],
            '+select' => ['employee.Name', 'book.Name'],
            '+as'     => ['EmployeeName',  'BookName'],
            order_by  => 'RequestDate'
        }
    );
    my $bookcopy_rs = $c->model('Library::BookCopy')->search({});
    while ($transaction = $transaction_rs->next) {

        if (defined $transaction->UpdatedBy) {

            $status = "issue";
        }
        else {
            my $book = $bookcopy_rs->search({"BookId" => $transaction->BookId, "Status" => "Available"});

=pod
			my $alredyresponed = $transaction_rs->search(
				{
					BookId    => $transaction->BookId,
					UpdatedBy => {'!=',undef}

				}
			); 						
=cut

            my $accepted = $c->model('Library::Transaction')->search(
                {
                    BookId    => $transaction->BookId,
                    UpdatedBy => {'!=', undef},
                    Status    => 'Requested'
                }
            );

            if ($accepted->count <= 0 and $book->next) {
                $status = "available";
            }
            else {
                $status = "notavailable";
            }

        }
        push(
            @{$c->stash->{messages}},
            {
                no            => $count++,
                id            => $transaction->Id,
                requesteddate => $transaction->RequestDate,
                employeename  => $transaction->get_column('EmployeeName'),
                bookname      => $transaction->get_column('BookName'),
                status        => $status
            }
        );
    }

    $c->stash->{template} = "dashboard/request.tt";
    $c->forward('View::TT');

}

sub managerequest : Local
{
    my ($self, $c) = @_;
    my $req_id     = $c->req->params->{id};
    my $response   = $c->req->params->{response};
    my $denyreason = $c->req->params->{reason};
    my $loginId    = $c->user->Id;

    #<---------Updating reponse for paritcular request------------->
    my $transaction_rs = $c->model('Library::Transaction')->search(
        {
            "me.Id" => $req_id
        },
        {
            join      => ['employee',       'book'],
            '+select' => ['employee.Email', 'employee.Name', 'book.Name'],
            '+as'     => ['EmployeeEmail',  'EmployeeName', 'BookName']
        }
    );
    my $transaction = $transaction_rs->next;

    # if ($transaction->UpdatedBy eq '') {
    if ($response eq 'Allow') {
        $transaction_rs->update({"UpdatedBy" => $loginId});
    }
    else {
        $transaction_rs->update(
            {
                "Status"    => 'Denied',
                "UpdatedBy" => $loginId,
                "Comment"   => $denyreason
            }
        );
    }

    # }

    #<--------Sending response as a email to user--------------->

    my $subject     = "ExcelLibrary response for book request";
    my $contenttype = "text/plain";
    my $message;

    my $employeename = $transaction->get_column("EmployeeName");
    my $bookname     = $transaction->get_column("BookName");
    my $requestdate  = $transaction->RequestDate;
    my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
    my $collectdate  = $current_date->ymd('-') . " " . $current_date->hms(':');
    my $email        = $transaction->get_column("EmployeeEmail");
    $transaction_rs = $c->model('Library::Transaction')->search(
        {
            "BookId"       => $transaction->BookId,
            "Status"       => 'Issued',
            "ReturnedDate" => {'=', undef}
        },
        {
            order_by => {-asc => "ExpectedReturnDate"}
        }
    );

    if ($response eq 'Allow') {
        $message =
            "Hello "
          . $employeename
          . "\,\n\nWe have recieve the request for \""
          . $bookname
          . "\" book on "
          . $requestdate
          . "\. Please come and collect the book on "
          . $collectdate . "\.";
    }
    else {
        $message =
            "Hello "
          . $employeename
          . "\,\n\nSorry to inform you, Your request for \""
          . $bookname
          . "\" book on "
          . $requestdate
          . " is denied because of following Reason."
          . "\nReason : "
          . $denyreason . "\.";
    }

    $message = $message . "\n\nRegards,\nAdmin,\nExcelLibrary.";
    excellibrarysendmail($contenttype, $subject, $message, $email);
    $c->detach('request');
}

sub getbookcopies : Local
{
    my ($self, $c) = @_;
    my $req_id         = $c->req->params->{req_id};
    my $transaction_rs = $c->model('Library::Transaction')->search({"Id" => $req_id});
    my $transaction    = $transaction_rs->next;

    my $bookid   = $transaction->BookId;
    my @books_rs = $c->model('Library::BookCopy')->search(
        {
            "Status" => 'Available',
            "BookId" => $bookid
        }
    );
    foreach my $b (@books_rs) {
        push(@{$c->stash->{books}}, $b->Id);
    }

    $c->forward('View::JSON');
}

sub issuebook : Local
{
    my ($self, $c) = @_;
    my $req_id       = $c->req->params->{req_id};
    my $bookcopy_id  = $c->req->params->{bc_id};
    my $loginid      = $c->user->Id;
    my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
    my $issuedate    = $current_date->ymd('-') . " " . $current_date->hms(':');
    my $maxallowday;
    my $expectedreturneddate;

    my $config_rs = $c->model('Library::Config')->search({});
    if (my $con = $config_rs->next) {
        $maxallowday = $con->MaxAllowedDays;
    }

    my $expectedreturn_date = $current_date->add(days => $maxallowday);
    $expectedreturneddate = $expectedreturn_date->ymd('-') . " " . $expectedreturn_date->hms(':');

    my $transaction_rs = $c->model('Library::Transaction')->search({"Id" => $req_id});
    my $transaction = $transaction_rs->next;
    if ($transaction->IssuedDate eq '') {
        $transaction_rs->update(
            {
                "BookCopyId"         => $bookcopy_id,
                "Status"             => 'Issued',
                "IssuedBy"           => $loginid,
                "IssuedDate"         => $issuedate,
                "ExpectedReturnDate" => $expectedreturneddate
            }
        );

        my $bookcopy_rs = $c->model('Library::BookCopy')->search({"Id" => $bookcopy_id});
        $bookcopy_rs->update({"Status" => 'Reading'});
    }
    $c->detach('request');
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~code block wriiten by pavan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~code block updated by venkatesan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub book : Path('/book')
{
    my ($self, $c) = @_;
    my $count = 1;

    my @book_rs = $c->model('Library::Book')->search(
        {
            Status => {'!=', 'Removed'},
        },
        {
            join      => 'book_copies',
            '+select' => ['book_copies.Status'],
            '+as'     => ['Status'],
            order_by  => [qw/me.Id/],
        }
    );

    $c->stash->{user} = $c->user->Name;
    my $userid = $c->user->Id;
    my %books;
    foreach my $var (@book_rs) {

        if (!exists($books{$var->Id})) {
            $books{$var->Id} = {
                count  => $count++,
                id     => $var->Id,
                name   => $var->Name,
                type   => $var->Type,
                author => $var->Author,
                status => $var->get_column('Status')
            };
        }
        elsif ($books{$var->Id}{status} eq "Reading" and $var->get_column('Status') eq "Available") {
            $books{$var->Id}{status} = "Available";
        }
    }
    my @transaction_rs = $c->model('Library::Transaction')->search(
        {
            "EmployeeId"   => $userid,
            "Status"       => {'!=', 'Denied'},
            "ReturnedDate" => {'=', undef}

        }
    );

    foreach my $transaction (@transaction_rs) {
        if ($transaction->Status eq 'Requested') {
            $books{$transaction->BookId}{element} = 'requested';
        }
        elsif ($transaction->Status eq 'Issued') {
            $books{$transaction->BookId}{element} = 'issued';
        }
        else {
            $books{$transaction->BookId}{element} = 'default';
        }

    }

    $c->stash->{messages} = \%books;
    $c->stash->{role}     = $c->user->Role;
    $c->forward("View::TT");
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~code block written by venkatesan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub copydetails : Local
{

    my ($self, $c) = @_;
    my $bookid = $c->req->params->{Id};
    my $count  = 1;
    my $book;
    my $transaction;
    my %bookcopy;

    my @bookcopy_rs = $c->model('Library::BookCopy')->search(
        {
            BookId => $bookid,
            Status => {'!=', 'Removed'}
        }
    );

    foreach $book (@bookcopy_rs) {

        $bookcopy{$book->Id} = {
            id         => $book->Id,
            status     => $book->Status,
            empname    => "-",
            issueddate => "-",
            returndate => "-",
            button     => "delete"
        };
    }

    my @transaction_rs = $c->model('Library::Transaction')->search(
        {
            BookId       => $bookid,
            'me.Status'  => 'Issued',
            ReturnedDate => undef
        },
        {
            join      => 'employee',
            '+select' => 'employee.Name',
            '+as'     => 'EmpName'
        }
    );

    foreach $transaction (@transaction_rs) {
        $bookcopy{$transaction->BookCopyId}{empname}    = $transaction->get_column('EmpName');
        $bookcopy{$transaction->BookCopyId}{issueddate} = $transaction->IssuedDate;
        $bookcopy{$transaction->BookCopyId}{returndate} = $transaction->ExpectedReturnDate;
        $bookcopy{$transaction->BookCopyId}{button}     = "lock";

    }
    $c->stash->{detail} = \%bookcopy;
    $c->forward('View::JSON');

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~copy block written by skanda~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub deletecopy : Local
{
    my ($self, $c) = @_;
    my $copyid = $c->req->params->{CopyId};
    my $del_copy = $c->model('Library::BookCopy')->find({Id => $copyid});
    $del_copy->Status('Removed');
    $del_copy->update;
    $c->forward('copydetails');
}

sub addbook : Local
{
    my ($self, $c) = @_;
    my $name        = $c->request->params->{'name'};
    my $author      = $c->request->params->{'author'};
    my $type        = $c->request->params->{'type'};
    my $noOfCopies  = $c->request->params->{'count'};
    my $currentdate = DateTime->now(time_zone => 'Asia/Kolkata');
    my $datestring  = $currentdate->ymd('-') . " " . $currentdate->hms(':');
    my $adminid     = $c->user->Id;
    my @respdata    = $c->model('Library::Book')->create(
        {
            Name       => $name,
            Type       => $type,
            Author     => $author,
            NoOfCopies => $noOfCopies,
            AddedOn    => $datestring,
            AddedBy    => $adminid,

        }
    );
    $c->stash->{message} = "Book added sucessfully";
    $c->log->info(Dumper $c->stash->{message});

    #    $c->forward('book');
    $c->forward('View::JSON');
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~code block written by venkatesan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub addcomment : Local
{

    my ($self, $c) = @_;
    my $bookid      = $c->req->params->{'bookid'};
    my $comment     = $c->req->params->{'comment'};
    my $employeeid  = $c->user->Id;
    my $currentdate = DateTime->now(time_zone => 'Asia/Kolkata');
    my $commentdate = $currentdate->ymd('-') . " " . $currentdate->hms(':');

    my $comment_rs = $c->model('Library::Comment')->create(
        {
            "Comment"       => $comment,
            "BookId"        => $bookid,
            "EmployeeId"    => $employeeid,
            "CommentedDate" => $commentdate
        }
    );
    $c->stash->{message} = "comment added sucessfully";
    $c->forward('View::JSON');
}

sub getcomments : Local
{
    my ($self, $c) = @_;
    my $bookid = $c->req->params->{'bookid'};

    my $comment_rs = $c->model('Library::Comment')->search(
        {
            "BookId" => $bookid
        },
        {
            join      => 'employee',
            '+select' => 'employee.Name',
            '+as'     => 'EmployeeName'
        }

    );
    my $comment;

    $c->stash->{flag} = 1 if ($comment_rs->count > 0);
    $c->stash->{role} = $c->user->Role;
    while ($comment = $comment_rs->next) {
        push(
            @{$c->stash->{comments}},
            {
                commentid    => $comment->Id,
                employeename => $comment->get_column('EmployeeName'),
                comment      => $comment->Comment,
                commentdate  => $comment->CommentedDate
            }
        );
        $c->log->info($comment->Id . " " . $comment->Comment);
    }
    $c->forward('View::JSON');
}

sub bookrequest : Local
{
    my ($self, $c) = @_;
    my $maxbookfromconfig = 0;
    my $bookid            = $c->request->params->{'bookId'};
    my $loginid           = $c->user->Id;
    my $currentdate       = DateTime->now(time_zone => 'Asia/Kolkata');
    my $requestdate       = $currentdate->ymd('-') . " " . $currentdate->hms(':');
    my @maxAllowbookQuery = $c->model('Library::Config')->search(
        undef,
        {
            select => 'MaxAllowedBooks',
        }
    );

    foreach my $Maxbook (@maxAllowbookQuery) {
        $maxbookfromconfig = $Maxbook->MaxAllowedBooks;
    }

    my $transaction_rs = $c->model('Library::Transaction')->search(
        {
            "me.Status"    => {'!=', 'Denied'},
            "ReturnedDate" => {'=',  undef},
            "EmployeeId"   => $loginid,
        },
        {
            join      => 'employee',
            '+select' => 'employee.Name',
            '+as'     => 'EmployeeName'
        }

    );

    my $numberofrequest = $transaction_rs->count;
    if ($maxbookfromconfig > $numberofrequest) {
        my @reqbook = $c->model('Library::Transaction')->create(
            {
                "BookId"      => $bookid,
                "EmployeeId"  => $loginid,
                "Status"      => 'Requested',
                "RequestDate" => $requestdate,
            }
        );

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~code block written by venkatesan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        my @employee_rs = $c->model('Library::Employee')->search(
            {
                "Role"   => 'Admin',
                "Status" => 'Active'
            }
        );
        my $employee;
        my $book_rs = $c->model('Library::Book')->search(
            {
                "Id" => $bookid
            }
        );

        my $book = $book_rs->next;

        my $transaction = $transaction_rs->next;

        foreach $employee (@employee_rs) {

            my $subject = "Book Request";
            my $message =
                "Hello "
              . $employee->Name
              . "\n\n\t"
              . $transaction->get_column('EmployeeName')
              . " Request the \""
              . $book->Name
              . "\" book on "
              . $transaction->RequestDate
              . "\.\n\n Regards,\nExcelLibrary. ";
            my $contenttype = "text/plain";
            excellibrarysendmail($contenttype, $subject, $message, $employee->Email);
        }

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~copy block written by skanda~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    }
    else {
        $c->stash->{deniedflag} = 1;
    }
    $c->forward('View::JSON');
}

sub user : Path('/user')
{
    my ($self, $c) = @_;
    my @user_rs = $c->model('Library::Employee')->search(
        {
            "Status" => {'!=', 'Disable'},
        }
    );

    my $count = 1;
    my %userdetail;
    my $user;
    foreach $user (@user_rs) {
        $userdetail{$user->Id} = {
            count      => $count++,
            id         => $user->Id,
            name       => $user->Name,
            role       => $user->Role,
            email      => $user->Email,
            bookinhand => 0,
            createdby  => $user->CreatedBy
        };
    }

    foreach my $userid (keys %userdetail) {

        my $createdby = $userdetail{$userid}->{createdby};
        if (defined $userdetail{$createdby}) {
            $userdetail{$userid}->{createdby} = $userdetail{$createdby}->{name};
        }
        else {
            my $user_rs = $c->model('Library::Employee')->search(
                {
                    "Id" => $createdby,
                },
                {
                    columns => "Name"
                }
            );
            $user = $user_rs->next;
            $userdetail{$userid}->{createdby} = $user->Name;
        }
    }

    my @transaction_rs = $c->model('Library::Transaction')->search(
        {
            "Status"       => 'Issued',
            "ReturnedDate" => {'=', undef}
        },
        {
            columns  => "EmployeeId",
            group_by => "EmployeeId"
        }
    );

    my $transaction;
    foreach $transaction (@transaction_rs) {
        $userdetail{$transaction->EmployeeId}{bookinhand} = 1;
    }
    my $id = $c->user->Id;
    $userdetail{$id}{bookinhand} = 2;
    $c->stash->{userinfo}        = \%userdetail;
    $c->stash->{template}        = "dashboard/user.tt";
    $c->forward('View::TT');
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~code block written by venkatesan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub adduser : Local
{
    my ($self, $c) = @_;
    my $empname = $c->req->params->{name};
    $empname = camelize($empname);
    my $emprole     = $c->req->params->{role};
    my $empemail    = $c->req->params->{email};
    my $userid      = $c->user->Id;
    my $currentdate = DateTime->now(time_zone => 'Asia/Kolkata');
    my $createdon   = $currentdate->ymd('-') . " " . $currentdate->hms(':');
    my $token;
    my $employee_rs;
    do {
        $token = $generator->get;
        $employee_rs = $c->model('Library::Employee')->search({"Token" => $token});
    } while ($employee_rs->count > 0);

    $employee_rs = $c->model('Library::Employee')->create(
        {
            "Name"      => $empname,
            "Role"      => $emprole,
            "Email"     => $empemail,
            "Token"     => $token,
            "CreatedBy" => $userid,
            "CreatedOn" => $createdon
        }
    );

    my $subject = 'Activate ExcelLibrary Account';
    my $message =
        'Hello '
      . $empname
      . ',<br> <p> We are happy to inform that your account has been created in ExcelLibrary. Please <a href="http://10.10.10.30:3000/login?token='
      . $token
      . '"> <button> Click me </button></a> make it as activate. <p>Regards,<br>Admin,<br>ExcelLibrary.</p> ';
    my $contenttype = 'text/html';

    excellibrarysendmail($contenttype, $subject, $message, $empemail);
    $c->stash->{message} = 'Employee Added Successfully';
    $c->forward('View::JSON');
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~copy block written by skanda~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub deleteuser : Local
{
    my ($self, $c) = @_;

    my $userid = $c->req->params->{userid};
    my $deleteuser = $c->model('Library::Employee')->find({Id => $userid});
    $deleteuser->Status('Disable');
    $deleteuser->update;
    $c->forward('user');
}

sub updaterole : Local
{

    my ($self, $c) = @_;
    my $empid       = $c->req->params->{empid};
    my $emprole     = $c->req->params->{emprole};
    my $adminid     = $c->user->Id;
    my $currentdate = DateTime->now(time_zone => 'Asia/Kolkata');
    my $updatedate  = $currentdate->ymd('-') . " " . $currentdate->hms(':');

    my $updaterole = $c->model('Library::Employee')->search({"Id" => $empid});
    $updaterole->update(
        {
            "Role"      => $emprole,
            "UpdatedBy" => $adminid,
            "UpdatedOn" => $updatedate
        }
    );
    $c->forward('user');

}

sub dashboardConfig : Local
{
    my ($self, $c) = @_;
    my $noofbooks = $c->req->params->{noofbooks};
    my $noofdays  = $c->req->params->{noofdays};
    my @reqbook   = $c->model('Library::Config')->update(
        {
            "MaxAllowedDays"  => $noofdays,
            "MaxAllowedBooks" => $noofbooks,
        }
    );
    $c->stash->{updatemessage} = " Settings Updated";
    $c->forward('View::JSON');
}

sub defaultsetting : Local
{

    my ($self, $c) = @_;
    my $config_rs = $c->model('Library::Config')->search(
        undef,
        {
            columns => [qw/MaxAllowedDays MaxAllowedBooks/],
        }
    );

    my $configinfo    = $config_rs->next;
    my $maxallowdays  = $configinfo->MaxAllowedDays;
    my $maxallowbooks = $configinfo->MaxAllowedBooks;
    $c->stash->{maxallowedbooks} = $maxallowbooks;
    $c->stash->{maxalloweddays}  = $maxallowdays;

    $c->forward('View::JSON');

}

sub changepassword : Local
{

    my ($self, $c) = @_;
    my $currentpassword        = $c->req->params->{oldpassword};
    my $newpassword            = $c->req->params->{newpassword};
    my $empid                  = $c->user->Id;
    my $encryptnewpassword     = md5_hex($newpassword);
    my $encryptcurrentpassword = md5_hex($currentpassword);
    my $employee_rs            = $c->model('Library::Employee')->search(
        {
            "Id" => $empid,
        }
    );
    my $employee   = $employee_rs->next;
    my $dbpassword = $employee->Password;

    if ($dbpassword eq $encryptcurrentpassword) {
        $employee->update({"Password" => $encryptnewpassword});
        $c->stash->{validmessage} = 1;
        $c->forward('View::JSON');
    }
    else {
        $c->stash->{invalidmessage} = "Invalid Current Password";
        $c->forward('View::JSON');
    }

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~code block written by venkatesan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub bookreturn : Path('/bookreturn')
{
    my ($self, $c) = @_;
    $c->forward('View::TT');
}

sub gettransactionbycopyid : Local
{
    my ($self, $c) = @_;
    my $copyid         = $c->req->params->{copy_id};
    my $transaction_rs = $c->model('Library::Transaction')->search(
        {
            "me.BookCopyId"   => $copyid,
            "me.Status"       => 'Issued',
            "me.ReturnedDate" => {'=', undef}
        },
        {
            join      => ['employee',      'book'],
            '+select' => ['employee.Name', 'book.Name'],
            '+as'     => ['EmployeeName',  'BookName']
        }
    );
    if (my $transaction = $transaction_rs->next) {
        $c->stash->{flag}          = 1;
        $c->stash->{id}            = $transaction->EmployeeId;
        $c->stash->{empname}       = $transaction->get_column('EmployeeName');
        $c->stash->{bookname}      = $transaction->get_column('BookName');
        $c->stash->{issuedate}     = $transaction->IssuedDate;
        $c->stash->{expreturndate} = $transaction->ExpectedReturnDate;
    }
    else {
        $c->stash->{flag} = 0;
    }
    $c->forward('View::JSON');
}

sub gettransactionbyemployeeid : Local
{
    my ($self, $c) = @_;
    my $employeeid     = $c->req->params->{emp_id};
    my @transaction_rs = $c->model('Library::Transaction')->search(
        {
            "me.EmployeeId"   => $employeeid,
            "me.Status"       => 'Issued',
            "me.ReturnedDate" => {'=', undef}
        },
        {
            join      => ['employee',      'book'],
            '+select' => ['employee.Name', 'book.Name'],
            '+as'     => ['EmployeeName',  'BookName']
        }
    );

    my $transaction;
    foreach $transaction (@transaction_rs) {
        $c->stash->{flag}         = 1;
        $c->stash->{employeename} = $transaction->get_column('EmployeeName');
        push(
            @{$c->stash->{booktaken}},
            {
                bookname      => $transaction->get_column('BookName'),
                bookcopyid    => $transaction->BookCopyId,
                issuedate     => $transaction->IssuedDate,
                expreturndate => $transaction->ExpectedReturnDate
            }
        );
    }

    $c->forward('View::JSON');
}

sub returnbook : Local
{
    my ($self, $c) = @_;

    my $loginId = $c->user->Id;
    my @bookcopy_id;
    push(@bookcopy_id, $c->req->params->{'copy_id[]'});
    my $comment      = $c->req->params->{comment};
    my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
    my $returneddate = $current_date->ymd('-') . " " . $current_date->hms(':');

    foreach my $copyid (@bookcopy_id) {

        my $transaction_rs = $c->model('Library::Transaction')->search({"BookCopyId" => $copyid});
        $transaction_rs->update(
            {
                "ReturnedDate" => $returneddate,
                "RecivedBy"    => $loginId,
                "Comment"      => $comment
            }
        );

        my $bookcopy_rs = $c->model('Library::BookCopy')->search({"Id" => $copyid});
        $bookcopy_rs->update({"Status" => 'Available'});
    }
    $c->stash->{result} = 1;
    $c->forward('View::JSON');
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~code block written by pavan~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
sub history : Path('/history')
{
    my ($self, $c) = @_;
    $c->stash->{role} = $c->user->Role;
    my $userId = $c->user->Id;
    if ($c->user->Role eq 'Admin') {
        my $count   = 1;
        my @alldata = $c->model('Library::Transaction')->search(
            {
                'me.Status' => {'!=', 'Requested'},
            },
            {
                join      => ['employee',      'book'],
                '+select' => ['employee.Name', 'book.Name'],
                '+as'     => ['EmployeeName',  'BookName'],
                order_by => {-desc => [qw/RequestDate/]},
            }
        );
        push(
            @{$c->stash->{history}},
            {
                Count       => $count++,
                EmpName     => $_->get_column('EmployeeName'),
                BookName    => $_->get_column('BookName'),
                Status      => $_->Status,
                RequestDate => $_->RequestDate,
                IssuedDate  => $_->IssuedDate,
                ReturnDate  => $_->ReturnedDate,
                CopyId      => $_->BookCopyId,
            }
        ) foreach @alldata;
    }
    elsif ($c->user->Role eq 'Employee') {
        my $count      = 1;
        my @emphistory = $c->model('Library::Transaction')->search(
            {
                'me.EmployeeId' => $userId,
            },
            {
                join      => ['book'],
                '+select' => ['book.Name'],
                '+as'     => ['BookName'],
                order_by  => {-desc => [qw/RequestDate/]},
            }
        );
        push(
            @{$c->stash->{emphistory}},
            {
                Count       => $count++,
                BookName    => $_->get_column('BookName'),
                RequestDate => $_->RequestDate,
                IssueDate   => $_->IssuedDate,
                ReturnDate  => $_->ExpectedReturnDate,
                Status      => $_->Status,
            }
        ) foreach @emphistory;
    }
    $c->forward('View::TT');
}

sub addcopies : Local
{
    my ($self, $c) = @_;
    my $no_of_copies = 0;
    $no_of_copies = $c->req->params->{Count};
    my $bookid      = $c->req->params->{bookId};
    my $currentdate = DateTime->now(time_zone => 'Asia/Kolkata');
    my $updateddate = $currentdate->ymd('-') . " " . $currentdate->hms(':');
    my $loginId     = $c->user->Id;
    $c->model('Library::BookCopy')->create(
        {
            BookId => $bookid,
            Status => 'Available',
        }
    );
    my $copy_update = $c->model('Library::Book')->find({Id => $bookid});
    $copy_update->NoOfCopies($no_of_copies);
    $copy_update->UpdatedOn($updateddate);
    $copy_update->UpdatedBy($loginId);
    $copy_update->update;
    $c->forward('View::JSON');
}

sub deletecomment : Local
{
    my ($self, $c) = @_;
    my $commentid = $c->req->params->{commentid};
    my $rowselect = $c->model('Library::Comment')->find(
        {
            Id => $commentid,
        }
    );
    $rowselect->delete;
    $c->forward('View::JSON');

}

=encoding utf8

=head1 AUTHORS

venkatesan,Skanda,Pavan,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
