package ExcelLibrary::Controller::AdminDashboard;
use Moose;
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
