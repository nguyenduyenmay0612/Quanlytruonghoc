package MyClass::Controller::ImageController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Convert::Base64;
use Mojo::Upload;
use Cwd qw();

sub image{
    my $self = shift;
    my @image = $self->app->{_dbh}->resultset('Image')->search({});
    @image = map { { 
       id_image => $_->id_image,
       image_name => $_->image_name,
       image=> $_->image
    } } @image;

    $self->render(template => 'layouts/admin/manage_image/list_image', image=>\@image, message=>'', error=>'');    
}

sub edit_image_view{
    my $self = shift;
    my $id_image = $self->param('id_image');
    my $dbh = $self->app->{_dbh};
    my $image = $dbh->resultset('Image')->find($id_image);
    
    if ($image) {
        $self->render(template => 'layouts/admin/manage_image/edit_image', image => $image , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/admin/manage_image/list_image');
    }
}

sub edit_image{
    my $self = shift;
    my $id_image = $self->param('id_image');
    my $image_name = $self->param('image_name');
    my $image1 = $self->param('image');
    # $image = encode_base64($image->slurp);   
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
}

sub delete_image{
    my $self = shift;
    my $id_image = $self->param('id_image');
    my $dbh = $self->app->{_dbh};
    my $result = $dbh->resultset('Image')->find($id_image)->delete({});
    my @image = $self->app->{_dbh}->resultset('Image')->search({});
    if($result) {
    @image = map { { 
       id_image => $_->id_image,
       image_name => $_->image_name,
        image => $_->image
    } } @image;
    $self->render(template => 'layouts/admin/manage_image/list_image', image =>\@image, message => '', error=>'');
    }else {
    $self->render(template => 'layouts/admin/manage_image/list_image', image =>\@image, message => '', error=>'');
    }
}

sub add_image{
    my $self = shift;
    my $image_name = $self->param('image_name');
    my $image = $self->param('image');
    my $dbh = $self->app->{_dbh};
    # my $result = $dbh->resultset('Image')->search({});
    eval {
        $dbh->resultset('Image')->create({
            image_name => $image_name,
            image => $image
        });
    };
    my @image = $self->app->{_dbh}->resultset('Image')->search({});  
    @image = map { { 
        id_image => $_->id_image,
        image_name => $_->image_name,
        image => $_->image
    } } @image;
    $self->render(template => 'layouts/admin/manage_image/list_image', image =>\@image, message => 'Thêm thành công', error=>'');
}     



1;
