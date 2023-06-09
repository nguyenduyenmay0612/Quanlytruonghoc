package MyClass::Controller::PostController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Upload;
use Cwd qw();
use HTML::Entities;

#
# This is function to display list post
# @param $self[Object] the instance of it self
# @return @post [Array] The response data list activity
#
sub post($self) {
    my @post = $self->app->{_dbh}->resultset('Post')->search(+{});
    @post = map { +{ 
        id_post => $_->id_post,
        title_post => $_->title_post,
        summary=> $_->summary,
        image=> $_->image,
        content=> $_->content
    } } @post;
    $self->render(template => 'layouts/admin/post/post', post=>\@post, message=>'', error=>'');

    return;
}

#
# This is function to displays view add post
# @param $self [Object] the instance of it self
# @return [Void]
#
sub add_post_view($self) {
    $self->render(template => 'layouts/admin/post/add_post', error =>'', message =>'');

    return;
}

#
# This is function to handle form add post
# @param $self [Object] the instance of it self
# @return [Void]
#
sub add_post($self) {
    my $dbh = $self->app->{_dbh};

    my $title_post = $self->param('title_post');
    my $summary = $self->param('summary');
    my $content = $self->param('content');
    my $image = $self->param('image');  
    my $result = $dbh->resultset('Post')->search({});
    eval {
        $dbh->resultset('Post')->create({
            title_post => $title_post,
            summary => $summary,
            content => $content,
            image => $image
        });
    };
    my @post = $self->app->{_dbh}->resultset('Post')->search({});
    @post = map { { 
        id_post => $_->id_post,
        title_post => $_->title_post,
        summary => $_->summary,
        content => $_->content,
        image => $_->image
    } } @post;
    $self->render(template => 'layouts/admin/post/add_post', post =>\@post, message => 'Thêm thành công', error=>'');

    return;
} 

#
# This is function to view edit post
# @param $self [Object] the instance of it self
# @return [Hash] include properties of post
#
sub edit_post_view($self) {
    my $id_post = $self->param('id_post');
    my $post = $self->app->{_dbh}->resultset('Post')->find($id_post);
    if ($post) {
        $self->render(template => 'layouts/admin/post/edit_post', post => $post , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/admin/post/post');
    }

    return;
}

#
# This is function to handle form edit post
# @param $self [Object] the instance of it self
# @return [Void]
#
sub edit_post($self) {
    my $dbh = $self->app->{_dbh};

    my $id_post = $self->param('id_post');
    my $title_post = $self->param('title_post');
    my $summary = $self->param('summary');
    my $content = $self->param('content');
    my $image = $self->param('image');
    my $post = $dbh->resultset('Post')->find($id_post);
    if ($post) {
        my $result= $dbh->resultset('Post')->find($id_post)->update({  
            id_post => $id_post,
            title_post => $title_post,
            summary => $summary,
            content => $content,
            image => $image
        });
        my $post = $dbh->resultset('Post')->find($id_post);
        $self->render(template => 'layouts/admin/post/edit_post', post => $post, message => 'Cập nhật thành công', error=>'');   
    }

    return;
}

#
# This is function to delete post
# @param $self [Object] the instance of it self
# @return @post [Array] The response data list post after delete
#
sub delete_post($self) {
    my $dbh = $self->app->{_dbh};

    my $id_post = $self->param('id_post');  
    my $result = $dbh->resultset('Post')->find($id_post)->delete($id_post);
    my @post = $self->app->{_dbh}->resultset('Post')->search(+{});
    if($result) {
        @post = map { +{ 
            id_post => $_->id_post,
            title_post => $_->title_post,
            summary => $_->summary,
            content => $_->content,
            image => $_->image
        } } @post;
        $self->redirect_to('/admin/post');  
    } else {
        $self->render(template => 'layouts/admin/post/post', post =>\@post);
    }

    return;
}

#
# This is function to search post
# @param $self [Object] The instance of it self
# @return @post [String] The response data list post
#
sub search_post($self) {
    my $dbh = $self->app->{_dbh};

    my $title_post = $self->param('title_post');
    my @post = $self->app->{_dbh}->resultset('Post')->search_like(+{ title_post => '%'.$title_post.'%'});
    @post = map { +{ 
        id_post => $_->id_post,
        title_post => $_->title_post,
        summary => $_->summary,
        content => $_->content,
        image => $_->image
    } } @post;
    $self->render(template => 'layouts/admin/post/post', post=>\@post, error => '', message =>'');

    return;
}

1;
