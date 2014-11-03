package LibraryManagement::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

LibraryManagement::View::TT - TT View for LibraryManagement

=head1 DESCRIPTION

TT View for LibraryManagement.

=head1 SEE ALSO

L<LibraryManagement>

=head1 AUTHOR

Pavan,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
