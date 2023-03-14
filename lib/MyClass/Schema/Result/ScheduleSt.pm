use utf8;
package MyClass::Schema::Result::ScheduleSt;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::ScheduleSt

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

=head1 TABLE: C<schedule_st>

=cut

__PACKAGE__->table("schedule_st");

=head1 ACCESSORS

=head2 date

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 lession

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=head2 name_subject

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 teacher

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 room

  data_type: 'varchar'
  is_nullable: 1
  size: 11

=cut

__PACKAGE__->add_columns(
  "date",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "lession",
  { data_type => "varchar", is_nullable => 1, size => 11 },
  "name_subject",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "teacher",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "room",
  { data_type => "varchar", is_nullable => 1, size => 11 },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-01-10 09:52:16
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Uc29GUoMvqsS2aENIT+fsw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
