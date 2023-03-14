use utf8;
package MyClass::Schema::Result::ScheduleTch;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::ScheduleTch

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

=head1 TABLE: C<schedule_tch>

=cut

__PACKAGE__->table("schedule_tch");

=head1 ACCESSORS

=head2 name_subject

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 date

  data_type: 'varchar'
  is_nullable: 1
  size: 15

=head2 lession

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 room

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=cut

__PACKAGE__->add_columns(
  "name_subject",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "date",
  { data_type => "varchar", is_nullable => 1, size => 15 },
  "lession",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "room",
  { data_type => "varchar", is_nullable => 1, size => 45 },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-02-03 14:13:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rkBpmuiYBoISonSDk/2h8w


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
