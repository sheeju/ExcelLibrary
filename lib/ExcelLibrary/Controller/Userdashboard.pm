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
	my @array = $c->model('Library::Book')->search({
		Status => 'Available',
		},
		{ join => 'book_copies',
			'+select' => ['book_copies.Status'],
			'+as' => ['Status'],
			group_by => [qw/me.Id book_copies.Status/],
		});
my ($name,$type,$author,$status);
foreach my $var(@array)
{
	$name = $var->{_column_data}->{Name};
	$type = $var->{_column_data}->{Type};
	$author = $var->{_column_data}->{Author};
	$status = $var->{_column_data}->{Status};
}
	my $temp_hash = {
		Name => $name,
		Type => $type,
		Author => $author,
		Status => $status,
	};
	$c->stash->{messages}=JSON->new->utf8->encode($temp_hash);
	#$c->forward('View::JSON');
	print Dumper $temp_hash;

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
