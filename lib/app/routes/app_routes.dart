part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const home = _Paths.home;
  static const auth = _Paths.auth;
  static const orderSummary = _Paths.orderSummary;
  static const verify = _Paths.verify;
  static const login = _Paths.login;
  static const register = _Paths.register;
  static const todo = _Paths.todo;
}

abstract class _Paths {
  _Paths._();
  static const home = '/home';
  static const auth = '/auth';
  static const orderSummary = '/orderSummary';
  static const verify = '/verify';
  static const login = '/login';
  static const todo = '/todo';
  static const register = '/register';
}
