use utf8;
package MyClass::Schema::Result::Mark;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Mark

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<marks>

=cut

__PACKAGE__->table("marks");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 subject_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 marks_1

  data_type: 'float'
  is_nullable: 1

=head2 marks_2

  data_type: 'float'
  is_nullable: 1

=head2 marks_3

  data_type: 'float'
  is_nullable: 1

=head2 marks_total

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "subject_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "marks_1",
  { data_type => "float", is_nullable => 1 },
  "marks_2",
  { data_type => "float", is_nullable => 1 },
  "marks_3",
  { data_type => "float", is_nullable => 1 },
  "marks_total",
  { data_type => "float", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 student

Type: belongs_to

Related object: L<MyClass::Schema::Result::Student>

=cut

__PACKAGE__->belongs_to(
  "student",
  "MyClass::Schema::Result::Student",
  { id_student => "student_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 subject

Type: belongs_to

Related object: L<MyClass::Schema::Result::Subject>

=cut

__PACKAGE__->belongs_to(
  "subject",
  "MyClass::Schema::Result::Subject",
  { id_subject => "subject_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-03-31 10:00:49
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H0pI1FoCQxRfLpBQuE03cw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
