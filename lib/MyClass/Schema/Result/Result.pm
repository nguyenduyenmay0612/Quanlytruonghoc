use utf8;
package MyClass::Schema::Result::Result;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Result

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

=head1 TABLE: C<result>

=cut

__PACKAGE__->table("result");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 semester

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 school_year

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 result_4

  data_type: 'float'
  is_nullable: 1

=head2 result_10

  data_type: 'float'
  is_nullable: 1

=head2 level

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 result_total_4

  data_type: 'float'
  is_nullable: 1

=head2 result_total_10

  data_type: 'float'
  is_nullable: 1

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "semester",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "school_year",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "result_4",
  { data_type => "float", is_nullable => 1 },
  "result_10",
  { data_type => "float", is_nullable => 1 },
  "level",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "result_total_4",
  { data_type => "float", is_nullable => 1 },
  "result_total_10",
  { data_type => "float", is_nullable => 1 },
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
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


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-04-04 16:23:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AZUd81I6UbB5Me7Qg1b+jw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
