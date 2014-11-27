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

sub index : Path('/login')
{
    my ($self, $c) = @_;
    my $token = $c->req->params->{token} || undef;
	
    if ($c->req->method eq "POST") {
        my $password = md5_hex($c->req->params->{password});
        if (
            $c->authenticate(
                {
                    "Email"    => $c->req->params->{'email'},
                    "Password" => $password,
                    "Status"   => 'Active'
                }
            )
          )
        {
            $c->res->redirect($c->uri_for_action('dashboard/dashboard'));
        }
        else {
            if (defined $c->req->params->{email}) {
                $c->stash->{failmessage} = 1;
            }
            else {
                $c->stash->{failmessage} = 0;
            }
        }
    }
    else {
        if (defined $token ) {
            my $employee_rs = $c->model('Library::Employee')->search({Token => $token});
            my $employee = $employee_rs->next;

            if ($employee->Status eq 'InActive') {
                $c->stash->{token}    = $token;
                $c->stash->{template} = "login/createpassword.tt";
            }
            else {
                $c->stash->{template} = "login/index.tt";
            }
        }
        else {
            $c->stash->{template} = "login/index.tt";
        }
    }
    $c->forward('View::TT');
}

sub createpassword : Local
{
    my ($self, $c) = @_;

    my $password    = md5_hex($c->req->params->{password});
    my $token       = $c->req->params->{token};
    my $employee_rs = $c->model('Library::Employee')->search({Token => $token});

    $employee_rs->update(
        {
            "Password" => $password,
            "Status"   => 'Active'
        }
    );

    $c->forward('View::JSON');
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
