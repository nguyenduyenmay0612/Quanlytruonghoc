use utf8;
package MyClass::Schema::Result::Banner;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Banner

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

=head1 TABLE: C<banner>

=cut

__PACKAGE__->table("banner");

=head1 ACCESSORS

=head2 id_banner

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 banner_name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 image

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "id_banner",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "banner_name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "image",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_banner>

=back

=cut

__PACKAGE__->set_primary_key("id_banner");


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-02-27 17:03:10
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PZN81fB6KTmZ7kqTaWqrpA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
