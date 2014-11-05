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

=pod
sub validate:Local {
	my ( $self, $c ) = @_;
	my $dt_params = $c->req->params;
	my $enter_password = $dt_params->{password};
	my $enter_email = $dt_params->{email};	
#	my $digest = md5_hex($dt_params->{password});
#	print Dumper $digest;


	my $userInfo = $c->model('Library::Employee')->search({"Email" =>$dt_params->{email}},{"Password" =>$enter_password});
	my $user;	

	if($user = $userInfo->next)
	{
		if ($user->Role eq 'Admin')
		{

			$c->log->info("admin");
		}
		else
		{
			$c->log->info("employee");
		}
	}
	else
	{
		print Dumper "doesnot match";
		$c->stash->{failmsg}  = "does not match user name and password";
	}

	$c->forward('View::JSON');

}
=cut

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
			print Dumper "Login into user Dashboard-------------------------------- $userId---------$userName" ;
		}
		else
		{
			my $adminName =$c->user->Name;
			my $adminId =$c->user->Id;
			print Dumper "Login into admin Dashboard-------------------------------- $adminId---------$adminName" ;
		}
	} 
	else {
		$c->stash->{failmsg}  = "does not match user name and password";
	}
	$c->forward('View::JSON');
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
