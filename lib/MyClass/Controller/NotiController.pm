package MyClass::Controller::NotiController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Upload;
use Cwd qw();

#
# This is function to displays list notification
# @param $self[Object] the instance of it self
# @return @noti [Array] The response data list notification 
#
sub noti($self) {
    my @noti = $self->app->{_dbh}->resultset('Noti')->search(+{});
    @noti = map {+{ 
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content=> $_->content
    } } @noti;
    $self->render(template => 'layouts/admin/noti/noti', noti=>\@noti, message=>'', error=>'');

    return;
}

#
# This is function to displays view add notifition 
# @param $self [Object] the instance of it self 
# @return [Void]
#
sub add_noti_view($self) {
    $self->render(template => 'layouts/admin/noti/add_noti', error =>'', message =>'');

    return;
}

#
# This is function to handle form add notification
# @param $self [Object] the instance of it self
# @return [Void]
#
sub add_noti($self) {
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

    return;
}

#
# This is function to displays view edit notification
# @param $self [Object] the instance of it self
# @return [Hash] include properties of notification
#
sub edit_noti_view($self) {
    my $id_noti = $self->param('id_noti');
    my $noti = $self->app->{_dbh}->resultset('Noti')->find($id_noti);
    if ($noti) {
        $self->render(template => 'layouts/admin/noti/edit_noti', noti => $noti , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/admin/noti/noti');
    }

    return;
}

#
# This is function to handle form edit notification
# @param $self [Object] the instance of it self
# @return [Void]
#
sub edit_noti($self) {
    my $dbh = $self->app->{_dbh};

    my $id_noti = $self->param('id_noti');
    my $noti_name = $self->param('noti_name');
    my $content = $self->param('content');
    my $noti = $dbh->resultset('Noti')->find($id_noti);
    if ($noti) {
            my $result= $dbh->resultset('Noti')->find($id_noti)->update(+{
                id_noti => $id_noti,
                noti_name => $noti_name,
                content => $content
            });
            my $noti = $dbh->resultset('Noti')->find($id_noti);
            $self->render(template => 'layouts/admin/noti/edit_noti', noti => $noti, message => 'Cập nhật thành công', error=>'');   
    }

    return;
}

#
# This is function to delete notification
# @param $self [Object] the instance of it self
# @return @noti [Array] The response data list notification after delete
#
sub delete_noti($self) {
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

    return;
}

#
# This is function to search notification
# @param $self [Object] The instance of it self
# @return @noti [String] The response data list notification
#
sub search_noti($self) {
    my $dbh = $self->app->{_dbh};

    my $noti_name = $self->param('noti_name');
    my @noti = $dbh->resultset('Noti')->search_like(+{ noti_name => '%'.$noti_name.'%' });
    @noti = map { +{
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content => $_->content,
    } } @noti;
    $self->render(template => 'layouts/admin/noti/noti', noti=>\@noti, error => '', message =>'');

    return;
}

1;
