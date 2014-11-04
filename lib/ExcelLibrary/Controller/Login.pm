package ExcelLibrary::Controller::Login;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ExcelLibrary::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub login:Path :Args(0) {
	my ( $self, $c ) = @_;

	my $dt_params = $c->req->params;
	my $digest = md5_hex($dt_params->{password});
	print Dumper $digest;



my @collected=$c->model('Library::Employee')->search({});

print Dumper \@collected;


}

=encoding utf8

=head1 AUTHOR

skanda,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
