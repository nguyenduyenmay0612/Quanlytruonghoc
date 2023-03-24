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
    $r->get('/teacher')->to('LoginLogout#displayLogin_teacher');
    $r->get('/student/login')->to('LoginLogout#login_student');
    $r->get('/teacher/login')->to('LoginLogout#login_teacher');
    $r->post('/student/login')->to('LoginLogout#validUserCheck_student');
    $r->post('/teacher/login')->to('LoginLogout#validUserCheck_teacher');
    $r->any('/logout')->to('LoginLogout#logout');

    my $student = $r->under('/student/')->to('LoginLogout#alreadyLoggedIn_student');
    my $teacher = $r->under('/teacher/')->to('LoginLogout#alreadyLoggedIn_teacher');
    
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
    $student->get('/diemhocphan')->to('StudentController#diemhocphan');
    $student->get('/ketqua_xhv')->to('StudentController#ketqua_xhv');
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

    #cap nhat thong tin giang vien
    $teacher->get('/edit_gv')->to('TeacherController#edit_gv');

    #tim kiem sinh vien
    $teacher->post('/search_sv')->to('TeacherController#search_sv');

    #quan ly banner
    $teacher->get('/banner')->to('BannerController#banner');
    $teacher->get('/edit_banner/:id_banner')->to('BannerController#edit_banner_view');
    $teacher->post('/edit_banner/:id_banner')->to('BannerController#edit_banner');
    $teacher->get('/delete_banner/:id_banner')->to('BannerController#delete_banner');
    $teacher->post('/add_banner')->to('BannerController#add_banner');

    #quan ly TKB sinh vien
    $teacher->get('/edit_schedule')->to('ScheduleController#edit_schedule_view');
    $teacher->post('/edit_schedule')->to('ScheduleController#edit_schedule');

    #quan ly bai viet tren trang chủ 
    $teacher->get('/post')->to('PostController#post');
    $teacher->get('/edit_post/:id_post')->to('PostController#edit_post_view');
    $teacher->post('/edit_post/:id_post')->to('PostController#edit_post');
    $teacher->get('/delete_post/:id_post')->to('PostController#delete_post');
    $teacher->get('/add_post')->to('PostController#add_post_view');
    $teacher->post('/add_post')->to('PostController#add_post');

    #quan ly hoat dong
    $teacher->get('/activity')->to('ActivityController#activity');
    $teacher->get('/edit_activity/:id_activity')->to('ActivityController#edit_activity_view');
    $teacher->post('/edit_activity/:id_activity')->to('ActivityController#edit_activity');
    $teacher->get('/delete_activity/:id_activity')->to('ActivityController#delete_activity');
    $teacher->get('/add_activity')->to('ActivityController#add_activity_view');
    $teacher->post('/add_activity')->to('ActivityController#add_activity');

    #quan ly thong bao
    $teacher->get('/noti')->to('NotiController#noti');
    $teacher->get('/edit_noti/:id_noti')->to('NotiController#edit_noti_view');
    $teacher->post('/edit_noti/:id_noti')->to('NotiController#edit_noti');
    $teacher->get('/delete_noti/:id_noti')->to('NotiController#delete_noti');
    $teacher->get('/add_noti')->to('NotiController#add_noti_view');
    $teacher->post('/add_noti')->to('NotiController#add_noti');

    #quan ly hinh anh 
    $teacher->get('/image')->to('ImageController#image');
    $teacher->get('/edit_image/:id_image')->to('ImageController#edit_image_view');
    $teacher->post('/edit_image/:id_image')->to('ImageController#edit_image');
    $teacher->get('/delete_image/:id_image')->to('ImageController#delete_image');
    $teacher->post('/add_image')->to('ImageController#add_image');

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
