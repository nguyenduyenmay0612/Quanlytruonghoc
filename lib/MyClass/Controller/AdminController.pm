package MyClass::Controller::AdminController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Convert::Base64;
use Mojo::Upload;
use Cwd qw();

sub list_teacher($self) {
    my $dbh = $self->app->{_dbh};

    my @teachers = $dbh->resultset('Teacher')->search(+{});
    my @teacher_rows = +();
    foreach my $teacher (@teachers) {
        my $class = $dbh->resultset('Class')->find($teacher->class_id);
        push @teacher_rows, +{
            id_teacher => $teacher->id_teacher,
            full_name => $teacher->full_name,
            birthday => $teacher->birthday->strftime('%d/%m/%Y'),
            address => $teacher->address,
            email => $teacher->email,
            phone => $teacher->phone,
            name_class => $class->name_class
        }
    }
    $self->render(template => 'layouts/admin/teacher/list_teacher', teacher=>\@teacher_rows, error => '', message => '');
}

#them sinh vien moi
sub add_view {
    my $self = shift;
    $self->render(template => 'layouts/admin/teacher/add_teacher',
        error => $self->flash('error'),
        message => $self->flash('message')
    );
}

sub add_teacher{
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_student = $self->param('id_teacher');
    my $full_name = $self->param('full_name');
    my $birthday = $self->param('birthday');
    my $email = $self->param('email');
    my $address = $self->param('address');
    my $phone= $self->param('phone');
    my $password= $self->param('password');
    my $avatar= $self->param('avatar');
    my $class_id= $self->param('class_id');
    if (! $full_name || ! $birthday || ! $email || ! $address || ! $password) {
        $self->flash(error => 'Tên, ngày sinh, email, password và địa chỉ là các trường không thể thiếu');
        $self->redirect_to('add_teacher');
    }   
    my $teacher = $dbh->resultset('Teacher')->search({ email => $email});
    if (!$teacher ->first) {
        eval {
            $dbh->resultset('Teacher')->create({
                full_name => $full_name,
                birthday => $birthday,
                address => $address,
                phone => $phone,
                email => $email,
                password => $password,
                avatar => $avatar,
                class_id => $class_id
            });
        };
       $self->render(template => 'layouts/admin/teacher/add_teacher', teacher => $teacher, message => 'Thêm thành công', error=>'');
    } else {
        $self->render(template => 'layouts/admin/teacher/add_teacher', teacher => $teacher, message => '', error=>'Email này đã tồn tại');
    }     
}

#sua thong tin sinh vien
sub edit_view {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_teacher = $self->param('id_teacher');   
    my $teacher = $dbh->resultset('Teacher')->find($id_teacher);    
    if ($teacher) {
        $self->render(template => 'layouts/admin/teacher/edit_teacher', teacher => $teacher , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/admin/teacher/list_teacher');
    }
}

sub edit_teacher {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_teacher = $self->param('id_teacher');
    my $full_name = $self->param('full_name');
    my $birthday = $self->param('birthday');
    my $email = $self->param('email');
    my $address = $self->param('address');
    my $phone= $self->param('phone');
    my $avatar= $self->param('avatar');
    my $class_id= $self->param('class_id');
     
    my $teacher = $dbh->resultset('Teacher')->find($id_teacher);
    if ($teacher) {
        if ( ! $full_name || ! $birthday || ! $email || ! $address || ! $phone) {
            $self->render(template => 'layouts/admin/teacher/edit_teacher', teacher => $teacher, error=>'Không được bỏ trống các trường trên', message =>'');
        } else {
            my $result= $dbh->resultset('Teacher')->find($id_teacher)->update({  
            full_name => $full_name,
            birthday => $birthday,
            address => $address,
            email => $email,
            phone => $phone,
            class_id => $class_id,
            avatar => $avatar
            });
            my $teacher1 = $dbh->resultset('Teacher')->find($id_teacher);
            $self->render(template => 'layouts/admin/teacher/edit_teacher', teacher => $teacher1, message => 'Cập nhật thông tin thành công', error=>'');   
        }
    }
}

#xoa sinh vien 
sub delete_teacher {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_teacher = $self->param('id_student');    
    my $result = $dbh->resultset('Teacher')->find($id_teacher)->delete({});
    my @teacher = $self->app->{_dbh}->resultset('Teacher')->search({});
    if ($result) {
        $self->redirect_to('/admin/list_teacher');
        $self->flash(message => 'Đã xóa thành công');
    } else {
        $self->render(template => 'layouts/admin/teacher/list_sv', teacher =>\@teacher);
    }
}

sub search_teacher {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $full_name = $self->param('full_name');
    my @teacher = $dbh->resultset('Teacher')->search_like(+{ full_name => '%'.$full_name.'%' });
    @teacher = map { +{ 
        id_teacher => $_->id_teacher,
        full_name => $_->full_name,
        birthday => $_->birthday,
        address => $_->address,
        email => $_->email,
        phone => $_->phone,
        avatar => $_->avatar
    } } @teacher;
    $self->render(template => 'layouts/admin/teacher/list_teacher', teacher=>\@teacher, error => '', message =>'');
}

1;
