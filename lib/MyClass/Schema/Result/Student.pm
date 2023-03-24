use utf8;
package MyClass::Schema::Result::Student;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Student

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

=head1 TABLE: C<student>

=cut

__PACKAGE__->table("student");

=head1 ACCESSORS

=head2 id_student

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 full_name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 birthday

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 address

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 phone

  data_type: 'varchar'
  is_nullable: 0
  size: 11

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 password

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 avatar

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 class_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id_student",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "full_name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "birthday",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 0 },
  "address",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "phone",
  { data_type => "varchar", is_nullable => 0, size => 11 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "password",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "avatar",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "class_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_student>

=back

=cut

__PACKAGE__->set_primary_key("id_student");

=head1 RELATIONS

=head2 class

Type: belongs_to
=cut

__PACKAGE__->belongs_to(
  "class",
  "MyClass::Schema::Result::Class",
  { id_class => "class_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 marks

Type: has_many

Related object: L<MyClass::Schema::Result::Mark>

=cut

__PACKAGE__->has_many(
  "marks",
  "MyClass::Schema::Result::Mark",
  { "foreign.id_student" => "self.id_student" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-03-24 10:49:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:5yXh+DzjiFQnP04p2QdcUg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
