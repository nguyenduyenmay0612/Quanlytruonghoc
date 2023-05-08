package MyClass::Controller::ImageController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::Upload;
use Cwd qw();

#
# This is function to displays list image
# @param $self[Object] the instance of it self
# @return @image [Array] The response data list image
#
sub image($self) {
    my @image = $self->app->{_dbh}->resultset('Image')->search(+{});
    @image = map { +{ 
        id_image => $_->id_image,
        image_name => $_->image_name,
        image=> $_->image
    } } @image;
    $self->render(template => 'layouts/admin/manage_image/list_image', image=>\@image, message=>'', error=>'');    

    return;
}

#
# This is function to handle form add image
# @param $self [Object] the instance of it self
# @return @image[Array]
#
sub add_image($self) {
    my $dbh = $self->app->{_dbh};

    my $image_name = $self->param('image_name');
    my $image = $self->param('image');  
    eval {
        $dbh->resultset('Image')->create({
            image_name => $image_name,
            image => $image
        });
    };
    my @image = $dbh->resultset('Image')->search(+{});
    @image = map { +{ 
        id_image => $_->id_image,
        image_name => $_->image_name,
        image => $_->image
    } } @image;
    $self->render(template => 'layouts/admin/manage_image/list_image', image =>\@image, message => 'Thêm thành công', error=>'');

    return;
} 

#
# This is function to displays view edit image
# @param $self [Object] the instance of it self
# @return [Hash] include properties of activity
#
sub edit_image_view($self) {
    my $id_image = $self->param('id_image');
    my $dbh = $self->app->{_dbh};
    my $image = $dbh->resultset('Image')->find($id_image);    
    if ($image) {
        $self->render(template => 'layouts/admin/manage_image/edit_image', image => $image , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/admin/manage_image/list_image');
    }

    return;
}

#
# This is function to handle form edit image
# @param $self [Object] the instance of it self
# @return [Void]
#
sub edit_image($self) {
    my $id_image = $self->param('id_image');
    my $image_name = $self->param('image_name');
    my $image1 = $self->param('image');  
    my $dbh = $self->app->{_dbh}; 
    my $image = $dbh->resultset('Image')->find($id_image);
    if ($image) {
        my $result= $dbh->resultset('Image')->find($id_image)->update({  
            id_image => $id_image,
            image_name => $image_name,
            image => $image1
        });
        my $image = $dbh->resultset('Image')->find($id_image);
        $self->render(template => 'layouts/admin/manage_image/edit_image', image => $image, message => 'Cập nhật thành công', error=>'');   
    }

    return;
}

#
# This is function to delete image
# @param $self [Object] the instance of it self
# @return @image [Array] The response data list image after delete
#
sub delete_image($self) {
    my $dbh = $self->app->{_dbh};

    my $id_image = $self->param('id_image');
    my $result = $dbh->resultset('Image')->find($id_image)->delete({});
    my @image = $self->app->{_dbh}->resultset('Image')->search({});
    if ($result) {
    @image = map { { 
        id_image => $_->id_image,
        image_name => $_->image_name,
        image => $_->image
    } } @image;
        $self->redirect_to('/admin/image');
    } else {
        $self->render(template => 'layouts/admin/manage_image/list_image', image =>\@image, message => '', error=>'');
    }

    return;
}

1;
