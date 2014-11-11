package ExcelLibrary::Controller::AdminDashboard;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use JSON;
use DateTime;
use POSIX qw(strftime);
BEGIN { extends 'Catalyst::Controller'; }

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
		#$c->log->info(Dumper \@request);	
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
			$Button = '<input type="button" id ="'.$r->Id.'" name="btn_accept" value="Accept" class="btn btn-primary btn-xs req_allow"/> '
		   				+'<input type="button" id ="'.$r->Id.'" name="btn_reject" value="Deny" class="btn btn-warning btn-xs req_deny"/>'
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
	my $data = $c->model('Library::Transaction')->search({"Id" => $req_id});
	if($response eq 'Allow')
	{
		$data->update({"UpdatedBy" => '1' });
	}
	else
	{
		$data->update({
						"Status" => 'Denied', 
						"UpdatedBy" => '1'
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

	#-------------------this should get from session------------------
	my $issueby = 1;

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
					"IssuedBy" => 1, 
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
	             Status => 'Available',
	         },
	         { join => 'book_copies',
	             '+select' => ['book_copies.Status'],
	             '+as' => ['Status'],
	             group_by => [qw/me.Id book_copies.Status/],
	             order_by => [qw/me.Id/]
	         });
	     print Dumper \@array;
     push( @{$c->stash->{messages}},{
             Count => $count++,
             Id => $_->Id,
             Name => $_->Name,
             Type => $_->Type,
             Status => $_->get_column('Status'),
         }) foreach @array;
}
sub bookreturn : Path('/bookreturn')
{
    my ( $self, $c ) = @_;

}
sub gettransactionbycopyid : Local
{
	my ( $self, $c ) = @_;
	my $copyid = $c->req->params->{copy_id};
	$c->log->info($copyid);
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
	$c->log->info(Dumper $trans);
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
	my $bookcopy_id = $c->req->params->{copy_id};
	my $comment = $c->req->params->{comment};
	my $current_date  = DateTime->now(time_zone => 'Asia/Kolkata');
	my $ReturnedDate = $current_date->ymd('-') . " " . $current_date->hms(':');
	$c->log->info($bookcopy_id);	
	my $data = $c->model('Library::Transaction')->search({"BookCopyId" => $bookcopy_id});
	$data->update({
					"ReturnedDate" => $ReturnedDate,
					"RecivedBy" => 1,
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
