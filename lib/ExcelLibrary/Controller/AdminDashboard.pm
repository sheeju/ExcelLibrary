package ExcelLibrary::Controller::AdminDashboard;
use Moose;
use namespace::autoclean;
use Data::Dumper;
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
}
sub request : Path('/request')
{
	my($self,$c) = @_;
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




sub addBook :Local
{
	my ($self, $c) =@_;

	my $name = $c->request->params->{'name'};
	my $author = $c->request->params->{'author'};
	my $type = $c->request->params->{'type'};
	my $noOfCopies = $c->request->params->{'count'};

	my $datestring =strftime " %F %X", gmtime;
	my $adminId = $c->user->Id;
	my @respdata = $c->model('Library::Book')->create({

			Name =>$name,
			Type =>$type,
			Author =>$author,
			NoOfCopies =>$noOfCopies,
			AddedOn =>$datestring,
			#	addedBy =>$adminId, 	

		});
	$c->stash->{message} ="Book added sucessfully";
	$c->forward('View::JSON');
}

sub Book_request : Local
{

	my ($self ,$c) = @_;
	my $maxbookFromConfig =0;
	my $bookId = $c->request->params->{'bookId'};
	my $userId =$c->user->Id;
	my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
	my $requestdate = $current_date->ymd('-') . " " . $current_date->hms(':');
#	 $c->forward('View::JSON');


	my @maxAllowbookQuery = $c->model('Library::Config')->search(undef,{
			select =>'MaxAllowedBooks',
		});       

	foreach my $MaxBook (@maxAllowbookQuery) 
	{
		$maxbookFromConfig = $MaxBook->MaxAllowedBooks;
	}

	my $validateBook = $c->model('Library::Transaction')->search({
			"Status"=>'Requested',
			"EmployeeId" => $userId,
		}); 
	my $numberOfRequest = $validateBook->count;

	if($maxbookFromConfig > $numberOfRequest)
	{
		my @reqbook = $c->model('Library::Transaction')->create({
				BookId =>$bookId,
				EmployeeId =>9,
				Status => 'Requested',
				RequestDate =>$requestdate,
			});
		$c->forward('View::JSON');
	}
	else
	{

		$c->stash->{deniedRequest}  ="Each person Have maximum 2 Book Request";
		$c->forward('View::JSON');
	}	
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
