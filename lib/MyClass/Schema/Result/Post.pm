use utf8;
package MyClass::Schema::Result::Post;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Post

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

=head1 TABLE: C<post>

=cut

__PACKAGE__->table("post");

=head1 ACCESSORS

=head2 id_post

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title_post

  data_type: 'text'
  is_nullable: 0

=head2 summary

  data_type: 'text'
  is_nullable: 0

=head2 image

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 content

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id_post",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title_post",
  { data_type => "text", is_nullable => 0 },
  "summary",
  { data_type => "text", is_nullable => 0 },
  "image",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "content",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_post>

=back

=cut

__PACKAGE__->set_primary_key("id_post");


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-02-28 15:18:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PbFVjwuORhuY7Zy/Ij5rFg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
