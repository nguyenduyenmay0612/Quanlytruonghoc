use utf8;
package MyClass::Schema::Result::Activity;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Activity

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

=head1 TABLE: C<activity>

=cut

__PACKAGE__->table("activity");

=head1 ACCESSORS

=head2 id_activity

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 activity_name

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=head2 activity_des

  data_type: 'text'
  is_nullable: 1

=head2 image

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=cut

__PACKAGE__->add_columns(
  "id_activity",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "activity_name",
  { data_type => "varchar", is_nullable => 0, size => 100 },
  "activity_des",
  { data_type => "text", is_nullable => 1 },
  "image",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_activity>

=back

=cut

__PACKAGE__->set_primary_key("id_activity");


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-03-02 16:53:34
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:y1Gl321W/v6YEBinbg1N4g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
