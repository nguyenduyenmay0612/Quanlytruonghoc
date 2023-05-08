package MyClass::Controller::LoginLogout;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::JSON qw(encode_json);
use Email::Valid;

#
# This is the form login student view function
# @param $self[Object] the instance of it self
# @return [Void]
#
sub login_student($self) {
    $self->render(template => 'layouts/frontend/login_student',
    error=> $self->flash('error') );
}

#
# This is the form login teacher view function
# @param $self[Object] the instance of it self
# @return [Void]
#
sub login_teacher($self) {
    $self->render(template => 'layouts/frontend/login_teacher',
    error=> $self->flash('error'));
}

#
# This is the form login admin view function
# @param $self[Object] the instance of it self
# @return [Void]
#
sub login_admin($self) {
    $self->render(template => 'layouts/admin/login_admin',
    error=> $self->flash('error'));
}

#
# This is the log out function
# @param $self[Object] the instance of it self
# @return [Void]
#
sub logout($self) {
    $self->session(expires => 1);
    $self->redirect_to('/');
}

#
# This is the checks session cookies to see if the students has already logged in function
# @param $self [Object] the instance of it self
# @return [Void]
#
sub alreadyLoggedIn_student($self) {
    #print (Dumper($self->session) );
    if($self->session("is_auth")) {
        return 1;
    } else {
        $self->redirect_to('/student/login');
        return;
    }
}

#
# This is the checks session cookies to see if the teachers has already logged in function
# @param $self [Object] the instance of it self
# @return [Void]
#
sub alreadyLoggedIn_teacher($self) {
    if($self->session("is_auth")) {
        return 1;
    } else {
        $self->redirect_to('/teacher/login');
        return;
    }
}

#
# This is the checks session cookies to see if the admin has already logged in function
# @param $self [Object] the instance of it self
# @return [Void]
#
sub alreadyLoggedIn_admin($self) {
    if($self->session("is_auth")) {
        return 1;
    } else {
        $self->redirect_to('/admin/login');
        return;
    }
}

#
# This function is displayed on the following page if you are already logged in, else display page login
# @param $self [Object] the instance of it self
# @return [Void]
#
sub displayLogin_student($self) {
    if(&alreadyLoggedIn_student($self)) {
        my $dbh = $self->app->{_dbh};

        my $email_student = $self->session('email');
        my $student = $dbh->resultset('Student')->search({"email" => $email_student})->first;
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
            }
        }
        if (@schedule_rows) {
            $self->render(template => 'layouts/backend_student/schedule', schedule => \@schedules, full_name=>$full_name );
        } else {
            $self->flash(error => 'Mời bạn đăng nhập!');
            $self->redirect_to('/student/login');  
        }

        return;
    }
}

#
# This function is displayed on the following page if you are already logged in, else display page login
# @param $self [Object] the instance of it self
# @return [Void]
#
sub displayLogin_teacher($self) {
    if(&alreadyLoggedIn_student($self)) {
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
            $self->render(template => 'layouts/backend_teacher/schedule', schedule =>\@schedules);
        } else {
            $self->flash(error => 'Mời bạn đăng nhập!');
            $self->redirect_to('/teacher/login');  
        }

        return;
    }
}

#
# This function is displayed on the following page if you are already logged in, else display page login
# @param $self [Object] the instance of it self
# @return [Void]
#
sub displayLogin_admin($self) {
    if (&alreadyLoggedIn_admin($self)) {
        $self->render(template => 'layouts/admin/index');
    } else {
        $self->flash(error => 'Mời bạn đăng nhập!');
        $self->redirect_to('/admin/login'); 
    }

    return;
}

#
# This is the check the details entered by the student in the login page and authenticates the user to access the website function
# @param $self [Object] the instance of it self
# @return [Void]
#
sub validUserCheck_student ($self) {
    my $dbh = $self->app->{_dbh};

    my $class_id = $self->param('class_id');
    my $email = $self->param('email');
    my $password = $self->param('password');
    my $id_subject = $self->param('id_subject');
    my $data = $dbh->resultset('Student')->search({email=>$email, password=>$password})->first;
    if ($data && !!%$data) {
        $self->session(is_auth => 1);
        $self->session(email => $email);
        $self->session(expiration => 600);
        $self->redirect_to('/student');
    } else {
        $self->flash(error => 'Email hoặc mật khẩu của bạn không đúng');
        $self->redirect_to('/student/login');
    }
}

#
# This is the  check the details entered by the teacher in the login page and authenticates the user to access the website function
# @param $self [Object] the instance of it self
# @return [Void]
#
sub validUserCheck_teacher($self) {
    my $dbh = $self->app->{_dbh};

    my $email = $self->param('email');
    my $password = $self->param('password');
    my $data = $dbh->resultset('Teacher')->search({email=>$email, password=>$password})->first;
    if ($data && !!%$data) {
    $self->session(is_auth => 1);
    $self->session(email => $email);
    $self->session(expiration => 600);
    $self->redirect_to('/teacher');
    } else {
        $self->flash(error => 'Email hoặc mật khẩu của bạn không đúng');
        $self->redirect_to('/teacher/login');
    }
}

#
# This is the  check the details entered by the admin in the login page and authenticates the user to access the website function
# @param $self [Object] the instance of it self
# @return [Void]
#
sub validUserCheck_admin($self) {
    my $dbh = $self->app->{_dbh};

    my $email = $self->param('email');
    my $password = $self->param('password');
    my $data = $dbh->resultset('Admin')->search({email=>$email, password=>$password})->first;
    if ($data && !!%$data) {
        $self->session(is_auth => 1);
        $self->session(email => $email);
        $self->session(expiration => 600);
        $self->redirect_to('/admin');
    } else {
        $self->flash(error => 'Email hoặc mật khẩu của bạn không đúng');
        $self->redirect_to('/admin/login');
    }
}

1;
