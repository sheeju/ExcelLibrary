package ExcelLibrary::Controller::AdminDashboard;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use JSON;
use DateTime;
use POSIX qw(strftime);
BEGIN { extends 'Catalyst::Controller'; }
use POSIX qw(strftime);
use DateTime;
=head1 NAME

ExcelLibrary::Controller::AdminDashboard - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
sub home : Path('/home'){
	my ($self,$c) = @_;
	$c->stash->{username} = $c->user->Name;
}


sub request : Path('/request')
{
	my($self,$c) = @_;
	my ($r,$count);
	$count = 1;
	my @request = $c->model('Library::Transaction')->search(
		{

			"me.Status" => 'Requested',
		},
		{
			join => ['employee','book'],
			'+select' => ['employee.Name','book.Name'],
			'+as' => ['Employee Name','Book Name']
		});
	my $bookcopy_resulset = $c->model('Library::BookCopy')->search({});
	foreach $r (@request)
	{

		my $Button;
		if(defined $r->UpdatedBy)
		{
			my $bookcopy = $bookcopy_resulset->search({"BookId" => $r->BookId,"Status" => "Available" });
			my $book;

			if ($bookcopy->next)
			{
				$Button = '<input type="button" id="'.$r->Id.'" name="btn_issue" value="Issue" class="btn btn-primary btn-xs book_issue"data-toggle="modal" data-target="#myModal"/>'
			}
			else
			{
				$Button = '<span class="label label-info">Book Not Available For Issue</span>';
			}
		}
		else
		{
			$Button = '<input type="button" id ="'.$r->Id.'" name="btn_accept" value="Accept" class="btn btn-primary btn-xs req_allow"/> <input type="button" id ="'.$r->Id.'" name="btn_reject" value="Deny" class="btn btn-warning btn-xs req_deny"/>'
		}	

		push(@{$c->stash->{messages}},{
				No => $count++,
				RequestedDate =>$r->RequestDate,
				EmployeeName => $r->get_column('Employee Name'),
				BookId => $r->BookId,
				BookName => $r->get_column('Book Name'),
				Button => $Button
			});
	}
}
sub managerequest : Local
{
	my($self,$c) = @_;
	my $req_id = $c->req->params->{id};
	my $response = $c->req->params->{response};
	my $loginId = $c->user->Id;
	my $data = $c->model('Library::Transaction')->search({"Id" => $req_id});
	if($response eq 'Allow')
	{
		$data->update({"UpdatedBy" => $loginId });
	}
	else
	{
		$data->update({
						"Status" => 'Denied', 
						"UpdatedBy" => $loginId
					});
	}

	$c->forward('request');
	$c->stash->{template} = "admindashboard/request.tt";
}
sub getbookcopies : Local
{
	my($self,$c) = @_;
	my $req_id = $c->req->params->{req_id};
	my $trans = $c->model('Library::Transaction')->search({"Id" =>$req_id });
	my $t;
	if ($t = $trans->next)
	{
		$c->log->info( $t->BookId);
	}
	my $bookid = $t->BookId;	
	my @books = $c->model('Library::BookCopy')->search(
				{
					"Status" => 'Available',
					"BookId" => $bookid
				});
	foreach my $b (@books)
	{
		$c->log->info($b->Id);
		push(@{$c->stash->{books}},$b->Id);		
	}

	$c->forward('View::JSON');
}

sub issuebook : Local
{
	my($self,$c) = @_;
	my $req_id = $c->req->params->{req_id};
	my $bookcopy_id = $c->req->params->{bc_id};
	my $ExpectedReturnedDate;

	my $loginId = $c->user->Id;
	my $current_date  = DateTime->now(time_zone => 'Asia/Kolkata');
	my $issuedate = $current_date->ymd('-') . " " . $current_date->hms(':');
	my $maxallowday ;

	my $config = $c->model('Library::Config')->search({});
	if(my $con = $config->next)
	{
		$maxallowday = $con->MaxAllowedDays;

	}
	my $expectedreturn_date = $current_date->add(days => $maxallowday);
	$ExpectedReturnedDate = $expectedreturn_date->ymd('-') . " " . $expectedreturn_date->hms(':');

	my $data = $c->model('Library::Transaction')->search({"Id" => $req_id});
	$data->update({
					"BookCopyId" => $bookcopy_id, 
					"Status" => 'Issued', 
					"IssuedBy" => $loginId, 
					"IssuedDate" => $issuedate, 
					"ExpectedReturnDate"=> $ExpectedReturnedDate 
				});

			$data = $c->model('Library::BookCopy')->search({"Id" => $bookcopy_id});
			$data->update({"Status" => 'Reading' });

			$c->forward('request');
			$c->stash->{template} = "admindashboard/request.tt";
		}
		sub book : Path('/book')
		{
			my($self,$c) = @_;
			my $count=1;

			my @array = $c->model('Library::Book')->search({
					Status => {'!=','Removed'},
				},
				{ join => 'book_copies',
					'+select' => ['book_copies.Status'],
					'+as' => ['Status'],
					order_by => [qw/me.Id/],
				});

			$c->stash->{user} = $c->user->Name;
			my %books;
			foreach my $ar (@array)
			{   
				if(! exists($books{$ar->Id}))
				{   $books{$ar->Id} = { 
						Count => $count++,  
						Id => $ar->Id,
						Name => $ar->Name,
						Type => $ar->Type,
						Author => $ar->Author,
						Status => $ar->get_column('Status')
					}   
				}   
				elsif($books{$ar->Id}{Status} eq "Reading" and $ar->get_column('Status') eq "Available")
				{   
					$books{$ar->Id}{Status} = "Available";
				}

			}
			$c->stash->{messages} = \%books;

}






