package ExcelLibrary::Schema::Library;

use strict;
use base qw/DBIx::Class::Schema::Loader/;

__PACKAGE__->loader_options(
    relationships => '1',
    use_moose => '1',
    col_collision_map => 'column_%s',
    use_namespaces => '1',
    components => ["InflateColumn::DateTime"],
);

=head1 NAME

ExcelLibrary::Schema::Library - L<DBIx::Class::Schema::Loader> class

=head1 SYNOPSIS

See L<ExcelLibrary>

=head1 DESCRIPTION

Dynamic L<DBIx::Class::Schema::Loader> schema for use in L<ExcelLibrary::Model::Library>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.65

=head1 AUTHOR

venkatesan

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

