use utf8;
package MyClass::Schema::Result::Slidebar;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Slidebar

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

=head1 TABLE: C<slidebar>

=cut

__PACKAGE__->table("slidebar");

=head1 ACCESSORS

=head2 id_slidebar

  data_type: 'integer'
  is_nullable: 0

=head2 image_slidebar

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 name_slidebar

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=cut

__PACKAGE__->add_columns(
  "id_slidebar",
  { data_type => "integer", is_nullable => 0 },
  "image_slidebar",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "name_slidebar",
  { data_type => "varchar", is_nullable => 1, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_slidebar>

=back

=cut

__PACKAGE__->set_primary_key("id_slidebar");


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-01-05 10:21:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dNOjhP6rFAW0uwaDLa5rcQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
