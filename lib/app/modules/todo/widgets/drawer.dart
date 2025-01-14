import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/modules/todo/widgets/scaffold_messenger.dart';
import 'package:flutter_firebase/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

Widget buildDrawer() {
  var user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  // ignore: unused_local_variable
  final storage = FirebaseStorage.instance;
  XFile? image;

  updatePhoto() async {
    log('hdgfjhsgjhsdjh');
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    try {
      final user = auth.currentUser;
      if (user != null) {
        if (image != null) {
          // if (await Utils.hasNetwork()) {
          // Utils.showLoader();
          File imageFile = File(image!.path);

          FirebaseStorage storage = FirebaseStorage.instance;
          Reference ref = storage.ref().child(user.uid);
          UploadTask uploadTask = ref.putFile(imageFile);
          uploadTask.then((res) {
            if (res.state == TaskState.success) {
              res.ref.getDownloadURL().then((url) {
                print(url);
              }).catchError((onError) {
                print("Got Error $onError");
              });
            }
          });
          // final imageRef = storage.ref().child('user_images/${user.photoURL}');
          // final uploadTask = await imageRef.putFile(File(image!.path));
          // final imageUrl = await uploadTask.ref.getDownloadURL();

          user.updateProfile(photoURL: 'imageUrl').then((value) {
            scaffoldMessenger("Profile has been changed successfully");
            //DO Other compilation here if you want to like setting the state of the app
          }).catchError((e) {
            scaffoldMessenger("There was an error updating profile");
          });
        }
      }
    } catch (e) {
      // Handle errors here
      scaffoldMessenger('Error updating user profile: $e');
      scaffoldMessenger('Error updating profile: $e');
    }
  }

  return Drawer(
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          color: Colors.green,
          child: Column(
            children: [
              SizedBox(height: 30),
              GestureDetector(
                onTap: () => updatePhoto(),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.orange,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user?.displayName ?? user?.email ?? 'User',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'ID: ${user?.uid.substring(0, 3) ?? '000'}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Log out'),
          onTap: () async {
            await GoogleSignIn().signOut();
            await FirebaseAuth.instance.signOut();

            Get.offAllNamed(Routes.login);
          },
        ),
      ],
    ),
  );
}
