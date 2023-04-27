use utf8;
package MyClass::Schema::Result::Admin;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Admin

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

=head1 TABLE: C<admin>

=cut

__PACKAGE__->table("admin");

=head1 ACCESSORS

=head2 id_admin

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=cut

__PACKAGE__->add_columns(
  "id_admin",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 45 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id_admin>

=back

=cut

__PACKAGE__->set_primary_key("id_admin");


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-04-27 21:56:06
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1dy8qV5mD0CQPcfVqLV8vA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
