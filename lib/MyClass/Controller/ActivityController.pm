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
# This is the show list activity function
# @param $self[Object] the instance of it self
# @return @activity [Array] The response data list activity 
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

#
# This is view add activity function
# @param $self [Object] the instance of it self 
# @return [Void]  
#
sub add_activity_view {
    my $self = shift;
    return $self->render(template => 'layouts/admin/activity/add_activity', error =>'', message =>'');
}

#
# This is  form add activity handle function
# @param $self [Object] the instance of it self  
#
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

#
# This is view edit activity function 
# @param $self [Object] the instance of it self
# @return [Hash] include properties of activity
#
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

#
# This is  form edit activity handle function
# @param $self [Object] the instance of it self 
# @return [Void]  
#
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

    return ;
}

#
# This is delete activity function
# @param $self [Object] the instance of it self 
# @return @activity [Array] The response data list activity after delete
#
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
        $self->redirect_to('admin/activity');
    } else {
        $self->render(template => 'layouts/admin/activity/activity', activity =>\@activity);
    }

    return;
}   

#
# This is the activity search function
# @param $self [Object] The instance of it self
# @return @activity [String] The response data list activity
#
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
