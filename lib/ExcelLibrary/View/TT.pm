package ExcelLibrary::View::TT;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
);

=head1 NAME

ExcelLibrary::View::TT - TT View for ExcelLibrary

=head1 DESCRIPTION

TT View for ExcelLibrary.

=head1 SEE ALSO

L<ExcelLibrary>

=head1 AUTHOR

venkatesan,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
