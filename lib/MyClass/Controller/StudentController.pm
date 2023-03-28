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
    my @student = $self->app->{_dbh}->resultset('Student')->search({});
    @student = map { { 
        id_student => $_->id_student,
        full_name => $_->full_name,
        email => $_->email,
        phone => $_->phone,
    } } @student;

    $self->render(template => 'layouts/backend_sv/phone_student', student=>\@student);
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
        my $student_info = +{
            avatar => $student->avatar,
            full_name => $student->full_name,
            birthday => $student->birthday,
            address => $student->address,
            email => $student->email,
            phone => $student->phone,
        };
        $self->render(template => 'layouts/backend_sv/profile_student', student=>$student_info);
    }    
}
#ketquahoctap
sub diemhocphan($self){
    my $id_student = $self->param('id_student');
    my $dbh = $self->app->{_dbh};
    my $marks = $dbh->resultset('Mark')->search({});
    if ($marks) {
        my $my_marks = +{
            
        }
    }
    $self->render(template => 'layouts/backend_sv/diemhocphan');
}

sub ketqua_xhv($self){
    $self->render(template => 'layouts/backend_sv/ketqua_xhv');
}

sub chungchi($self){
    $self->render(template => 'layouts/backend_sv/chungchi');
}

1;