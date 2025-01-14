import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../todo/views/todo.dart';
import 'login_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data != null) {
            return const TodoListPage();
          } else {
            return const LoginPage();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
