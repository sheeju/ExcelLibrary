package Schema::Result::Config;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Schema::Result::Config

=cut

__PACKAGE__->table("Config");

=head1 ACCESSORS

=head2 MaxAllowedDays

  accessor: 'max_allowed_days'
  data_type: 'integer'
  is_nullable: 1

=head2 MaxAllowedBooks

  accessor: 'max_allowed_books'
  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "MaxAllowedDays",
  {
    accessor    => "max_allowed_days",
    data_type   => "integer",
    is_nullable => 1,
  },
  "MaxAllowedBooks",
  {
    accessor    => "max_allowed_books",
    data_type   => "integer",
    is_nullable => 1,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-11-04 10:57:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:8Cf4hNK/qPtxit5H3H1s4w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
