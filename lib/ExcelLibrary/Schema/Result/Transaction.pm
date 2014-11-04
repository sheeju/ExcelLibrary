use utf8;
package ExcelLibrary::Schema::Result::Transaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLibrary::Schema::Result::Transaction

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Transaction>

=cut

__PACKAGE__->table("Transaction");

=head1 ACCESSORS

=head2 Id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"Transaction_Id_seq"'

=head2 BookId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 BookCopyId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 EmployeeId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 Status

  data_type: '"transstatus"'
  is_nullable: 1
  size: 4

=head2 RequestDate

  data_type: 'timestamp'
  is_nullable: 1

=head2 IssuedDate

  data_type: 'timestamp'
  is_nullable: 1

=head2 IssuedBy

  data_type: 'integer'
  is_nullable: 1

=head2 ExpectedReturnDate

  data_type: 'timestamp'
  is_nullable: 1

=head2 ReturnedDate

  data_type: 'timestamp'
  is_nullable: 1

=head2 RecivedBy

  data_type: 'integer'
  is_nullable: 1

=head2 UpdatedBy

  data_type: 'integer'
  is_nullable: 1

=head2 Comment

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
    sequence          => "\"Transaction_Id_seq\"",
  },
  "BookId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "BookCopyId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "EmployeeId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "Status",
  { data_type => "\"transstatus\"", is_nullable => 1, size => 4 },
  "RequestDate",
  { data_type => "timestamp", is_nullable => 1 },
  "IssuedDate",
  { data_type => "timestamp", is_nullable => 1 },
  "IssuedBy",
  { data_type => "integer", is_nullable => 1 },
  "ExpectedReturnDate",
  { data_type => "timestamp", is_nullable => 1 },
  "ReturnedDate",
  { data_type => "timestamp", is_nullable => 1 },
  "RecivedBy",
  { data_type => "integer", is_nullable => 1 },
  "UpdatedBy",
  { data_type => "integer", is_nullable => 1 },
  "Comment",
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

=head2 book_copy

Type: belongs_to

Related object: L<ExcelLibrary::Schema::Result::BookCopy>

=cut

__PACKAGE__->belongs_to(
  "book_copy",
  "ExcelLibrary::Schema::Result::BookCopy",
  { Id => "BookCopyId" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 employee

Type: belongs_to

Related object: L<ExcelLibrary::Schema::Result::Employee>

=cut

__PACKAGE__->belongs_to(
  "employee",
  "ExcelLibrary::Schema::Result::Employee",
  { Id => "EmployeeId" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 13:03:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:CAVb/vSqmRVlSADmkCuS3Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
