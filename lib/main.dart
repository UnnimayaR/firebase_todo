import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/routes/app_pages.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  // FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;
  // firebaseAppCheck.activate();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Auth App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: AppPages.initial,
        getPages: AppPages.routes);
  }
}
