package Schema::Result::Employee;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Schema::Result::Employee

=cut

__PACKAGE__->table("Employee");

=head1 ACCESSORS

=head2 Id

  accessor: 'id'
  data_type: 'integer'
  default_value: nextval('"Employee_Id_seq"'::regclass)
  is_nullable: 0

=head2 Name

  accessor: 'name'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 Role

  accessor: 'role'
  data_type: '"emprole"'
  is_nullable: 1
  size: 4

=head2 Email

  accessor: 'email'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 Password

  accessor: 'password'
  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 Status

  accessor: 'status'
  data_type: '"empstatus"'
  default_value: 'InActive'::"EmpStatus'
  is_nullable: 1
  size: 4

=head2 Token

  accessor: 'token'
  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 CreatedBy

  accessor: 'created_by'
  data_type: 'integer'
  is_nullable: 1

=head2 CreatedOn

  accessor: 'created_on'
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
    default_value => \"nextval('\"Employee_Id_seq\"'::regclass)",
    is_nullable   => 0,
  },
  "Name",
  { accessor => "name", data_type => "varchar", is_nullable => 1, size => 50 },
  "Role",
  { accessor => "role", data_type => "\"emprole\"", is_nullable => 1, size => 4 },
  "Email",
  { accessor => "email", data_type => "varchar", is_nullable => 1, size => 50 },
  "Password",
  {
    accessor => "password",
    data_type => "varchar",
    is_nullable => 1,
    size => 40,
  },
  "Status",
  {
    accessor => "status",
    data_type => "\"empstatus\"",
    default_value => "InActive'::\"EmpStatus",
    is_nullable => 1,
    size => 4,
  },
  "Token",
  { accessor => "token", data_type => "varchar", is_nullable => 1, size => 20 },
  "CreatedBy",
  { accessor => "created_by", data_type => "integer", is_nullable => 1 },
  "CreatedOn",
  { accessor => "created_on", data_type => "timestamp", is_nullable => 1 },
  "UpdatedBy",
  { accessor => "updated_by", data_type => "integer", is_nullable => 1 },
  "UpdatedOn",
  { accessor => "updated_on", data_type => "timestamp", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("Id");

=head1 RELATIONS

=head2 comments

Type: has_many

Related object: L<Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "Schema::Result::Comment",
  { "foreign.EmployeeId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transactions

Type: has_many

Related object: L<Schema::Result::Transaction>

=cut

__PACKAGE__->has_many(
  "transactions",
  "Schema::Result::Transaction",
  { "foreign.EmployeeId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-11-04 10:57:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tn4n6OXfOqve37Z6Aq7TYw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
