package MyClass::Controller::PostController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Convert::Base64;
use Mojo::Upload;
use Cwd qw();
use HTML::Entities;

sub post {
    my $self = shift;

    my @post = $self->app->{_dbh}->resultset('Post')->search(+{});
    @post = map { +{ 
        id_post => $_->id_post,
        title_post => $_->title_post,
        summary=> $_->summary,
        image=> $_->image,
        content=> $_->content
    } } @post;
    $self->render(template => 'layouts/admin/post/post', post=>\@post, message=>'', error=>'');
}

sub edit_post_view {
    my $self = shift;

    my $id_post = $self->param('id_post');
    my $post = $self->app->{_dbh}->resultset('Post')->find($id_post);
    if ($post) {
        $self->render(template => 'layouts/admin/post/edit_post', post => $post , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/admin/post/post');
    }
}

sub edit_post {
    my $self = shift;
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
}

sub delete_post {
    my $self = shift;
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
}

sub add_post_view {
    my $self = shift;
    $self->render(template => 'layouts/admin/post/add_post', error =>'', message =>'');
}

sub add_post {
    my $self = shift;
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
} 

sub search_post {
    my $self = shift;
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
}

1;
