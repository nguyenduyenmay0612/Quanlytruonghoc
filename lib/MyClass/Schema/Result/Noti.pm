use utf8;
package MyClass::Schema::Result::Noti;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Noti

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

=head1 TABLE: C<noti>

=cut

__PACKAGE__->table("noti");

=head1 ACCESSORS

=head2 id_noti

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 noti_name

  data_type: 'text'
  is_nullable: 0

=head2 content

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id_noti",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "noti_name",
  { data_type => "text", is_nullable => 0 },
  "content",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_noti>

=back

=cut

__PACKAGE__->set_primary_key("id_noti");


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-03-03 10:36:42
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rwc5Sf7N498yQtkx3Fb9og


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
