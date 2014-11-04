use utf8;
package ExcelLibrary::Schema::Result::Config;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLibrary::Schema::Result::Config

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Config>

=cut

__PACKAGE__->table("Config");

=head1 ACCESSORS

=head2 MaxAllowedDays

  data_type: 'integer'
  is_nullable: 1

=head2 MaxAllowedBooks

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "MaxAllowedDays",
  { data_type => "integer", is_nullable => 1 },
  "MaxAllowedBooks",
  { data_type => "integer", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 13:03:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0OtUrRyGya6dBzmGbjfYiQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
