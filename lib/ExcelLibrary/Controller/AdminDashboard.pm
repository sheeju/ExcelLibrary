package ExcelLibrary::Controller::AdminDashboard;
use Moose;
use Data::Dumper;
use DBIx::Class;
use namespace::autoclean;

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
	my @result = $c->model('Library::Transaction')->search(
			{
		
				"me.Status" => 'Requested'
			},
			{
				join => ['employee','book'],
					'+select' => ['employee.Name','book.Name'],
					'+as' => ['Employee Name','Book Name']
	});
	
	$c->log->info(Dumper \@result);	
	foreach $r (@result)
	{
		push(@{$c->stash->{messages}},{
			No => $count++,
			reqid => $r->Id,
			RequestedDate =>$r->RequestDate,
			EmployeeName => $r->get_column('Employee Name'),
			BookId => $r->BookId,
			BookName => $r->get_column('Book Name')
		});
	}
}
sub mangerequest : local
{
	my($self,$c) = @_
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
