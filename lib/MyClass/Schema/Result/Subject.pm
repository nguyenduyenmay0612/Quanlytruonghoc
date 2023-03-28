use utf8;
package MyClass::Schema::Result::Subject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Subject

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

=head1 TABLE: C<subject>

=cut

__PACKAGE__->table("subject");

=head1 ACCESSORS

=head2 id_subject

  data_type: 'integer'
  is_nullable: 0

=head2 name_subject

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=cut

__PACKAGE__->add_columns(
  "id_subject",
  { data_type => "integer", is_nullable => 0 },
  "name_subject",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_subject>

=back

=cut

__PACKAGE__->set_primary_key("id_subject");

=head1 RELATIONS

=head2 marks

Type: has_many

Related object: L<MyClass::Schema::Result::Mark>

=cut

__PACKAGE__->has_many(
  "marks",
  "MyClass::Schema::Result::Mark",
  { "foreign.id_subject" => "self.id_subject" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 schedule_sts

Type: has_many

Related object: L<MyClass::Schema::Result::ScheduleSt>

=cut

__PACKAGE__->has_many(
  "schedule_sts",
  "MyClass::Schema::Result::ScheduleSt",
  { "foreign.subject_id" => "self.id_subject" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 schedule_tches

Type: has_many

Related object: L<MyClass::Schema::Result::ScheduleTch>

=cut

__PACKAGE__->has_many(
  "schedule_tches",
  "MyClass::Schema::Result::ScheduleTch",
  { "foreign.subject_id" => "self.id_subject" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-03-28 15:54:35
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sHmLlcNS9BNg9XAM8D2cxA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
