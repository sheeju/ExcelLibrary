use utf8;
package ExcelLibrary::Schema::Result::Book;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLibrary::Schema::Result::Book

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Book>

=cut

__PACKAGE__->table("Book");

=head1 ACCESSORS

=head2 Id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"Book_Id_seq"'

=head2 Name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 Type

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 Author

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 NoOfCopies

  data_type: 'integer'
  default_value: 1
  is_nullable: 1

=head2 AddedBy

  data_type: 'integer'
  is_nullable: 1

=head2 AddedOn

  data_type: 'timestamp'
  is_nullable: 1

=head2 UpdatedBy

  data_type: 'integer'
  is_nullable: 1

=head2 UpdatedOn

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "Id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "\"Book_Id_seq\"",
  },
  "Name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "Type",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "Author",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "NoOfCopies",
  { data_type => "integer", default_value => 1, is_nullable => 1 },
  "AddedBy",
  { data_type => "integer", is_nullable => 1 },
  "AddedOn",
  { data_type => "timestamp", is_nullable => 1 },
  "UpdatedBy",
  { data_type => "integer", is_nullable => 1 },
  "UpdatedOn",
  { data_type => "timestamp", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</Id>

=back

=cut

__PACKAGE__->set_primary_key("Id");

=head1 RELATIONS

=head2 book_copies

Type: has_many

Related object: L<ExcelLibrary::Schema::Result::BookCopy>

=cut

__PACKAGE__->has_many(
  "book_copies",
  "ExcelLibrary::Schema::Result::BookCopy",
  { "foreign.BookId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 comments

Type: has_many

Related object: L<ExcelLibrary::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "ExcelLibrary::Schema::Result::Comment",
  { "foreign.BookId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transactions

Type: has_many

Related object: L<ExcelLibrary::Schema::Result::Transaction>

=cut

__PACKAGE__->has_many(
  "transactions",
  "ExcelLibrary::Schema::Result::Transaction",
  { "foreign.BookId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 13:03:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:HK3WB9hmCYTktOrjW1XqGg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
