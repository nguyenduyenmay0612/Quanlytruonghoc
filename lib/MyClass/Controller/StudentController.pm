package MyClass::Controller::StudentController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Mojo::Log;
my $log = Mojo::Log->new(path => '/log/app.log', level => 'warn');

#
# This is function to displays profile of student
# @param $self[Object] the instance of it self
# @return [Hash] The response data profile of student
#
sub profile_student($self) {
    my $dbh = $self->app->{_dbh};

    my $id_student = $self->param('id_student');
    my $email_student = $self->session('email');
    my $student = $dbh->resultset('Student')->search({"email" => $email_student})->first;
    if ($student) {
        my $class_id = $student->class_id;
        my $class = $dbh->resultset('Class')->search({"id_class" => $class_id});
        my $class_row =  $dbh->resultset('Class')->find($student->class_id);
        my $student_info = +{
            name_class => $class_row->name_class,
            avatar => $student->avatar,
            full_name => $student->full_name,
            birthday => $student->birthday->strftime('%d/%m/%Y'),
            address => $student->address,
            email => $student->email,
            phone => $student->phone,
        };
        $self->render(template => 'layouts/backend_student/profile_student', student=>$student_info );
    }

    return;
}

#
# This is function to displays schedule of student
# @param $self[Object] the instance of it self
# @return @schedule[Array] The response data schedule of student
#
sub schedule($self) {
    my $dbh = $self->app->{_dbh};

    my $emailStudent = $self->session('email');
    my $student = $dbh->resultset('Student')->search({"email" => $emailStudent})->first;
    my $class_id = $student->class_id;
    my @schedule_rows = $dbh->resultset('ScheduleSt')->search({"class_id" => $class_id});
    my @schedules = +();
    my $full_name = $student->full_name;
    foreach my $schedule (@schedule_rows) {
        my $subject = $dbh->resultset('Subject')->find($schedule->subject_id);
        push @schedules, +{
            name_subject => $subject->name_subject,
            date => $schedule->date,
            lession => $schedule->lession,
            room => $schedule->room,
        };
    }
    if (@schedule_rows) {
        $self->render(template => 'layouts/backend_student/schedule', schedule => \@schedules, full_name=>$full_name);
    }

    return;
}

#
# This is function to displays the phonebook of student in the same class
# @param $self[Object] the instance of it self
# @return @student[Array] The response data phonebook of students
#
sub phone_student($self) {
    my $dbh = $self->app->{_dbh};

    my $email_student = $self->session('email');
    my $student = $dbh->resultset('Student')->search({"email" => $email_student})->first;
    my $class_id = $student->class_id;
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
    $self->render(template => 'layouts/backend_student/phone_student', student=>\@student_rows);

    return;
}

#
# This is function to displays the phonebook of teacher
# @param $self[Object] the instance of it self
# @return @teacher[Array] The response data phonebook of teacher
#
sub phone_teacher($self) {
    my @teacher = $self->app->{_dbh}->resultset('Teacher')->search(+{});
    @teacher = map { +{ 
        id_teacher => $_->id_teacher,
        full_name => $_->full_name,
        email => $_->email,
        phone => $_->phone
    } } @teacher;
    $self->render(template => 'layouts/backend_student/phone_teacher', teacher=>\@teacher);

    return;
}

#
# This is function to displays marks of student
# @param $self[Object] the instance of it self
# @return @marks[Array] The response data marks of student
#
sub get_marks($self) {
    my $dbh = $self->app->{_dbh};

    my $email_student = $self->session('email');
    my $student = $dbh->resultset('Student')->search({"email" => $email_student})->first;
    my $id_student = $student->id_student;
    my @mark_student = $dbh->resultset('Mark')->search({"student_id" => $id_student});
    my @marks = +();
    foreach my $mark (@mark_student) {
        my $subject = $dbh->resultset('Subject')->find($mark->subject_id);
        push @marks, +{
            name_subject => $subject->name_subject,
            marks_1 => $mark->marks_1,
            marks_2 => $mark->marks_2,
            marks_3 => $mark->marks_3,
            marks_total => $mark->marks_total
        }
    }
    $self->render(template => 'layouts/backend_student/marks_student', marks => \@marks);

    return;
}

#
# This is function to displays result of student
# @param $self[Object] the instance of it self
# @return @result[Array] The response data result of student
#
sub get_result($self) {
    my $dbh = $self->app->{_dbh};

    my $email_student = $self->session('email');
    my $student = $dbh->resultset('Student')->search({"email" => $email_student})->first;
    my $id_student = $student->id_student;
    my @result_student = $dbh->resultset('Result')->search({"student_id" => $id_student});
    my @results = +();
    foreach my $result (@result_student) {
        push @results, +{
            semester => $result->semester,
            school_year => $result->school_year,
            result_4 => $result->result_4,
            result_10 => $result->result_10,
            level => $result->level,
            result_total_4 => $result->result_total_4,
            result_total_10 => $result->result_total_10,
        }
    }
    $self->render(template => 'layouts/backend_student/result', results =>\@results);

    return;
}

1;
