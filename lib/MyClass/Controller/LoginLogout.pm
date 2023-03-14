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

sub displayLogin_student ($self) {
  if(&alreadyLoggedIn_student($self)) {
   my @schedule = $self->app->{_dbh}->resultset('ScheduleSt')->search({});
            @schedule  = map { { 
            name_subject => $_->name_subject,
            teacher => $_->teacher,
            room=> $_->room,
            date => $_->date,
            lession => $_->lession,
            } } @schedule ;
            $self->render(template => 'layouts/backend_sv/schedule',schedule =>\@schedule);
     
  } else {
    $self->flash(error => 'Mời bạn đăng nhập!');
    $self->redirect_to('/student/login');  }
}

sub displayLogin_teacher ($self) {
  if(&alreadyLoggedIn_student($self)) {
   my @schedule = $self->app->{_dbh}->resultset('ScheduleTch')->search({});
            @schedule  = map { { 
            name_subject => $_->name_subject,
            lession => $_->lession,
            room=> $_->room,
            date => $_->date,
            } } @schedule ; 
            $self->render(template => 'layouts/backend_gv/schedule',schedule =>\@schedule);
     
  } else {
    $self->flash(error => 'Mời bạn đăng nhập!');
    $self->redirect_to('/student/login');  }
}

#validUserCheck 
sub validUserCheck_student ($self) {
    my $email = $self->param('email');
    my $password = $self->param('password');
    my $dbh = $self->app->{_dbh};
    my $data = $dbh->resultset('Student')->search({email=>$email, password=>$password})->first;
    if ($data && !!%$data) {
      $self->session(is_auth => 1);
      $self->session(email => $email);
      $self->session(expiration => 600);
      my @schedule = $self->app->{_dbh}->resultset('ScheduleSt')->search({});
            @schedule  = map { { 
            name_subject => $_->name_subject,
            teacher => $_->teacher,
            room=> $_->room,
            date => $_->date,
            lession => $_->lession,
            } } @schedule ;
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
      my @schedule = $self->app->{_dbh}->resultset('ScheduleTch')->search({});
            @schedule  = map { { 
            name_subject => $_->name_subject,
            lession => $_->lession,
            room=> $_->room,
            date => $_->date,
            } } @schedule ;
            $self->redirect_to('/teacher');    
    } else {
        $self->flash(error => 'Email hoặc mật khẩu của bạn không đúng');
        $self->redirect_to('/teacher/login');
    }
}

1;
