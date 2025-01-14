import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/modules/todo_login/controller/login_controller.dart';
import 'package:flutter_firebase/app/modules/todo_login/views/register.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
    loginController.loadRememberMe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginController.emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: loginController.passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: loginController.rememberMe.value,
                  onChanged: (value) {
                    setState(() {
                      loginController.rememberMe.value = value!;
                    });
                  },
                ),
                const Text('Remember Me'),
              ],
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                loginController.signInWithEmailAndPassword();
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => const RegisterPage());
              },
              child: const Text('Register'),
            ),
            // TextButton(
            //   onPressed: () {
            //     // Implement Forgot Password functionality here
            //     // ...
            //   },
            //   child: const Text('Forgot Password?'),
            // ),
          ],
        ),
      ),
    );
  }
}
