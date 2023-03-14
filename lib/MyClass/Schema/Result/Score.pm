use utf8;
package MyClass::Schema::Result::Score;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MyClass::Schema::Result::Score

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

=head1 TABLE: C<score>

=cut

__PACKAGE__->table("score");

=head1 ACCESSORS

=head2 id_student

  data_type: 'integer'
  is_nullable: 0

=head2 full_name

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 id_subject

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 score_1

  data_type: 'float'
  is_nullable: 1

=head2 score_2

  data_type: 'float'
  is_nullable: 1

=head2 score_3

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id_student",
  { data_type => "integer", is_nullable => 0 },
  "full_name",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "id_subject",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "score_1",
  { data_type => "float", is_nullable => 1 },
  "score_2",
  { data_type => "float", is_nullable => 1 },
  "score_3",
  { data_type => "float", is_nullable => 1 },
);

=head1 RELATIONS

=head2 id_subject

Type: belongs_to

Related object: L<MyClass::Schema::Result::Subject>

=cut

__PACKAGE__->belongs_to(
  "id_subject",
  "MyClass::Schema::Result::Subject",
  { id_subject => "id_subject" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07051 @ 2023-02-03 13:46:43
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:stIlyAoWngayZWIpga5XHQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
