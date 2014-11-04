package Schema::Result::BookCopy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Schema::Result::BookCopy

=cut

__PACKAGE__->table("BookCopy");

=head1 ACCESSORS

=head2 Id

  accessor: 'id'
  data_type: 'integer'
  default_value: nextval('"BookCopy_Id_seq"'::regclass)
  is_nullable: 0

=head2 BookId

  accessor: 'book_id'
  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 Status

  accessor: 'status'
  data_type: '"bookstatus"'
  default_value: 'Available'::"BookStatus'
  is_nullable: 1
  size: 4

=head2 Remarks

  accessor: 'remarks'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "Id",
  {
    accessor      => "id",
    data_type     => "integer",
    default_value => \"nextval('\"BookCopy_Id_seq\"'::regclass)",
    is_nullable   => 0,
  },
  "BookId",
  {
    accessor       => "book_id",
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 1,
  },
  "Status",
  {
    accessor => "status",
    data_type => "\"bookstatus\"",
    default_value => "Available'::\"BookStatus",
    is_nullable => 1,
    size => 4,
  },
  "Remarks",
  { accessor => "remarks", data_type => "varchar", is_nullable => 1, size => 50 },
);
__PACKAGE__->set_primary_key("Id");

=head1 RELATIONS

=head2 book

Type: belongs_to

Related object: L<Schema::Result::Book>

=cut

__PACKAGE__->belongs_to(
  "book",
  "Schema::Result::Book",
  { Id => "BookId" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 transactions

Type: has_many

Related object: L<Schema::Result::Transaction>

=cut

__PACKAGE__->has_many(
  "transactions",
  "Schema::Result::Transaction",
  { "foreign.BookCopyId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-11-04 10:57:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pmC0G3KNIyRC+cmbQ8JYrw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
