package MyClass::Controller::TeacherController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Convert::Base64;
use Mojo::Upload;
use Cwd qw();

#
# This is function to displays profile of teacher
# @param $self[Object] the instance of it self
# @return [Hash] The response data profile of student
#
sub profile_teacher($self) {
    my $dbh = $self->app->{_dbh};

    my $emailTeacher = $self->session('email');
    my $teacher = $dbh->resultset('Teacher')->search(+{"email" => $emailTeacher})->first;
    if ($teacher) {
        my $teacher_info = +{
            avatar => $teacher->avatar,
            full_name => $teacher->full_name,
            birthday => $teacher->birthday->strftime('%d/%m/%Y'),
            email => $teacher->email,
            phone => $teacher->phone,
        };
        $self->render(template => 'layouts/backend_teacher/profile_gv', teacher=>$teacher_info);
    }

    return;
}

#
# This is function to displays schedule of teacher
# @param $self[Object] the instance of it self
# @return @schedule[Array] The response data schedule of teacher
#
sub schedule($self) {
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
    if (@schedule_rows) {
        $self->render(template => 'layouts/backend_teacher/schedule',schedule =>\@schedules);
    }

    return;
}

#
# This is function to display the phonebook of students in class
# @param $self[Object] the instance of it self
# @return @student[Array] The response data phonebook of students
#
sub phone_student($self) {
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
    $self->render(template => 'layouts/backend_teacher/phone_student', student=>\@student_rows);

    return;
}

#
# This is function to display the phonebook of teachers
# @param $self[Object] the instance of it self
# @return @teacher[Array] The response data phonebook of teachers
#
sub phone_teacher($self) {
    my @teacher = $self->app->{_dbh}->resultset('Teacher')->search({});
    @teacher = map { { 
        id_teacher => $_->id_teacher,
        full_name => $_->full_name,
        email => $_->email,
        phone => $_->phone,
    } } @teacher;
    $self->render(template => 'layouts/backend_teacher/phone_teacher', teacher=>\@teacher);

    return;
}

#
# This is function to show list students
# @param $self[Object] the instance of it self
# @return @student [Array] The response data list student
#
sub list_student($self) {
    my $dbh = $self->app->{_dbh};

    my $email_Teacher = $self->session('email');
    my $teacher = $dbh->resultset('Teacher')->search({"email" => $email_Teacher})->first;
    my $class_id = $teacher->class_id;
    my @students = $dbh->resultset('Student')->search(+{"class_id" => $class_id});
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
    $self->render(template => 'layouts/backend_teacher/student/list_student', student=>\@student_rows, error => '', message => '');

    return;
}

#
# This is function to displays view add student 
# @param $self [Object] the instance of it self 
# @return [Void]  
#
sub add_view {
    my $self = shift;  

    $self -> render(template => 'layouts/backend_teacher/student/add_student',
    error    => $self->flash('error'),
    message  => $self->flash('message')
    );

    return;
}

