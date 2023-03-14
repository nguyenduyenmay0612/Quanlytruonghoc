package MyClass::Controller::Example;
use utf8;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub welcome ($self) {
    # my $self = shift;
    my @banner = $self->_get_banner();
    my @activity = $self->_get_activity();
    my @post = $self->_get_post();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();

  # Render template "example/welcome.html.ep" with message
    $self->render(msg => 'Chào mừng mọi người', banner=>\@banner, post=>\@post, activity=>\@activity, noti=>\@noti, image=>\@image);
}

sub sukien_detail($self){
    my @banner= $self->_get_banner();
    my @activity = $self->_get_activity();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();

    my $id_post = $self->param('id_post');
    my $post = $self->app->{_dbh}->resultset('Post')->find($id_post);   
    if ($post) {
        $self->render(template => 'layouts/frontend/sukien_detail', banner=>\@banner, post => $post, activity=>\@activity, noti=>\@noti, image=>\@image);
        # $self->render(template => 'layouts/frontend/sukien_detail');
    }
}

sub thongbao_detail($self){
    my @banner= $self->_get_banner();
    my @activity = $self->_get_activity();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();

    my $id_noti = $self->param('id_noti');
    my $noti1 = $self->app->{_dbh}->resultset('Noti')->find($id_noti);   
    if ($noti1) {
        $self->render(template => 'layouts/frontend/thongbao_detail', banner=>\@banner, activity=>\@activity, noti1=>$noti1, noti=>\@noti, image=>\@image);
        # $self->render(template => 'layouts/frontend/thongbao_detail');
    }
}

sub hoatdong_detail($self){
    my @banner= $self->_get_banner();
    my @activity = $self->_get_activity();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();

    my $id_activity = $self->param('id_activity');
    my $activity1 = $self->app->{_dbh}->resultset('Activity')->find($id_activity);   
    if ($activity1) {
        $self->render(template => 'layouts/frontend/hoatdong_detail', banner=>\@banner, activity1=>$activity1, activity=>\@activity, noti=>\@noti, image=>\@image);
        # $self->render(template => 'layouts/frontend/thongbao_detail');
    }
}

sub gioithieu($self){
    my @banner = $self->_get_banner();
    my @activity = $self->_get_activity();
    my @post = $self->_get_post();
    my @noti = $self->_get_noti();
    my @image = $self->_get_image();

    $self->render(template => 'layouts/frontend/gioithieu', banner=>\@banner, post=>\@post, activity=>\@activity, noti=>\@noti);
}

sub tuyensinh($self){
    my @banner = $self->_get_banner();
    my @activity = $self->_get_activity();
    my @post = $self->_get_post();
    my @noti = $self->_get_noti();

    $self->render(template => 'layouts/frontend/tuyensinh', banner=>\@banner, post=>\@post, activity=>\@activity, noti=>\@noti);
    
}


# @private
sub _get_banner($self) {
    my @banner = $self->app->{_dbh}->resultset('Banner')->search({});
    @banner = map { { 
       id_banner => $_->id_banner,
       banner_name => $_->banner_name,
       image=> $_->image
    } } @banner;

    return @banner;
}

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

sub _get_noti($self) {
    my @noti = $self->app->{_dbh}->resultset('Noti')->search({});
    @noti = map { { 
       id_noti => $_->id_noti,
       noti_name => $_->noti_name,
       content=> $_->content
    } } @noti;

    return @noti;
}

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