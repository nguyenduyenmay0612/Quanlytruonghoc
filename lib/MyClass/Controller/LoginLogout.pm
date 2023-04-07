package MyClass::Controller::LoginLogout;
use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Mojo::JSON qw(encode_json);
use Email::Valid;
use Data::Dumper;

sub login_student($self){

    $self->render(template => 'layouts/frontend/login_student',
    error=> $self->flash('error') );   
}
sub login_teacher($self){
    $self->render(template => 'layouts/frontend/login_teacher', 
    error=> $self->flash('error'));
}

sub login_admin($self){
    $self->render(template => 'layouts/admin/login_admin', 
    error=> $self->flash('error'));
}

sub logout {
    my $self = shift;
    $self->session(expires => 1);
    $self->redirect_to('/');
}

sub alreadyLoggedIn_student ($self){
     print (Dumper($self->session) );
    if($self->session("is_auth")){
        return 1;
    } else {
        $self->redirect_to('/student/login');
        return;
    }
}
sub alreadyLoggedIn_teacher ($self){
    if($self->session("is_auth")){
        return 1;
    } else {
        $self->redirect_to('/teacher/login');
        return;
    }
}

sub alreadyLoggedIn_admin ($self){
    if($self->session("is_auth")){
        return 1;
    } else {
        $self->redirect_to('/admin/login');
        return;
    }
}

sub displayLogin_student ($self) {
  if(&alreadyLoggedIn_student($self)) {
    my $dbh = $self->app->{_dbh};
    my $email_student = $self->session('email');
    my $student = $dbh->resultset('Student')->search({"email" => $email_student})->first;
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
        }
    }
    if (@schedule_rows) {
        $self->render(template => 'layouts/backend_sv/schedule', schedule => \@schedules);
    }
                   
    } else {
    $self->flash(error => 'Mời bạn đăng nhập!');
    $self->redirect_to('/student/login');  }
}

sub displayLogin_teacher ($self) {
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
    if (@schedule_rows){
        $self->render(template => 'layouts/backend_gv/schedule',schedule =>\@schedules);
    }  
  } else {
    $self->flash(error => 'Mời bạn đăng nhập!');
    $self->redirect_to('/student/login');  }
}

sub displayLogin_admin ($self) {
    if(&alreadyLoggedIn_admin($self)) {
        $self->render(template => 'layouts/admin/index');
                   
    } else {
        $self->flash(error => 'Mời bạn đăng nhập!');
        $self->redirect_to('/admin/login'); 
    }
}


#validUserCheck 
sub validUserCheck_student ($self) {
    my $class_id = $self->param('class_id');
    my $email = $self->param('email');
    my $password = $self->param('password');
    my $id_subject = $self->param('id_subject'); 
    my $dbh = $self->app->{_dbh};
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

sub validUserCheck_teacher($self) {
    my $email = $self->param('email');
    my $password = $self->param('password');
    my $dbh = $self->app->{_dbh};
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

sub validUserCheck_admin($self) {
    my $email = $self->param('email');
    my $password = $self->param('password');
    my $dbh = $self->app->{_dbh};
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



#action form login
# sub loginto_sv($self){
#     my $email = $self->param('email');
#     my $password = $self->param('password');  
#     my @valid_input = $self->_validate_form($email, $password);
#     my $db_object = $self->app->{_dbh};
    
#     my $student = $db_object->resultset('Student')->search({email=>$email,password=>$password})->first;
#     if ($student) {
#             my @schedule_sv = $self->app->{_dbh}->resultset('ScheduleSt')->search({});
#             @schedule_sv  = map { { 
#             name_subject => $_->name_subject,
#             teacher => $_->teacher,
#             room=> $_->room,
#             date => $_->date,
#             lession => $_->lession,
#             } } @schedule_sv ;

#             $self->render(template => 'layouts/backend_sv/schedule_week',schedule_sv =>\@schedule_sv);

#     } else {
#         $self->flash(error => 'Email hoặc mật khẩu của bạn không đúng');
#         $self->redirect_to('login_sv');
#     }     
# }

# sub loginto_gv($self){
#     my $email = $self->param('email');
#     my $password = $self->param('password');
    
#     my @valid_input = $self->_validate_form($email, $password);
#     my $db_object = $self->app->{_dbh};
    
#     my $teacher = $db_object->resultset('Teacher')->search({email=>$email,password=>$password})->first;
#     if ($teacher) {
#         my @schedule_gv = $self->app->{_dbh}->resultset('ScheduleTch')->search({});
#         @schedule_gv  = map { { 
#             name_subject => $_->name_subject,
#             lession => $_->lession,
#             room=> $_->room,
#             date => $_->date,
#         } } @schedule_gv ;

#         $self->render(template => 'layouts/backend_gv/schedule_gv',schedule_gv =>\@schedule_gv);
#     } else {
#          $self->flash(error => 'Email hoặc mật khẩu của bạn không đúng');
#         $self->redirect_to('login_gv');
#     }
    
   
# }

1;
