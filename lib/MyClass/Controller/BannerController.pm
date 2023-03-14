package MyClass::Controller::BannerController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Convert::Base64;
use Mojo::Upload;
use Cwd qw();

sub banner{
    my $self = shift;
    my @banner = $self->app->{_dbh}->resultset('Banner')->search({});
    @banner = map { { 
       id_banner => $_->id_banner,
       banner_name => $_->banner_name,
       image=> $_->image
    } } @banner;

    $self->render(template => 'layouts/backend_gv/banner/banner', banner=>\@banner, message=>'', error=>'');    
}

sub edit_banner_view{
    my $self = shift;
    my $id_banner = $self->param('id_banner');
    my $dbh = $self->app->{_dbh};
    my $banner = $dbh->resultset('Banner')->find($id_banner);
    
    if ($banner) {
        $self->render(template => 'layouts/backend_gv/banner/edit_banner', banner => $banner , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/backend_gv/banner/banner');
    }
}

sub edit_banner{
    my $self = shift;
    my $id_banner = $self->param('id_banner');
    my $banner_name = $self->param('banner_name');
    my $image = $self->param('image');
    # $image = encode_base64($image->slurp);
    
    my $dbh = $self->app->{_dbh}; 
    my $banner = $dbh->resultset('Banner')->find($id_banner);
    if ($banner) {
            my $result= $dbh->resultset('Banner')->find($id_banner)->update({  
            id_banner => $id_banner,
            banner_name => $banner_name,
            image => $image,
            });
            my $banner = $dbh->resultset('Banner')->find($id_banner);
            $self->render(template => 'layouts/backend_gv/banner/edit_banner', banner => $banner, message => 'Cập nhật thành công', error=>'');   
        }
}

sub delete_banner{
    my $self = shift;
    my $id_banner = $self->param('id_banner');
    my $dbh = $self->app->{_dbh};
    my $result = $dbh->resultset('Banner')->find($id_banner)->delete({});
    my @banner = $self->app->{_dbh}->resultset('Banner')->search({});
    if($result) {
    @banner = map { { 
       id_banner => $_->id_banner,
       banner_name => $_->banner_name,
        image => $_->image
    } } @banner;
    $self->render(template => 'layouts/backend_gv/banner/banner', banner =>\@banner);
    }else {
    $self->render(template => 'layouts/backend_gv/banner/banner', banner =>\@banner);
    }
}

sub add_banner{
    my $self = shift;
    my $banner_name = $self->param('banner_name');
    my $image = $self->param('image');

    my $dbh = $self->app->{_dbh};
    my $result = $dbh->resultset('Banner')->search({});
    eval {
        $dbh->resultset('Banner')->create({
            banner_name => $banner_name,
            image => $image
        });
    };
    my @banner = $self->app->{_dbh}->resultset('Banner')->search({});  
    @banner = map { { 
        id_banner => $_->id_banner,
        banner_name => $_->banner_name,
        image => $_->image
    } } @banner;
    $self->render(template => 'layouts/backend_gv/banner/banner', banner =>\@banner, message => 'Thêm thành công', error=>'');
}     



1;
