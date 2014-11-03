package ExcelLibrary::Controller::UserDashboard;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ExcelLibrary::Controller::UserDashboard - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub emp :Path :Args(0) {
    my ( $self, $c ) = @_;

}



=encoding utf8

=head1 AUTHOR

Pavan,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