sub copy_details :Local
{

	my ($self,$c)=@_;
	my $bookid=$c->req->params->{Id};
	my $count=1;
	my @array = $c->model('Library::Transaction')->search({
			'me.BookId' => $bookid,
			'book_copy.Status'=> {'!=', 'Removed'}
		},
		{
			join => ['employee','book_copy'],
			'+select' => ['employee.Name','book_copy.Status','book_copy.Id'],
			'+as' => ['EmpName','Status','Id'],
		});
	print Dumper \@array;
push( @{$c->stash->{detail}},{
		Count => $count++,
		Id => $_->get_column('Id'),
		EmpName => $_->get_column('EmpName'),
		Status => $_->get_column('Status'),
		IssuedDate => $_->IssuedDate,
		ReturnDate => $_->ExpectedReturnDate,
	}) foreach @array;
$c->forward('View::JSON');

}

 sub delete_copy :Local
 {
my  ($self,$c)=@_;
  my $copyid = $c->req->params->{CopyId};
  my $del_copy =$c->model('Library::BookCopy')->find({ Id => $copyid });
  $del_copy->Status('Removed');
	 $del_copy->update;
  $c->forward('copy_details');
  }

sub addBook :Local
{
	my ($self, $c) =@_;

	my $name = $c->request->params->{'name'};
	my $author = $c->request->params->{'author'};
	my $type = $c->request->params->{'type'};
	my $noOfCopies = $c->request->params->{'count'};
	my $loginId = $c->user->Id;
	my $datestring =strftime " %F %X", gmtime;
	my $adminId = $c->user->Id;
	my @respdata = $c->model('Library::Book')->create({

			Name =>$name,
			Type =>$type,
			Author =>$author,
			NoOfCopies =>$noOfCopies,
			AddedOn =>$datestring,
			AddedBy =>$adminId, 	

		});
	$c->stash->{message} ="Book added sucessfully";
	$c->forward('View::JSON');
}

sub Book_request : Local
{

	my ($self ,$c) = @_;
	my $maxbookFromConfig =0;
	my $bookId = $c->request->params->{'bookId'};
	my $loginId =$c->user->Id;
	my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
	my $requestdate = $current_date->ymd('-') . " " . $current_date->hms(':');


	my @maxAllowbookQuery = $c->model('Library::Config')->search(undef,{
			select =>'MaxAllowedBooks',
		});       


	foreach my $MaxBook (@maxAllowbookQuery) 
	{
		$maxbookFromConfig = $MaxBook->MaxAllowedBooks;
	}


	my $validateBook = $c->model('Library::Transaction')->search({
			"Status"=>'Requested',
			"EmployeeId" => $loginId,
		}); 
	my $numberOfRequest = $validateBook->count;


	$c->log->info($bookId);	
	if($maxbookFromConfig > $numberOfRequest)
	{
		my @reqbook = $c->model('Library::Transaction')->create({
				"BookId" =>$bookId,
				"EmployeeId" =>$loginId,
				"Status" => 'Requested',
				"RequestDate" =>$requestdate,
			});
		$c->forward('View::JSON');
	}
	else
	{

		$c->stash->{deniedRequest}  ="Each person Have maximum 2 Book Request";
		$c->forward('View::JSON');
	}	
}	


sub bookreturn : Path('/bookreturn')
{
    my ( $self, $c ) = @_;

}



sub gettransactionbycopyid : Local
{
	my ( $self, $c ) = @_;
	my $copyid = $c->req->params->{copy_id};
	my $trans = $c->model('Library::Transaction')->search(
				{
					"me.BookCopyId" => $copyid,
					"me.Status" => 'Issued',
					"me.ReturnedDate" => {'=', undef}
				},	
				{
					join => ['employee','book'],
					'+select' => ['employee.Name','book.Name'],
					'+as' => ['Employee Name','Book Name']
				});
	if(my $t = $trans->next)
	{
		$c->stash->{flag} = 1;
		$c->stash->{id} = $t->EmployeeId;
		$c->stash->{empname} =  $t->get_column('Employee Name');
		$c->stash->{bookname} = $t->get_column('Book Name');
		$c->stash->{issuedate} = $t->IssuedDate;
		$c->stash->{ereturndate} = $t->ExpectedReturnDate;
	}
	else
	{
		$c->stash->{flag} = 0;
	}
	$c->forward('View::JSON');
}



sub returnbook : Local
{
	my ( $self, $c ) = @_;

	my $loginId =$c->user->Id;
	my $bookcopy_id = $c->req->params->{copy_id};
	my $comment = $c->req->params->{comment};
	my $current_date  = DateTime->now(time_zone => 'Asia/Kolkata');
	my $ReturnedDate = $current_date->ymd('-') . " " . $current_date->hms(':');
	$c->log->info($bookcopy_id);	
	my $data = $c->model('Library::Transaction')->search({"BookCopyId" => $bookcopy_id});
	$data->update({
					"ReturnedDate" => $ReturnedDate,
					"RecivedBy" =>$loginId ,
					"Comment" => $comment
					
				});
	$data = $c->model('Library::BookCopy')->search({"Id" => $bookcopy_id});
	$data->update({"Status" => 'Available'});
	$c->stash->{result} = 1; 	
	$c->forward('View::JSON');
}


sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->response->body('Matched ExcelLibrary::Controller::AdminDashboard in AdminDashboard.');
}

=encoding utf8

=head1 AUTHOR

venkatesan,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
