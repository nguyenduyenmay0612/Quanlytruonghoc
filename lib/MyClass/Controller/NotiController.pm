package MyClass::Controller::NotiController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Convert::Base64;
use Mojo::Upload;
use Cwd qw();

sub noti {
    my $self = shift;

    my @noti = $self->app->{_dbh}->resultset('Noti')->search(+{});
    @noti = map { +{ 
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content=> $_->content
    } } @noti;
    $self->render(template => 'layouts/admin/noti/noti', noti=>\@noti, message=>'', error=>'');
}

sub edit_noti_view {
    my $self = shift;

    my $id_noti = $self->param('id_noti');
    my $noti = $self->app->{_dbh}->resultset('Noti')->find($id_noti);   
    if ($noti) {
        $self->render(template => 'layouts/admin/noti/edit_noti', noti => $noti , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/admin/noti/noti');
    }
}

sub edit_noti {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_noti = $self->param('id_noti');
    my $noti_name = $self->param('noti_name');
    my $content = $self->param('content');
    my $noti = $dbh->resultset('Noti')->find($id_noti);
    if ($noti) {
            my $result= $dbh->resultset('Noti')->find($id_noti)->update({
                id_noti => $id_noti,
                noti_name => $noti_name,
                content => $content
            });
            my $noti = $dbh->resultset('Noti')->find($id_noti);
            $self->render(template => 'layouts/admin/noti/edit_noti', noti => $noti, message => 'Cập nhật thành công', error=>'');   
    }
}

sub delete_noti {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_noti = $self->param('id_noti');  
    my $result = $dbh->resultset('Noti')->find($id_noti)->delete({});
    my @noti =$dbh->resultset('Noti')->search({});
    if ($result) {
    @noti = map { { 
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content => $_->content
    } } @noti;
    $self->redirect_to('/teacher/noti');
    } else {
        $self->render(template => 'layouts/admin/noti/noti', noti =>\@noti);
    }
}

sub add_noti_view {
    my $self = shift;  
    $self->render(template => 'layouts/admin/noti/add_noti', error =>'', message =>'');
}

sub add_noti {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $noti_name = $self->param('noti_name');
    my $content = $self->param('content');
    my $result = $dbh->resultset('Noti')->search(+{});
    eval {
        $dbh->resultset('Noti')->create(+{
            noti_name => $noti_name,
            content => $content
        });
    };
    my @noti = $dbh->resultset('Noti')->search(+{});  
    @noti = map { +{ 
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content => $_->content,
    } } @noti;
    $self->render(template => 'layouts/admin/noti/add_noti', noti =>\@noti, message => 'Thêm thành công', error=>'');
}     

sub search_noti {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $noti_name = $self->param('noti_name');       
    my @noti = $dbh->resultset('Noti')->search_like(+{ noti_name => '%'.$noti_name.'%' });
    @noti = map { +{ 
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content => $_->content,
    } } @noti;
    $self->render(template => 'layouts/admin/noti/noti', noti=>\@noti, error => '', message =>'');
}

1;
