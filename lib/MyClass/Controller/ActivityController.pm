package MyClass::Controller::ActivityController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Convert::Base64;
use Mojo::Upload;
use Cwd qw();

#
# Hiển thị danh sách hoạt động để quản lý
# param $self [Object] Bien moi truong  
# return [Array] danh sách hoạt động
# @public
#
sub activity {
    my $self = shift;

    my @activity = $self->app->{_dbh}->resultset('Activity')->search(+{});
    @activity = map {+{ 
        id_activity => $_->id_activity,
        activity_name => $_->activity_name,
        image=> $_->image,
        activity_des=> $_->activity_des
    } } @activity;
    $self->render(template => 'layouts/admin/activity/activity', activity=>\@activity, message=>'', error=>'');    
}

sub edit_activity_view {
    my $self = shift;

    my $id_activity = $self->param('id_activity');
    my $activity = $self->app->{_dbh}->resultset('Activity')->find($id_activity);   
    if ($activity) {
        $self->render(template => 'layouts/admin/activity/edit_activity', activity => $activity , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/admin/activity/activity');
    }

    return;
}

sub edit_activity {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_activity = $self->param('id_activity');
    my $activity_name = $self->param('activity_name');
    my $activity_des = $self->param('activity_des');
    my $image = $self->param('image');    
    my $activity = $dbh->resultset('Activity')->find($id_activity);
    if ($activity) {
        my $result= $dbh->resultset('Activity')->find($id_activity)->update(+{
            id_activity => $id_activity,
            activity_name => $activity_name,
            activity_des => $activity_des,
            image => $image
        });
        my $activity = $dbh->resultset('Activity')->find($id_activity);
        $self->render(template => 'layouts/admin/activity/edit_activity', activity => $activity, message => 'Cập nhật thành công', error=>'');
    }

    return;
}

sub delete_activity {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_activity = $self->param('id_activity');
    my $result = $dbh->resultset('Activity')->find($id_activity)->delete(+{});
    my @activity = $dbh->resultset('Activity')->search(+{});
    if($result) {
        @activity = map {{ 
            id_activity => $_->id_activity,
            activity_name => $_->activity_name,
            activity_des => $_->activity_des,
            image => $_->image
        }} @activity;
        $self->redirect_to('teacher/activity');
    } else {
        $self->render(template => 'layouts/admin/activity/activity', activity =>\@activity);
    }

    return;
}

# muc dich func nayf lamf gif
# dau vao
# ket qua
sub add_activity_view {
    my $self = shift;
    return $self->render(template => 'layouts/admin/activity/add_activity', error =>'', message =>'');
}

sub add_activity {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $activity_name = $self->param('activity_name');
    my $activity_des = $self->param('activity_des');
    my $image = $self->param('image');  
    my $result = $dbh->resultset('Activity')->search(+{});
    eval {
        $dbh->resultset('Activity')->create(+{
            activity_name => $activity_name,
            activity_des => $activity_des,
            image => $image
        });
    };
    my @activity = $dbh->resultset('Activity')->search(+{});
    @activity = map { +{ 
        id_activity => $_->id_activity,
        activity_name => $_->activity_name,
        activity_des => $_->activity_des,
        image => $_->image
    } } @activity;
    $self->render(template => 'layouts/admin/activity/add_activity', activity =>\@activity, message => 'Thêm thành công', error=>'');
}     

sub search_activity {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $activity_name = $self->param('activity_name');
    my @activity = $dbh->resultset('Activity')->search_like({ activity_name => '%'.$activity_name.'%' });
    @activity = map { { 
        id_activity => $_->id_activity,
        activity_name => $_->activity_name,
        activity_des => $_->activity_des,
        image => $_->image
    } } @activity;
    $self->render(template => 'layouts/admin/activity/activity', activity=> \@activity, error => '', message =>'');
}

1;
