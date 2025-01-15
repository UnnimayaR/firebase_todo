import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/modules/todo/views/todo.dart';
import 'package:flutter_firebase/app/modules/todo/widgets/scaffold_messenger.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final resetController = TextEditingController();
  final passwordController = TextEditingController();
  var rememberMe = false.obs;
  Rx<User?> user = Rx<User?>(null);

  Future<void> loadRememberMe() async {
    final prefs = await SharedPreferences.getInstance();

    rememberMe.value = prefs.getBool('rememberMe') ?? false;
    if (rememberMe.value) {
      emailController.text = prefs.getString('email') ?? '';
    }
  }

  Future<void> _saveRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', rememberMe.value);
    if (rememberMe.value) {
      prefs.setString('email', emailController.text);
    } else {
      prefs.remove('email');
    }
  }

  void checkUserLoggedIn() {
    user.bindStream(_auth.authStateChanges());

    _auth.authStateChanges().listen((User? userr) {
      user = Rx<User?>(userr);

      update();

      if (user != Rx<User?>(null)) Get.toNamed(Routes.todo);
    });
  }

  @override
  onInit() {
    super.onInit();
    checkUserLoggedIn();
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await _saveRememberMe();
      Get.offAll(const TodoListPage());
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.code}'),
        ),
      );
    }
  }

  Future forgotPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      scaffoldMessenger('We have shared a mail to reset your password');
    } on FirebaseAuthException catch (err) {
      throw Exception(err.message.toString());
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}
