package ExcelLibrary::Model::Library;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'ExcelLibrary::Schema::Library',
    
    connect_info => {
        dsn => 'dbi:Pg:database=Library',
        user => 'skanda',
        password => 'skanda',
		quote_field_names => "0",
		quote_char        => "\"",
		name_sep          => ".",
		array_datatypes   => "1",
	}
);

=head1 NAME

ExcelLibrary::Model::Library - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<ExcelLibrary>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<ExcelLibrary::Schema::Library>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.65

=head1 AUTHOR

venkatesan

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
