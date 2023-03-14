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

=head2 name_teacher

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=cut

__PACKAGE__->add_columns(
  "id_subject",
  { data_type => "integer", is_nullable => 0 },
  "name_subject",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "name_teacher",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_subject>

=back

=cut

__PACKAGE__->set_primary_key("id_subject");

=head1 RELATIONS

=head2 scores

Type: has_many

Related object: L<MyClass::Schema::Result::Score>

=cut

__PACKAGE__->has_many(
  "scores",
  "MyClass::Schema::Result::Score",
  { "foreign.id_subject" => "self.id_subject" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-02-03 13:46:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:z08nmt8utFvW1IJmXLMUdg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
