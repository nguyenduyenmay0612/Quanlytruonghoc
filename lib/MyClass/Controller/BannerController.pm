package MyClass::Controller::BannerController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Convert::Base64;
use Mojo::Upload;
use Cwd qw();

#
# This is function to displays list banner
# @param $self[Object] the instance of it self
# @return @activity [Array] The response data list banner
#
sub banner {
    my $self = shift;

    my @banner = $self->app->{_dbh}->resultset('Banner')->search(+{});
    @banner = map { +{ 
       id_banner => $_->id_banner,
       banner_name => $_->banner_name,
       image=> $_->image
    } } @banner;
    $self->render(template => 'layouts/admin/banner/banner', banner=>\@banner, message=>'', error=>'');    

    return;
}

#
# This is function to handle form add banner
# @param $self [Object] the instance of it self
# @activity [Array] The response data list banner
sub add_banner {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $banner_name = $self->param('banner_name');
    my $image = $self->param('image');  
    my $result = $dbh->resultset('Banner')->search(+{});
    eval {
        $dbh->resultset('Banner')->create(+{
            banner_name => $banner_name,
            image => $image
        });
    };
    my @banner = $self->app->{_dbh}->resultset('Banner')->search(+{});  
    @banner = map { +{ 
        id_banner => $_->id_banner,
        banner_name => $_->banner_name,
        image => $_->image
    } } @banner;
    $self->render(template => 'layouts/admin/banner/banner', banner =>\@banner, message => 'Thêm thành công', error=>'');

    return;
}     


#
# This is function to display edit banner
# @param $self [Object] the instance of it self
# @return [Hash] include properties of banner
#
sub edit_banner_view {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_banner = $self->param('id_banner');  
    my $banner = $dbh->resultset('Banner')->find($id_banner);
    if ($banner) {
        $self->render(template => 'layouts/admin/banner/edit_banner', banner => $banner , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/admin/banner/banner');
    }

    return;
}

#
# This is function to handle form edit banner
# @param $self [Object] the instance of it self
# @return [Void]  
#
sub edit_banner {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_banner = $self->param('id_banner');
    my $banner_name = $self->param('banner_name');
    my $image = $self->param('image');
    my $banner = $dbh->resultset('Banner')->find($id_banner);
    if ($banner) {
        my $result= $dbh->resultset('Banner')->find($id_banner)->update({  
        id_banner => $id_banner,
        banner_name => $banner_name,
        image => $image,
        });
        my $banner = $dbh->resultset('Banner')->find($id_banner);
        $self->render(template => 'layouts/admin/banner/edit_banner', banner => $banner, message => 'Cập nhật thành công', error=>'');   
    } else {
        $self->redirect_to('admin/banner');
    }

    return;
}

#
# This is function to delete banner
# @param $self [Object] the instance of it self
# @return @activity [Array] The response data list banner after delete
#
sub delete_banner {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_banner = $self->param('id_banner');
    my $result = $dbh->resultset('Banner')->find($id_banner)->delete(+{});
    my @banner = $self->app->{_dbh}->resultset('Banner')->search(+{});
    if ($result) {
        @banner = map { +{ 
            id_banner => $_->id_banner,
            banner_name => $_->banner_name,
            image => $_->image
        } } @banner;
        $self->render(template => 'layouts/admin/banner/banner', banner =>\@banner);
    } else {
        $self->redirect_to('admin/banner');
    }

    return;
}

1;
