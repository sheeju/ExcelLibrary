use utf8;
package ExcelLibrary::Schema::Result::Employee;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

ExcelLibrary::Schema::Result::Employee

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Employee>

=cut

__PACKAGE__->table("Employee");

=head1 ACCESSORS

=head2 Id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"Employee_Id_seq"'

=head2 Name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 Role

  data_type: '"emprole"'
  is_nullable: 1
  size: 4

=head2 Email

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 Password

  data_type: 'varchar'
  is_nullable: 1
  size: 40

=head2 Status

  data_type: '"empstatus"'
  default_value: 'InActive'::"EmpStatus'
  is_nullable: 1
  size: 4

=head2 Token

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=head2 CreatedBy

  data_type: 'integer'
  is_nullable: 1

=head2 CreatedOn

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
    sequence          => "\"Employee_Id_seq\"",
  },
  "Name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "Role",
  { data_type => "\"emprole\"", is_nullable => 1, size => 4 },
  "Email",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "Password",
  { data_type => "varchar", is_nullable => 1, size => 40 },
  "Status",
  {
    data_type => "\"empstatus\"",
    default_value => "InActive'::\"EmpStatus",
    is_nullable => 1,
    size => 4,
  },
  "Token",
  { data_type => "varchar", is_nullable => 1, size => 20 },
  "CreatedBy",
  { data_type => "integer", is_nullable => 1 },
  "CreatedOn",
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

=head2 comments

Type: has_many

Related object: L<ExcelLibrary::Schema::Result::Comment>

=cut

__PACKAGE__->has_many(
  "comments",
  "ExcelLibrary::Schema::Result::Comment",
  { "foreign.EmployeeId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 transactions

Type: has_many

Related object: L<ExcelLibrary::Schema::Result::Transaction>

=cut

__PACKAGE__->has_many(
  "transactions",
  "ExcelLibrary::Schema::Result::Transaction",
  { "foreign.EmployeeId" => "self.Id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-04 13:03:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:YWZv3JW9C5M/ebLvh6m1GQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
