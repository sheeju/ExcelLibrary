package ExcelLibrary::Controller::AdminDashboard;
use Moose;
use namespace::autoclean;
use Data::Dumper;
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
	foreach $r (@request)
	{
		my $Button;
		if($r->UpdatedBy == '')
		{
			$Button = '<input type="button" id ="'.$r->Id.'" name="btn_accept" value="Accept" class="btn btn-primary btn-xs req_allow"/> <input type="button" id ="'.$r->Id.'" name="btn_reject" value="Deny" class="btn btn-warning btn-xs req_deny"/>'
		}
		else
		{
			$Button = '<input type="button" id="'.$r->Id.'" name="btn_issue" value="Issue" class="btn btn-primary btn_sm book_issue"data-toggle="modal" data-target="#myModal"/>'
		}	

		push(@{$c->stash->{messages}},{
			No => $count++,
			reqid => $r->Id,
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
		$data->update({"Status" => 'Denied', "UpdatedBy" => '1'});
	}
	$c->forward('request');
	$c->stash->{template} = "admindashboard/request.tt";

}
sub getbookcopies : Local
{
	my($self,$c) = @_;
	my $req_id = $c->req->params->{req_id};
	my @books = $c->model('Library::BookCopy')->search(
		{
			"me.Status" => 'Available',
			"Transaction.Id" => $req_id
		},
		{
			join => 'Transaction'
		}
	);
	$c->log->info(Dumper @books);
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
