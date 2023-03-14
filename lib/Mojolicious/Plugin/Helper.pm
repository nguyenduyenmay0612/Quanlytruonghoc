package Mojolicious::Plugin::Helper;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::Base 'Mojolicious', -signatures;
use Crypt::PBKDF2;
use Schema;
use Configuration;
use MyClass::Model::MStudent;
use Email::Send::SMTP::Gmail;

sub register {
    my ($self, $app) = @_;
    $app->helper(schema => sub {
    my ($c) = @_;
    my $dsn = $Configuration::dsn;
    my $user        = $Configuration::db_user;
    my $password    = $Configuration::db_password;
    return state $schema = Schema->connect($dsn,$user,$password ,{ mysql_enable_utf8 => 1, },);
    });
    
    $app->helper(rs => sub {
    return shift->schema->resultset(@_);
    });
}