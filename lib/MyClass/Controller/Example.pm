package MyClass::Controller::Example;
use utf8;
use Mojo::Base 'Mojolicious::Controller', -signatures;

#
# This is the show index function
# @param $self[Object] the instance of it self
# @return @banner, @activity, @post, @noti, @image [Array] 
#
sub welcome ($self) {
    my @banner = $self->_get_banner();
    my @activity = $self->_get_activity();
    my @post = $self->_get_post();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();
    $self->render(msg => 'Chào mừng mọi người', banner=>\@banner, post=>\@post, activity=>\@activity, noti=>\@noti, image=>\@image);
}

#
# this is the show post details function
# @param $self[Object] the instance of it self
# @return $post[Hash], @banner, @activity, @noti, @image [Array]
#
sub post_detail {
    my $self = shift;

    my @banner= $self->_get_banner();
    my @activity = $self->_get_activity();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();
    my $id_post = $self->param('id_post');
    my $post = $self->app->{_dbh}->resultset('Post')->find($id_post);   
    if ($post) {
        $self->render(template => 'layouts/frontend/post_detail', banner=>\@banner, post => $post, activity=>\@activity, noti=>\@noti, image=>\@image);
    }

    return;
}

#
# this is the show notification details function
# @param $self[Object] the instance of it self
# @return $noti1[Hash], @banner, @activity, @image [Array]
#
sub noti_detail($self) {
    my @banner= $self->_get_banner();
    my @activity = $self->_get_activity();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();
    my $id_noti = $self->param('id_noti');
    my $noti1 = $self->app->{_dbh}->resultset('Noti')->find($id_noti);   
    if ($noti1) {
        $self->render(template => 'layouts/frontend/noti_detail', banner=>\@banner, activity=>\@activity, noti1=>$noti1, noti=>\@noti, image=>\@image);
    }
    
    return;
}

#
# this is the show activity details function
# @param $self[Object] the instance of it self
# @return $activity1[Hash], @banner, @noti, @image [Array]
#
sub activity_detail($self) {
    my @banner= $self->_get_banner();
    my @activity = $self->_get_activity();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();
    my $id_activity = $self->param('id_activity');
    my $activity1 = $self->app->{_dbh}->resultset('Activity')->find($id_activity);   
    if ($activity1) {
        $self->render(template => 'layouts/frontend/activity_detail', banner=>\@banner, activity1=>$activity1, activity=>\@activity, noti=>\@noti, image=>\@image);
    }

    return;
}

#
# This is the introcuce page show  function
# @param $self[Object] the instance of it self
# @return @banner, @activity, @noti, @image [Array] 
#
sub introduce($self) {
    my @banner = $self->_get_banner();
    my @activity = $self->_get_activity();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();

    $self->render(template => 'layouts/frontend/introduce', banner=>\@banner, activity=>\@activity, noti=>\@noti, image=>\@image);
}

#
# This is the admissions page show function
# @param $self[Object] the instance of it self
# @return @banner, @activity, @noti, @image [Array] 
#
sub admissions($self) {
    my @banner = $self->_get_banner();
    my @activity = $self->_get_activity();
    my @post = $self->_get_post();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();
    $self->render(template => 'layouts/frontend/admissions', banner=>\@banner, post=>\@post, activity=>\@activity, noti=>\@noti, image=>\@image);    
}

#
# This is the get list banner function
# @param $self[Object] the instance of it self
# @return @banner[Array] 
# @pravite
#
sub _get_banner($self) {
    my @banner = $self->app->{_dbh}->resultset('Banner')->search({});
    @banner = map { { 
        id_banner => $_->id_banner,
        banner_name => $_->banner_name,
        image=> $_->image
    } } @banner;

    return @banner;
}

#
# This is the get list activity function
# @param $self[Object] the instance of it self
# @return @activity[Array] 
# @pravite
#
sub _get_activity($self) {
    my @activity = $self->app->{_dbh}->resultset('Activity')->search({});
    @activity = map { { 
        id_activity => $_->id_activity,
        activity_name => $_->activity_name,
        activity_des => $_->activity_des,
        image=> $_->image
    } } @activity;

    return @activity;    
}

#
# This is the get list post function
# @param $self[Object] the instance of it self
# @return @post[Array] 
# @pravite
#
sub _get_post($self) {
    my @post = $self->app->{_dbh}->resultset('Post')->search({});
    @post = map { { 
        id_post => $_->id_post,
        title_post => $_->title_post,
        summary=> $_->summary,
        image=> $_->image,
        content=> $_->content
    } } @post;

    return @post;
}

#
# This is the get list notification function
# @param $self[Object] the instance of it self
# @return @noti[Array] 
# @pravite
#
sub _get_noti($self) {
    my @noti = $self->app->{_dbh}->resultset('Noti')->search({});
    @noti = map { { 
        id_noti => $_->id_noti,
        noti_name => $_->noti_name,
        content=> $_->content
    } } @noti;

    return @noti;
}

#
# This is the get list image function
# @param $self[Object] the instance of it self
# @return @image[Array] 
# @pravite
#
sub _get_image($self) {
    my @image = $self->app->{_dbh}->resultset('Image')->search({});
    @image = map { { 
        id_image => $_->id_image,
        image_name => $_->image_name,
        image=> $_->image
    } } @image;

    return @image;
}

1;