#
# This is function to handle form add student
# @param $self [Object] the instance of it self
# @return [Void]
#
sub add_student {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

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
        $self->redirect_to('add_student');
    }
    my $email_teacher = $self->session('email');
    my $teacher = $self->app->{_dbh}->resultset('Teacher')->search({"email" => $email_teacher})->first;
    my $student = $dbh->resultset('Student')->search({ email => $email});

    if (!$student ->first ) {
        eval {
            $dbh->resultset('Student')->create({
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
       $self->render(template => 'layouts/backend_teacher/student/add_student', student => $student, message => 'Thêm thành công', error=>'');
    } else {
        $self->render(template => 'layouts/backend_teacher/student/add_student', student => $student, message => '', error=>'Email này đã tồn tại');
    }

    return;
}

#
# This is function to displays view edit student  
# @param $self [Object] the instance of it self
# @return [Hash] include properties of student
#
sub edit_view {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_student = $self->param('id');   
    my $student = $dbh->resultset('Student')->find($id_student);
    if ($student) {
        $self->render(template => 'layouts/backend_teacher/student/edit_student', student => $student , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/backend_teacher/student/list_student');
    }

    return;
}

#
# This is function to handle form edit student
# @param $self [Object] the instance of it self
# @return [Void]
#
sub edit_student {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_student = $self->param('id');
    my $full_name = $self->param('full_name');
    my $birthday = $self->param('birthday');
    my $email = $self->param('email');
    my $address = $self->param('address');
    my $phone= $self->param('phone');
    my $avatar= $self->param('avatar');
    my $student = $dbh->resultset('Student')->find($id_student);
    if ($student) {
        if ( ! $full_name || ! $birthday || ! $email || ! $address || ! $phone) {
            $self->render(template => 'layouts/backend_teacher/student/edit_student', student => $student, error=>'Không được bỏ trống các trường trên', message =>'');
        }    
        else {
            my $result= $dbh->resultset('Student')->find($id_student)->update(+{
                full_name => $full_name,
                birthday => $birthday,
                address => $address,
                email => $email,
                phone => $phone,
                avatar => $avatar
            });
            my $student1 = $dbh->resultset('Student')->find($id_student);
            $self->render(template => 'layouts/backend_teacher/student/edit_student', student => $student1, message => 'Cập nhật thông tin thành công', error=>'');   
        }
    }

    return;
}

#
# This is function to delete student
# @param $self [Object] the instance of it self
# @return @student [Array] The response data list student after delete
#
sub delete_student {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id_student = $self->param('id_student');
    my $result = $dbh->resultset('Student')->find($id_student)->delete({});
    my @student = $self->app->{_dbh}->resultset('Student')->search({});
    if ($result) {
        $self->redirect_to('/teacher/list_student');
        $self->flash(message => 'Đã xóa thành công');
    } else {
        $self->render(template => 'layouts/backend_teacher/student/list_student', student =>\@student);
    }

    return;
}

#
# This is function to search student
# @param $self [Object] The instance of it self
# @return @student [String] The response data list student
#
sub search_student {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $full_name = $self->param('full_name');
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
    $self->render(template => 'layouts/backend_teacher/student/list_student', student=>\@student, error => '', message =>'');

    return;
}

#
# This is function to displays schedule of student
# @param $self[Object] the instance of it self
# @return @schedule [Array] The response data list schedule of student
#
sub schedule_student {
    my $self = shift;
    my $dbh = $self->app->{_dbh};
    my $emailTeacher = $self->session('email');
    my $teacher = $self->app->{_dbh}->resultset('Teacher')->search({"email" => $emailTeacher})->first;
    my $class_id = $teacher->class_id;
    my @schedule_rows = $dbh->resultset('ScheduleSt')->search({"class_id" => $class_id});
    my @schedules = +();
    foreach my $schedule (@schedule_rows) {
        my $subject = $dbh->resultset('Subject')->find($schedule->subject_id);
        push @schedules, +{
            id => $schedule->id,
            name_subject => $subject->name_subject,
            date => $schedule->date,
            lession => $schedule->lession,
            room => $schedule->room,
        };
    }
    if (@schedule_rows) {
        $self->render(template => 'layouts/backend_teacher/manage_schedule_student/schedule_student', schedule => \@schedules);
    }

    return;
}

#
# This is function to displays view add schedule of student
# @param $self [Object] the instance of it self
# @return [Void]
#
sub add_schedule_student_view {
    my $self = shift;

    $self -> render(template => 'layouts/backend_teacher/manage_schedule_student/add_schedule_student',
        error    => $self->flash('error'),
        message  => $self->flash('message')
    );

    return;
}

#
# This is function to handle form add schedule of student 
# @param $self [Object] the instance of it self
# @return [Void]
#
sub add_schedule_student {
    my $self = shift;

    my $id = $self->param('id');
    my $date = $self->param('date');
    my $lession = $self->param('lession');
    my $subject_id = $self->param('subject_id');
    my $lession = $self->param('lession');
    my $room= $self->param('room');

    if (! $date || ! $lession || ! $subject_id || ! $lession || ! $room) {
        $self->flash(error => 'Các trường không thể thiếu');
        $self->redirect_to('add_student');
    }
    my $email_teacher = $self->session('email');
    my $teacher = $self->app->{_dbh}->resultset('Teacher')->search({"email" => $email_teacher})->first;

    eval {
        $self->app->{_dbh}->resultset('ScheduleSt')->create(+{
            class_id => $teacher->class_id,
            lession => $lession,
            date => $date,
            subject_id => $subject_id,
            lession => $lession,
            room => $room
        });
    };
    $self->render(template => 'layouts/backend_teacher/manage_schedule_student/add_schedule_student', message => 'Thêm thành công', error=>'');           

    return;
}

#
# This is function to displays view edit schedule of student
# @param $self [Object] the instance of it self
# @return [Hash] include properties of schedule of student
#
sub edit_schedule_student_view {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id = $self->param('id');
    my $schedule = $dbh->resultset('ScheduleSt')->find($id);
    if ($schedule) {
        $self->render(template => 'layouts/backend_teacher/manage_schedule_student/edit_schedule_student', schedule => $schedule , message => '', error=>'');
    } else {
        $self->render(template => 'layouts/backend_teacher/manage_schedule_student/schedule_student');
    }

    return;
}

#
# This is function to handle form edit schedule of student
# @param $self [Object] the instance of it self
# @return [Void]
#
sub edit_schedule_student {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id = $self->param('id');
    my $date = $self->param('date');
    my $subject_id = $self->param('subject_id');
    my $lession = $self->param('lession');
    my $room = $self->param('room'); 
    my $schedule = $dbh->resultset('ScheduleSt')->find($id);
    if ($schedule) {
        my $result= $dbh->resultset('ScheduleSt')->find($id)->update(+{
            date => $date,
            subject_id => $subject_id,
            lession => $lession,
            room => $room,
        });
        my $schedule1 = $dbh->resultset('ScheduleSt')->find($id);
        $self->render(template => 'layouts/backend_teacher/manage_schedule_student/edit_schedule_student', schedule => $schedule1, message => 'Cập nhật thành công', error=>'');   
    }

    return;
}

#
# This is function to delete schedule of student
# @param $self [Object] the instance of it self
# @return @schedule [Array] The response data list schedule of student after delete
#
sub delete_schedule_student {
    my $self = shift;
    my $dbh = $self->app->{_dbh};

    my $id = $self->param('id');  
    my $result = $dbh->resultset('ScheduleSt')->find($id)->delete(+{});
    my @schedule = $self->app->{_dbh}->resultset('ScheduleSt')->search(+{});
    if ($result) {
        $self->redirect_to('/teacher/schedule_student');
        $self->flash(message => 'Đã xóa thành công');
    } else {
        $self->render(template => 'layouts/backend_teacher/manage_schedule_student/schedule_student', schedule =>\@schedule);
    }

    return;
}

1;
