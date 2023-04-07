package MyClass;
use Mojo::Base 'Mojolicious', -signatures;
use MyClass::Model::DB ;

# This method will run once at server start
sub startup ($self) {

    $self->_set_db_operation_handler();
    # $self->_db_handler();  ## Add after this line
    $self->_set_pagination();
    # Database operations handler object
    sub _set_db_operation_handler {
        my $self = shift;
        $self->{ _dbh } = MyClass::Model::DB->new();
        return $self;
    }
    sub _set_pagination {
        my $self = shift;
        $self->{paginate} = 10;
        return $self;
    }
    sub _get_pagination {
        my $self = shift;
        return $self->{paginate};
    }

    # Load configuration from config file
    my $config = $self->plugin('NotYAMLConfig');

    # Configure the application
    $self->secrets($config->{secrets});

    # Router
    my $r = $self->routes;

    # Normal route to controller
    $r->get('/')->to('Example#welcome');
    $r->get('/sukien/:id_post')->to('Example#sukien_detail');
    $r->get('/thongbao/:id_noti')->to('Example#thongbao_detail');
    $r->get('/hoatdong/:id_activity')->to('Example#hoatdong_detail');
    $r->get('/gioithieu')->to('Example#gioithieu');
    $r->get('/tuyensinh')->to('Example#tuyensinh');
    $r->get('/sukien')->to('Example#welcome');

    #login_logout
    $r->get('/student')->to('LoginLogout#displayLogin_student');
    $r->get('/student/login')->to('LoginLogout#login_student');
    $r->post('/student/login')->to('LoginLogout#validUserCheck_student');
    $r->get('/teacher')->to('LoginLogout#displayLogin_teacher');
    $r->get('/teacher/login')->to('LoginLogout#login_teacher');  
    $r->post('/teacher/login')->to('LoginLogout#validUserCheck_teacher');
    $r->get('/admin')->to('LoginLogout#displayLogin_admin');
    $r->get('/admin/login')->to('LoginLogout#login_admin');  
    $r->post('/admin/login')->to('LoginLogout#validUserCheck_admin');
    $r->any('/logout')->to('LoginLogout#logout');

    my $student = $r->under('/student/')->to('LoginLogout#alreadyLoggedIn_student');
    my $teacher = $r->under('/teacher/')->to('LoginLogout#alreadyLoggedIn_teacher');
    my $admin = $r->under('/admin/')->to('LoginLogout#alreadyLoggedIn_admin');
    
    #thoikhoabieu
    $student->get('/schedule')->to('StudentController#schedule');


    #danh ba dien thoai
    $student->get('/phone_student')->to('StudentController#phone_student');
    $student->get('/phone_teacher')->to('StudentController#phone_teacher');
    $teacher->get('/phone_student')->to('TeacherController#phone_student');
    $teacher->get('/phone_teacher')->to('TeacherController#phone_teacher');
    
    #lylich
    $student->get('/profile_student')->to('StudentController#profile_student'); 
    $teacher->get('/profile_teacher')->to('TeacherController#profile_teacher'); 
    
    #ketquahoctap
    $student->get('/marks_student')->to('StudentController#get_marks');
    $student->get('/result')->to('StudentController#get_result');
    $student->get('/chungchi')->to('StudentController#chungchi');  

    #lichday
    $teacher->get('/schedule')->to('TeacherController#schedule');

    #quan ly sinh viên
    $teacher->get('/list_sv')->to('TeacherController#list_sv');
    $teacher->get('/add_sv')->to('TeacherController#add_view');
    $teacher->post('/add_sv')->to('TeacherController#add_sv');
    $teacher->get('/edit_sv/:id')->to('TeacherController#edit_view');
    $teacher->post('/edit_sv/:id')->to('TeacherController#edit_sv');
    $teacher->get('/delete_sv/:id_student')->to('TeacherController#delete_sv');

     #quan ly giang vien
    $admin->get('/list_gv')->to('AdminController#list_gv');
    $admin->get('/add_gv')->to('AdminController#add_view');
    $admin->post('/add_gv')->to('AdminController#add_gv');
    $admin->get('/edit_gv/:id_teacher')->to('AdminController#edit_view');
    $admin->post('/edit_gv/:id_teacher')->to('AdminController#edit_gv');
    $admin->get('/delete_gv/:id_teacher')->to('AdminController#delete_gv');


    #tim kiem sinh vien/ giang vien
    $teacher->post('/search_sv')->to('TeacherController#search_sv');
    $admin->post('/search_gv')->to('AdminController#search_gv');


    #quan ly diem 
    $teacher->post('/show_marks')->to('ScheduleController#show_marks');

    #quan ly banner
    $admin->get('/banner')->to('BannerController#banner');
    $admin->get('/edit_banner/:id_banner')->to('BannerController#edit_banner_view');
    $admin->post('/edit_banner/:id_banner')->to('BannerController#edit_banner');
    $admin->get('/delete_banner/:id_banner')->to('BannerController#delete_banner');
    $admin->post('/add_banner')->to('BannerController#add_banner');

    

    #quan ly bai viet tren trang chủ 
    $admin->get('/post')->to('PostController#post');
    $admin->get('/edit_post/:id_post')->to('PostController#edit_post_view');
    $admin->post('/edit_post/:id_post')->to('PostController#edit_post');
    $admin->get('/delete_post/:id_post')->to('PostController#delete_post');
    $admin->get('/add_post')->to('PostController#add_post_view');
    $admin->post('/add_post')->to('PostController#add_post');

    #quan ly hoat dong
    $admin->get('/activity')->to('ActivityController#activity');
    $admin->get('/edit_activity/:id_activity')->to('ActivityController#edit_activity_view');
    $admin->post('/edit_activity/:id_activity')->to('ActivityController#edit_activity');
    $admin->get('/delete_activity/:id_activity')->to('ActivityController#delete_activity');
    $admin->get('/add_activity')->to('ActivityController#add_activity_view');
    $admin->post('/add_activity')->to('ActivityController#add_activity');

    #quan ly thong bao
    $admin->get('/noti')->to('NotiController#noti');
    $admin->get('/edit_noti/:id_noti')->to('NotiController#edit_noti_view');
    $admin->post('/edit_noti/:id_noti')->to('NotiController#edit_noti');
    $admin->get('/delete_noti/:id_noti')->to('NotiController#delete_noti');
    $admin->get('/add_noti')->to('NotiController#add_noti_view');
    $admin->post('/add_noti')->to('NotiController#add_noti');

    #quan ly hinh anh 
    $admin->get('/image')->to('ImageController#image');
    $admin->get('/edit_image/:id_image')->to('ImageController#edit_image_view');
    $admin->post('/edit_image/:id_image')->to('ImageController#edit_image');
    $admin->get('/delete_image/:id_image')->to('ImageController#delete_image');
    $admin->post('/add_image')->to('ImageController#add_image');

    }

    # Pagination 
    sub _db_handler {
    my $self = shift;

    $self->{dbh} = mojoForum::Model::DB->new();

    return $self;
    }

    sub _set_pagination {
        my $self = shift;
        $self->{paginate} = 10;
        return $self;
    }

    sub _get_pagination {
        my $self = shift;

        return $self->{paginate};
    }

    
1;
