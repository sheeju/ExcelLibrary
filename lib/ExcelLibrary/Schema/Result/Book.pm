package Schema::Result::Book;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Schema::Result::Book

=cut

__PACKAGE__->table("Book");

=head1 ACCESSORS

=head2 Id

  accessor: 'id'
  data_type: 'integer'
  default_value: nextval('"Book_Id_seq"'::regclass)
  is_nullable: 0

=head2 Name

  accessor: 'name'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 Type

  accessor: 'type'
  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 Author

  accessor: 'author'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 NoOfCopies

  accessor: 'no_of_copies'
  data_type: 'integer'
  default_value: 1
  is_nullable: 1

=head2 AddedBy

  accessor: 'added_by'
  data_type: 'integer'
  is_nullable: 1

=head2 AddedOn

  accessor: 'added_on'
  data_type: 'timestamp'
  is_nullable: 1

=head2 UpdatedBy

  accessor: 'updated_by'
  data_type: 'integer'
  is_nullable: 1

=head2 UpdatedOn

  accessor: 'updated_on'
  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "Id",
  {
    accessor      => "id",
    data_type     => "integer",
    default_value => \"nextval('\"Book_Id_seq\"'::regclass)",
    is_nullable   => 0,
  },
  "Name",
  { accessor => "name", data_type => "varchar", is_nullable => 1, size => 50 },
  "Type",
  { accessor => "type", data_type => "varchar", is_nullable => 1, size => 30 },
  "Author",
  { accessor => "author", data_type => "varchar", is_nullable => 1, size => 50 },
  "NoOfCopies",
  {
    accessor      => "no_of_copies",
    data_type     => "integer",
    default_value => 1,
    is_nullable   => 1,
  },
  "AddedBy",
  { accessor => "added_by", data_type => "integer", is_nullable => 1 },
  "AddedOn",
  { accessor => "added_on", data_type => "timestamp", is_nullable => 1 },
  "UpdatedBy",
  { accessor => "updated_by", data_type => "integer", is_nullable => 1 },
  "UpdatedOn",
  { accessor => "updated_on", data_type => "timestamp", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("Id");

=head1 RELATIONS

=head2 book_copies

Type: has_many

Related object: L<Schema::Result::BookCopy>

=cut

__PACKAGE__->has_many(
  "book_copies",
  "Schema::Result::BookCopy",
  { "foreign.BookId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 comments

Type: has_many

Related object: L<Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "Schema::Result::Comment",
  { "foreign.BookId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transactions

Type: has_many

Related object: L<Schema::Result::Transaction>

=cut

__PACKAGE__->has_many(
  "transactions",
  "Schema::Result::Transaction",
  { "foreign.BookId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-11-04 10:57:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Qe340NIj6bHZRMwGZU6yzQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
