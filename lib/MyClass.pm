package MyClass;
use Mojo::Base 'Mojolicious', -signatures;
use MyClass::Model::DB ;

# This method will run once at server start
sub startup ($self) {

    #Database operations handler object
    $self->_set_db_operation_handler();  
    sub _set_db_operation_handler {
        my $self = shift;
        $self->{ _dbh } = MyClass::Model::DB->new();
        return $self;
    }

    # Set pagination
    $self->_set_pagination();
    sub _set_pagination {
        my $self = shift;
        $self->{paginate} = 8;
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
    $r->get('/sukien/:id_post')->to('Example#post_detail');
    $r->get('/thongbao/:id_noti')->to('Example#noti_detail');
    $r->get('/hoatdong/:id_activity')->to('Example#activity_detail');
    $r->get('/gioithieu')->to('Example#introduce');
    $r->get('/tuyensinh')->to('Example#admissions');
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
    
    #Thời khóa biểu và lịch dạy
    $student->get('/schedule')->to('StudentController#schedule');
    $teacher->get('/schedule')->to('TeacherController#schedule');

    #Danh bạ điện thoại
    $student->get('/phone_student')->to('StudentController#phone_student');
    $student->get('/phone_teacher')->to('StudentController#phone_teacher');
    $teacher->get('/phone_student')->to('TeacherController#phone_student');
    $teacher->get('/phone_teacher')->to('TeacherController#phone_teacher');
    
    #Lí lịch sinh viên, giảng viên
    $student->get('/profile_student')->to('StudentController#profile_student'); 
    $teacher->get('/profile_teacher')->to('TeacherController#profile_teacher'); 
    
    #Kết quả học tập
    $student->get('/marks_student')->to('StudentController#get_marks');
    $student->get('/result')->to('StudentController#get_result');  

    #Quản lý sinh viên
    $teacher->get('/list_student')->to('TeacherController#list_student');
    $teacher->get('/add_student')->to('TeacherController#add_view');
    $teacher->post('/add_student')->to('TeacherController#add_student');
    $teacher->get('/edit_student/:id')->to('TeacherController#edit_view');
    $teacher->post('/edit_student/:id')->to('TeacherController#edit_student');
    $teacher->get('/delete_student/:id_student')->to('TeacherController#delete_student');
    $teacher->post('/search_student')->to('TeacherController#search_student');

     #Quản lý giảng viên
    $admin->get('/list_teacher')->to('AdminController#list_teacher');
    $admin->get('/add_teacher')->to('AdminController#add_view');
    $admin->post('/add_teacher')->to('AdminController#add_teacher');
    $admin->get('/edit_teacher/:id_teacher')->to('AdminController#edit_view');
    $admin->post('/edit_teacher/:id_teacher')->to('AdminController#edit_teacher');
    $admin->get('/delete_teacher/:id_teacher')->to('AdminController#delete_teacher');
    $admin->post('/search_teacher')->to('AdminController#search_teacher');

    #Quản lý banner
    $admin->get('/banner')->to('BannerController#banner');
    $admin->get('/edit_banner/:id_banner')->to('BannerController#edit_banner_view');
    $admin->post('/edit_banner/:id_banner')->to('BannerController#edit_banner');
    $admin->get('/delete_banner/:id_banner')->to('BannerController#delete_banner');
    $admin->post('/add_banner')->to('BannerController#add_banner');

    #Quản lý bài viết tin tức, sự kiện
    $admin->get('/post')->to('PostController#post');
    $admin->get('/edit_post/:id_post')->to('PostController#edit_post_view');
    $admin->post('/edit_post/:id_post')->to('PostController#edit_post');
    $admin->get('/delete_post/:id_post')->to('PostController#delete_post');
    $admin->get('/add_post')->to('PostController#add_post_view');
    $admin->post('/add_post')->to('PostController#add_post');
    $admin->post('/search_post')->to('PostController#search_post');

    #Quản lý bài viết hoạt động
    $admin->get('/activity')->to('ActivityController#activity');
    $admin->get('/edit_activity/:id_activity')->to('ActivityController#edit_activity_view');
    $admin->post('/edit_activity/:id_activity')->to('ActivityController#edit_activity');
    $admin->get('/delete_activity/:id_activity')->to('ActivityController#delete_activity');
    $admin->get('/add_activity')->to('ActivityController#add_activity_view');
    $admin->post('/add_activity')->to('ActivityController#add_activity');
    $admin->post('/search_activity')->to('ActivityController#search_activity');

    #Quản lý bài viết thông báo
    $admin->get('/noti')->to('NotiController#noti');
    $admin->get('/edit_noti/:id_noti')->to('NotiController#edit_noti_view');
    $admin->post('/edit_noti/:id_noti')->to('NotiController#edit_noti');
    $admin->get('/delete_noti/:id_noti')->to('NotiController#delete_noti');
    $admin->get('/add_noti')->to('NotiController#add_noti_view');
    $admin->post('/add_noti')->to('NotiController#add_noti');
    $admin->post('/search_noti')->to('NotiController#search_noti');

    #Quản lý hình ảnh
    $admin->get('/image')->to('ImageController#image');
    $admin->get('/edit_image/:id_image')->to('ImageController#edit_image_view');
    $admin->post('/edit_image/:id_image')->to('ImageController#edit_image');
    $admin->get('/delete_image/:id_image')->to('ImageController#delete_image');
    $admin->post('/add_image')->to('ImageController#add_image');

    #Quản lý thời khóa biểu sinh viên
    $teacher->get('/schedule_student')->to('TeacherController#schedule_student');
    $teacher->get('/add_schedule_student')->to('TeacherController#add_schedule_student_view');
    $teacher->post('/add_schedule_student')->to('TeacherController#add_schedule_student');
    $teacher->get('/edit_schedule_student/:id')->to('TeacherController#edit_schedule_student_view');
    $teacher->post('/edit_schedule_student/:id')->to('TeacherController#edit_schedule_student');
    $teacher->get('/delete_schedule_student/:id')->to('TeacherController#delete_schedule_student');

    }

1;
