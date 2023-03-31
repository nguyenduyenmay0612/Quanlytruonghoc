package MyClass::Controller::StudentController;
use utf8;
use open ':encoding(utf8)';
binmode(STDOUT, ":utf8");
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Data::Dumper;
use Mojo::Log;
my $log = Mojo::Log->new(path => '/log/app.log', level => 'warn');

#thoikhoabieu
sub schedule($self){   
    my $dbh = $self->app->{_dbh};
    my $emailStudent = $self->session('email');
    my $student = $dbh->resultset('Student')->search({"email" => $emailStudent})->first;
    my $class_id = $student->class_id;
    my @schedule_rows = $dbh->resultset('ScheduleSt')->search({"class_id" => $class_id});
    my @schedules = +();
    foreach my $schedule (@schedule_rows) {
        my $subject = $dbh->resultset('Subject')->find($schedule->subject_id);
        push @schedules, +{
            name_subject => $subject->name_subject,
            date => $schedule->date,
            lession => $schedule->lession,
            room => $schedule->room,
        };
    }
    if(@schedule_rows){
        $self->render(template => 'layouts/backend_sv/schedule', schedule => \@schedules);
    }
}

#danhbadienthoai
sub phone_student($self){
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


    $self->render(template => 'layouts/backend_sv/phone_student', student=>\@student_rows);
}

sub phone_teacher($self){
    my @teacher = $self->app->{_dbh}->resultset('Teacher')->search({});
    @teacher = map { { 
       id_teacher => $_->id_teacher,
       full_name => $_->full_name,
        #birthday => $_->birthday,
        email => $_->email,
        phone => $_->phone,
    } } @teacher;

    $self->render(template => 'layouts/backend_sv/phone_teacher', teacher=>\@teacher);
}

#lylichsinhvien
sub profile_student($self){
    my $id_student = $self->param('id_student');
    my $dbh = $self->app->{_dbh};
    my $emailStudent = $self->session('email');
    my $student = $dbh->resultset('Student')->search({"email" => $emailStudent})->first;

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
        $self->render(template => 'layouts/backend_sv/profile_student', student=>$student_info, );
    }    
}
#ketquahoctap
sub get_marks($self){
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

    $self->render(template => 'layouts/backend_sv/marks_student', marks => \@marks);
}

sub get_result($self){
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
            reult_10 => $result->reult_10,
            level => $result->level,
            result_total_4 => $result->result_total_4,
            result_total_10 => $result->result_total_10,
        }
    }
    $self->render(template => 'layouts/backend_sv/result', results =>\@results);
}

sub chungchi($self){
    $self->render(template => 'layouts/backend_sv/chungchi');
}

1;