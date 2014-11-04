use utf8;
package ExcelLibrary::Schema::Result::BookCopy;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLibrary::Schema::Result::BookCopy

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<BookCopy>

=cut

__PACKAGE__->table("BookCopy");

=head1 ACCESSORS

=head2 Id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"BookCopy_Id_seq"'

=head2 BookId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 Status

  data_type: '"bookstatus"'
  default_value: 'Available'::"BookStatus'
  is_nullable: 1
  size: 4

=head2 Remarks

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "Id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "\"BookCopy_Id_seq\"",
  },
  "BookId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "Status",
  {
    data_type => "\"bookstatus\"",
    default_value => "Available'::\"BookStatus",
    is_nullable => 1,
    size => 4,
  },
  "Remarks",
  { data_type => "varchar", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</Id>

=back

=cut

__PACKAGE__->set_primary_key("Id");

=head1 RELATIONS

=head2 book

Type: belongs_to

Related object: L<ExcelLibrary::Schema::Result::Book>

=cut

__PACKAGE__->belongs_to(
  "book",
  "ExcelLibrary::Schema::Result::Book",
  { Id => "BookId" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 transactions

Type: has_many

Related object: L<ExcelLibrary::Schema::Result::Transaction>

=cut

__PACKAGE__->has_many(
  "transactions",
  "ExcelLibrary::Schema::Result::Transaction",
  { "foreign.BookCopyId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 13:03:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IVXGfC8VFovbHfXYZs6yzA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
