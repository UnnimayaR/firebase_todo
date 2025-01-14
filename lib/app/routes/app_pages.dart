import 'package:flutter_firebase/app/modules/todo/views/todo.dart';
import 'package:flutter_firebase/app/modules/todo_login/views/login_page.dart';
import 'package:flutter_firebase/app/modules/todo_login/views/register.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: _Paths.login,
      page: () => LoginPage(),
    ),
    GetPage(
      name: _Paths.register,
      page: () => RegisterPage(),
    ),
    GetPage(
      name: _Paths.todo,
      page: () => TodoListPage(),
    ),
  ];
}
