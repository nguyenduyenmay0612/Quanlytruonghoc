use utf8;
package MyClass::Schema::Result::Class;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Class

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

=head1 TABLE: C<class>

=cut

__PACKAGE__->table("class");

=head1 ACCESSORS

=head2 id_class

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name_class

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=cut

__PACKAGE__->add_columns(
  "id_class",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name_class",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_class>

=back

=cut

__PACKAGE__->set_primary_key("id_class");

=head1 RELATIONS

=head2 schedule_sts

Type: has_many

Related object: L<MyClass::Schema::Result::ScheduleSt>

=cut

__PACKAGE__->has_many(
  "schedule_sts",
  "MyClass::Schema::Result::ScheduleSt",
  { "foreign.class_id" => "self.id_class" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 students

Type: has_many

Related object: L<MyClass::Schema::Result::Student>

=cut

__PACKAGE__->has_many(
  "students",
  "MyClass::Schema::Result::Student",
  { "foreign.class_id" => "self.id_class" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 teachers

Type: has_many

Related object: L<MyClass::Schema::Result::Teacher>

=cut

__PACKAGE__->has_many(
  "teachers",
  "MyClass::Schema::Result::Teacher",
  { "foreign.id_class" => "self.id_class" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-03-24 10:49:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BIkS5oMzjRyq8oTG05ChaQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
