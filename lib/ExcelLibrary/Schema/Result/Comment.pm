use utf8;
package Schema::Result::Comment;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Schema::Result::Comment

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<Comment>

=cut

__PACKAGE__->table("Comment");

=head1 ACCESSORS

=head2 Id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: '"Comment_Id_seq"'

=head2 Comment

  data_type: 'text'
  is_nullable: 1

=head2 BookId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 EmployeeId

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 CommentedDate

  data_type: 'timestamp'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "Id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "\"Comment_Id_seq\"",
  },
  "Comment",
  { data_type => "text", is_nullable => 1 },
  "BookId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "EmployeeId",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "CommentedDate",
  { data_type => "timestamp", is_nullable => 1 },
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

Related object: L<Schema::Result::Book>

=cut

__PACKAGE__->belongs_to(
  "book",
  "Schema::Result::Book",
  { Id => "BookId" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
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
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2014-11-03 18:49:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ISoL0Gp+8C1eC9HfQ22erw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
