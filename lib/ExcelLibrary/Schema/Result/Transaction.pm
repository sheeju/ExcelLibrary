package Schema::Result::Transaction;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Schema::Result::Transaction

=cut

__PACKAGE__->table("Transaction");

=head1 ACCESSORS

=head2 Id

  accessor: 'id'
  data_type: 'integer'
  default_value: nextval('"Transaction_Id_seq"'::regclass)
  is_nullable: 0

=head2 BookId

  accessor: 'book_id'
  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 BookCopyId

  accessor: 'book_copy_id'
  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 EmployeeId

  accessor: 'employee_id'
  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 Status

  accessor: 'status'
  data_type: '"transstatus"'
  is_nullable: 1
  size: 4

=head2 RequestDate

  accessor: 'request_date'
  data_type: 'timestamp'
  is_nullable: 1

=head2 IssuedDate

  accessor: 'issued_date'
  data_type: 'timestamp'
  is_nullable: 1

=head2 IssuedBy

  accessor: 'issued_by'
  data_type: 'integer'
  is_nullable: 1

=head2 ExpectedReturnDate

  accessor: 'expected_return_date'
  data_type: 'timestamp'
  is_nullable: 1

=head2 ReturnedDate

  accessor: 'returned_date'
  data_type: 'timestamp'
  is_nullable: 1

=head2 RecivedBy

  accessor: 'recived_by'
  data_type: 'integer'
  is_nullable: 1

=head2 UpdatedBy

  accessor: 'updated_by'
  data_type: 'integer'
  is_nullable: 1

=head2 Comment

  accessor: 'comment'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "Id",
  {
    accessor      => "id",
    data_type     => "integer",
    default_value => \"nextval('\"Transaction_Id_seq\"'::regclass)",
    is_nullable   => 0,
  },
  "BookId",
  {
    accessor       => "book_id",
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 1,
  },
  "BookCopyId",
  {
    accessor       => "book_copy_id",
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 1,
  },
  "EmployeeId",
  {
    accessor       => "employee_id",
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 1,
  },
  "Status",
  {
    accessor => "status",
    data_type => "\"transstatus\"",
    is_nullable => 1,
    size => 4,
  },
  "RequestDate",
  { accessor => "request_date", data_type => "timestamp", is_nullable => 1 },
  "IssuedDate",
  { accessor => "issued_date", data_type => "timestamp", is_nullable => 1 },
  "IssuedBy",
  { accessor => "issued_by", data_type => "integer", is_nullable => 1 },
  "ExpectedReturnDate",
  {
    accessor    => "expected_return_date",
    data_type   => "timestamp",
    is_nullable => 1,
  },
  "ReturnedDate",
  { accessor => "returned_date", data_type => "timestamp", is_nullable => 1 },
  "RecivedBy",
  { accessor => "recived_by", data_type => "integer", is_nullable => 1 },
  "UpdatedBy",
  { accessor => "updated_by", data_type => "integer", is_nullable => 1 },
  "Comment",
  { accessor => "comment", data_type => "varchar", is_nullable => 1, size => 50 },
);
__PACKAGE__->set_primary_key("Id");

=head1 RELATIONS

=head2 employee

Type: belongs_to

Related object: L<Schema::Result::Employee>

=cut

__PACKAGE__->belongs_to(
  "employee",
  "Schema::Result::Employee",
  { Id => "EmployeeId" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 book_copy

Type: belongs_to

Related object: L<Schema::Result::BookCopy>

=cut

__PACKAGE__->belongs_to(
  "book_copy",
  "Schema::Result::BookCopy",
  { Id => "BookCopyId" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-11-04 10:57:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MQqA61MFTWlg/Jlkj4Cl8A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
