
import 'package:get/get.dart';
import 'package:task_mgmt/views/home_screen.dart';
import 'package:task_mgmt/views/login_screen.dart';
import 'package:task_mgmt/views/register_screen.dart';
import 'bindings/initial_bindings.dart';


class AppRoutes {
  static final List<GetPage> pages = [
    GetPage(
      name: '/home',
      page: () =>  HomeScreen(),
      binding: AppBindings(),
    ),
    GetPage(
      name: '/register',
      page: () => RegisterScreen(),
      binding: AppBindings(),
    ),
    GetPage(name: '/login',
    page:()=> LoginScreen(),
      binding: AppBindings()


    )
  ];
}

