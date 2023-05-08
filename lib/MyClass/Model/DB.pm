package MyClass::Model::DB;
use MyClass::Schema;
use DBIx::Class ();
use strict;

my ($schema_class, $connect_info);

BEGIN {
    $schema_class = 'MyClass::Schema';
    $connect_info = {
        dsn      => 'dbi:mysql:manageclass',
        user     => 'root',
        password => '123456789',
    };
}

sub new {
    return __PACKAGE__->config( $schema_class, $connect_info );
}

sub config {
    my $class = shift;

    my $self = {
        schema       => shift,
        connect_info => shift,
    };

    my $dbh = $self->{schema}->connect(
        $self->{connect_info}->{dsn}, 
        $self->{connect_info}->{user}, 
        $self->{connect_info}->{password},
        { mysql_enable_utf8 => 1, },
    );

    return $dbh;
}

1;
