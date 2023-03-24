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
    my @noti = $self->app->{_dbh}->resultset('Noti')->search({});
    @noti = map { { 
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content=> $_->content
    } } @noti;

    $self->render(template => 'layouts/backend_gv/noti/noti', noti=>\@noti, message=>'', error=>'');    
}

sub edit_noti_view {
    my $self = shift;
    my $id_noti = $self->param('id_noti');
    # my $dbh = $self->app->{_dbh};
    my $noti = $self->app->{_dbh}->resultset('Noti')->find($id_noti);   
    if ($noti) {
        $self->render(template => 'layouts/backend_gv/noti/edit_noti', noti => $noti , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/backend_gv/noti/noti');
    }
}

sub edit_noti {
    my $self = shift;
    my $id_noti = $self->param('id_noti');
    my $noti_name = $self->param('noti_name');
    my $content = $self->param('content');
    # $image = encode_base64($image->slurp);
    
    my $dbh = $self->app->{_dbh}; 
    my $noti = $dbh->resultset('Noti')->find($id_noti);
    if ($noti) {
            my $result= $dbh->resultset('Noti')->find($id_noti)->update({  
            id_noti => $id_noti,
            noti_name => $noti_name,
            content => $content
            });
            my $noti = $dbh->resultset('Noti')->find($id_noti);
            $self->render(template => 'layouts/backend_gv/noti/edit_noti', noti => $noti, message => 'Cập nhật thành công', error=>'');   
        }
}

sub delete_noti {
    my $self = shift;
    my $id_noti = $self->param('id_noti');
    my $dbh = $self->app->{_dbh};
    my $result = $dbh->resultset('Noti')->find($id_noti)->delete({});
    my @noti = $self->app->{_dbh}->resultset('Noti')->search({});
    if($result) {
    @noti = map { { 
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content => $_->content
    } } @noti;
    $self->redirect_to('/teacher/noti');    
    }else {
    $self->render(template => 'layouts/backend_gv/noti/noti', noti =>\@noti);
    }
}

sub add_noti_view {
    my $self = shift;  
    $self -> render(template => 'layouts/backend_gv/noti/add_noti', error =>'', message =>'');
}

sub add_noti {
    my $self = shift;
    my $noti_name = $self->param('noti_name');
    my $content = $self->param('content');

    my $dbh = $self->app->{_dbh};
    my $result = $dbh->resultset('Noti')->search({});
    eval {
        $dbh->resultset('Noti')->create({
            noti_name => $noti_name,
            content => $content
        });
    };
    my @noti = $self->app->{_dbh}->resultset('Noti')->search({});  
    @noti = map { { 
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content => $_->content,
    } } @noti;
    $self->render(template => 'layouts/backend_gv/noti/add_noti', noti =>\@noti, message => 'Thêm thành công', error=>'');
}     



1;
