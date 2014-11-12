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

sub index : Path :Args(0) {
	my ($self ,$c ) =@_;
	$c->forward('View::TT');
}


sub validate :Local {

	my ($self, $c )  =@_;
#	my $digest = md5_hex($c->request->params->{password});
#	print Dumper $digest;

	if ($c->authenticate( { 
				"Email" => $c->request->params->{'email'}, 
				"Password" => $c->request->params->{'password'} 
			} ))

	{ 
		if($c->user->Role eq 'Employee')
		{
			my $userId =$c->user->Id;
			my $userName =$c->user->Name;
			$c->log->info("$userName-------------------------------------------------");
			$c->stash->{user} = $userName;
			$c->res->redirect($c->uri_for_action('userdashboard/emp'));
			$c->stash->{template} = "userdashboard/emp.tt";
			$c->forward('View::TT');
		}
		else
		{
			my $adminName =$c->user->Name;
			my $adminId =$c->user->Id;
			print Dumper "Login into admin Dashboard-------------------------------- $adminId---------$adminName" ;
			$c->res->redirect($c->uri_for_action('admindashboard/home'));
			$c->stash->{template} = "admindashboard/home.tt";
			$c->forward('View::TT');
		}
	} 
	else {

		$c->stash->{failmsg}  = "does not match user name and password";
		print "Inside Else-------------------------------------------\n";
		$c->forward('View::JSON');
	}

}


sub logout : Local {
	my ( $self, $c ) = @_;
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
