package ExcelLibrary::Controller::Userdashboard;
use Moose;
use namespace::autoclean;
use Data::Dumper;
use JSON;
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ExcelLibrary::Controller::Userdashboard - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub emp :Path :Args(0) {
	my ( $self, $c ) = @_;
	my $count=1;
	my @array = $c->model('Library::Book')->search({
			Status => {'!=', 'Removed'},
		},
		{ join => 'book_copies',
			'+select' => ['book_copies.Status'],
			'+as' => ['Status'],
			order_by => [qw/me.Id/]
		});
	$c->stash->{user} = $c->user->Name;
	my %books;
	foreach my $ar (@array)
	{
		if(! exists($books{$ar->Id}))
		{	$books{$ar->Id} = {
						Count => $count++,	
						Id => $ar->Id,
						Name => $ar->Name,
						Type => $ar->Type,
						Author => $ar->Author,
						Status => $ar->get_column('Status')
					}
		}
		elsif($books{$ar->Id}{Status} eq "Reading" and $ar->get_column('Status') eq "Available")
		{
			$books{$ar->Id}{Status} = "Available";
		}

	}
	$c->stash->{messages} = \%books;
	$c->log->info($c->stash->{messages});
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
