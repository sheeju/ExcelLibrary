package ExcelLibrary::Controller::Login;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use JSON;
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

sub index : Path('/login') : Args(0)
{
    my ($self, $c) = @_;
    if ($c->req->method eq 'POST') {

        if (
            $c->authenticate(
                {
                    "Email"    => $c->request->params->{'email'},
                    "Password" => $c->request->params->{'password'}
                }
            )
          )

        {
            $c->res->redirect($c->uri_for_action('dashboard/dashboard'));
            $c->stash->{template} = "dashboard/dashboard.tt";
            $c->forward('View::TT');
        }
        else {

            $c->stash->{failmessage} = 1;

            #  $c->forward('View::JSON');
        }

    }
    $c->forward('View::TT');
}

sub logout : Local
{
    my ($self, $c) = @_;
    $c->logout();
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
