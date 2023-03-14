use utf8;
package MyClass::Schema::Result::Image;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Image

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

=head1 TABLE: C<image>

=cut

__PACKAGE__->table("image");

=head1 ACCESSORS

=head2 id_image

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 image_name

  data_type: 'text'
  is_nullable: 0

=head2 image

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "id_image",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "image_name",
  { data_type => "text", is_nullable => 0 },
  "image",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_image>

=back

=cut

__PACKAGE__->set_primary_key("id_image");


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-03-06 10:39:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AM9dMvTIB41w5agVkh6VvA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
