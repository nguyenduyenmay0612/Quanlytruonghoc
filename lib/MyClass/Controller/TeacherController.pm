package MyClass::Controller::TeacherController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Convert::Base64;
use Mojo::Upload;
use Cwd qw();

#ly lich giang vien
sub profile_teacher($self){
    my $dbh = $self->app->{_dbh};
    my $emailTeacher = $self->session('email');
    my $teacher = $dbh->resultset('Teacher')->search({"email" => $emailTeacher})->first;
    if ($teacher) {
        my $teacher_info = +{
            avatar => $teacher->avatar,
            full_name => $teacher->full_name,
            birthday => $teacher->birthday->strftime('%d/%m/%Y'),
            email => $teacher->email,
            phone => $teacher->phone,
        };
        $self->render(template => 'layouts/backend_gv/profile_gv', teacher=>$teacher_info);
    }    
}

#lich giang day theo tuan của giang vien
sub schedule($self){
    my $dbh = $self->app->{_dbh};
    my $email_teacher = $self->session('email');
    my $teacher = $dbh->resultset('Teacher')->search({"email" => $email_teacher})->first;
    my $id_teacher = $teacher->id_teacher;
    my @schedule_rows = $dbh->resultset('ScheduleTch')->search({"teacher_id" => $id_teacher});
    my @schedules = +();
    foreach my $schedule (@schedule_rows) {
        my $subject = $dbh->resultset('Subject')->find($schedule->subject_id);
        push @schedules, +{
            name_subject => $subject->name_subject,
            lession => $schedule->lession,
            room=> $schedule->room,
            date => $schedule->date,
        }
    }
    if (@schedule_rows){
        $self->render(template => 'layouts/backend_gv/schedule',schedule =>\@schedules);
}
}

#hien thi danh ba dien thoai sinh vien lop
sub phone_student($self){
    my $dbh = $self->app->{_dbh};
    my $email_teacher = $self->session('email');
    my $teacher = $dbh->resultset('Teacher')->search({"email" => $email_teacher})->first;
    my $class_id = $teacher->class_id;
    my @students = $dbh->resultset('Student')->search({"class_id" => $class_id});             
    my @student_rows = +();
    foreach my $student (@students) {
        push @student_rows, +{
        id_student => $student->id_student,
        full_name => $student->full_name,      
        email => $student->email,
        phone => $student->phone
    };
    }

    $self->render(template => 'layouts/backend_gv/phone_student', student=>\@student_rows);
}

#hien thi danh ba dien thoai giang vien lop
sub phone_teacher($self){
    my @teacher = $self->app->{_dbh}->resultset('Teacher')->search({});
    @teacher = map { { 
       id_teacher => $_->id_teacher,
       full_name => $_->full_name,
        email => $_->email,
        phone => $_->phone,
    } } @teacher;

    $self->render(template => 'layouts/backend_gv/phone_teacher', teacher=>\@teacher);
}

#hien thi danh sach thong tin sinh vien
sub list_sv($self){
    my $dbh = $self->app->{_dbh};
    my $emailTeacher = $self->session('email');
    my $teacher = $dbh->resultset('Teacher')->search({"email" => $emailTeacher})->first;
    my $class_id = $teacher->class_id;
    my @students = $dbh->resultset('Student')->search({"class_id" => $class_id});             
    my @student_rows = +();
    foreach my $student (@students) {
        push @student_rows, +{
        id_student => $student->id_student,
        full_name => $student->full_name,
        birthday => $student->birthday->strftime('%d/%m/%Y'),
        address => $student->address,
        email => $student->email,
        phone => $student->phone
    };
    }
    # @students = map { { 
    #     id_student => $_->id_student,
    #     full_name => $_->full_name,
    #     birthday => $_->birthday,
    #     address => $_->address,
    #     email => $_->email,
    #     phone => $_->phone
    # } } @student;

    $self->render(template => 'layouts/backend_gv/student/list_sv', student=>\@student_rows, error => '', message => '');
}

#them sinh vien moi
sub add_view {
    my $self = shift;  
    $self -> render(template => 'layouts/backend_gv/student/add_sv', 
            error    => $self->flash('error'),
            message  => $self->flash('message')
    );
}

