package Schema::Result::Comment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

Schema::Result::Comment

=cut

__PACKAGE__->table("Comment");

=head1 ACCESSORS

=head2 Id

  accessor: 'id'
  data_type: 'integer'
  default_value: nextval('"Comment_Id_seq"'::regclass)
  is_nullable: 0

=head2 Comment

  accessor: 'comment'
  data_type: 'text'
  is_nullable: 1

=head2 BookId

  accessor: 'book_id'
  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 EmployeeId

  accessor: 'employee_id'
  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 CommentedDate

  accessor: 'commented_date'
  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "Id",
  {
    accessor      => "id",
    data_type     => "integer",
    default_value => \"nextval('\"Comment_Id_seq\"'::regclass)",
    is_nullable   => 0,
  },
  "Comment",
  { accessor => "comment", data_type => "text", is_nullable => 1 },
  "BookId",
  {
    accessor       => "book_id",
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
  "CommentedDate",
  {
    accessor    => "commented_date",
    data_type   => "timestamp",
    is_nullable => 1,
  },
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


# Created by DBIx::Class::Schema::Loader v0.07010 @ 2014-11-04 10:57:52
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:B8uqZPYxk/UYh8oQ+0Pwaw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