sub add_sv {
    my $self = shift;
    my $id_student = $self->param('id_student');
    my $full_name = $self->param('full_name');
    my $birthday = $self->param('birthday');
    my $email = $self->param('email');
    my $address = $self->param('address');
    my $phone= $self->param('phone');
    my $password= $self->param('password');
    my $avatar= $self->param('avatar');

    if (! $full_name || ! $birthday || ! $email || ! $address || ! $password) {
        $self->flash(error => 'Tên sinh viên, ngày sinh, email, password và địa chỉ là các trường không thể thiếu');
        $self->redirect_to('add_sv');
    }
    my $emailTeacher = $self->session('email');
    my $teacher = $self->app->{_dbh}->resultset('Teacher')->search({"email" => $emailTeacher})->first;
    # my $class_id = $teacher->class_id;
    my $dbh = $self->app->{_dbh};
    my $student = $dbh->resultset('Student')->search({ email => $email});

    if (!$student ->first ) {
        eval {
            $dbh->resultset('Student')->create({
                # id_student => $id_student,
                class_id => $teacher->class_id,
                full_name => $full_name,
                birthday => $birthday,
                address => $address,
                phone => $phone,               
                email => $email,
                password => $password,
                avatar => $avatar
            });
        };
       $self->render(template => 'layouts/backend_gv/student/add_sv', student => $student, message => 'Thêm thành công', error=>'');
    } 
    else {
        $self->render(template => 'layouts/backend_gv/student/add_sv', student => $student, message => '', error=>'Email này đã tồn tại');
    }     
}

#sua thong tin sinh vien
sub edit_view {
    my $self = shift;
    my $id_student = $self->param('id');
    my $dbh = $self->app->{_dbh};
    my $student = $dbh->resultset('Student')->find($id_student);
    
    if ($student) {
        $self->render(template => 'layouts/backend_gv/student/edit_sv', student => $student , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/backend_gv/student/list_sv');
    }

}
sub edit_sv {
    my $self = shift;
    my $id_student = $self->param('id');
    my $full_name = $self->param('full_name');
    my $birthday = $self->param('birthday');
    my $email = $self->param('email');
    my $address = $self->param('address');
    my $phone= $self->param('phone');
    my $avatar= $self->param('avatar');
    my $dbh = $self->app->{_dbh}; 

    my $student = $dbh->resultset('Student')->find($id_student);
    if ($student) {
        if ( ! $full_name || ! $birthday || ! $email || ! $address || ! $phone) {
            $self->render(template => 'layouts/backend_gv/student/edit_sv', student => $student, error=>'Không được bỏ trống các trường trên', message =>'');
        }    
        else {
            my $result= $dbh->resultset('Student')->find($id_student)->update({  
            full_name => $full_name,
            birthday => $birthday,
            address => $address,
            email => $email,
            phone => $phone,
            avatar => $avatar
            });
            my $student1 = $dbh->resultset('Student')->find($id_student);
            $self->render(template => 'layouts/backend_gv/student/edit_sv', student => $student1, message => 'Cập nhật thông tin thành công', error=>'');   
        }
    }
}

#xoa sinh vien 
sub delete_sv{
    my $self = shift;
    my $id_student = $self->param('id_student');
    my $dbh = $self->app->{_dbh};
    my $result = $dbh->resultset('Student')->find($id_student)->delete({});
    my @student = $self->app->{_dbh}->resultset('Student')->search({});
    if($result) {
        $self->redirect_to('/teacher/list_sv');
        $self->flash(message => 'Đã xóa thành công');
    }else {
    $self->render(template => 'layouts/backend_gv/student/list_sv', student =>\@student);
    }
}

sub search_sv{
    my $self = shift;
    my $dbh = $self->app->{_dbh};
    my $full_name = $self->param('full_name');
    my $emailTeacher = $self->session('email');
    my $teacher = $dbh->resultset('Teacher')->search({"email" => $emailTeacher})->first;
    my $class_id = $teacher->class_id;
    my @students = $dbh->resultset('Student')->search({"class_id" => $class_id});
    if (@students) {
    my @student = $self->app->{_dbh}->resultset('Student')->search_like({ full_name => '%'.$full_name.'%' });
    @student = map { { 
        id_student => $_->id_student,
        full_name => $_->full_name,
        birthday => $_->birthday,
        address => $_->address,
        email => $_->email,
        phone => $_->phone,
        avatar => $_->avatar
    } } @student;
    $self->render(template => 'layouts/backend_gv/student/list_sv', student=>\@student, error => '', message =>'');
}
}


1;
