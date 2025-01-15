import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/modules/todo/widgets/scaffold_messenger.dart';
import 'package:flutter_firebase/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

Widget buildDrawer() {
  TextEditingController nameController = TextEditingController();
  var user = FirebaseAuth.instance.currentUser.obs;
  var loading = false.obs;
  // ignore: unused_local_variable
  final storage = FirebaseStorage.instance;
  XFile? image;

  updatePhoto() async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef =
        storageRef.child('${user.value!.uid}.${image!.path.split('.').last}');
    loading.value = true;
    final imageBytes = await image!.readAsBytes();
    await imageRef.putData(imageBytes);
    imageRef.getDownloadURL().then((url) {
      log(url);
      user.value!
          .updateProfile(photoURL: url, displayName: user.value!.displayName)
          .then((value) {
        scaffoldMessenger("Profile has been changed successfully");
        user.value = FirebaseAuth.instance.currentUser;
        loading.value = false;
      }).catchError((e) {
        scaffoldMessenger("There was an error updating profile");
        loading.value = false;
      });
    }).catchError((onError) {
      log("Got Error $onError");
    });
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
              Obx(() => GestureDetector(
                    onTap: () => updatePhoto(),
                    child: loading.value
                        ? CircularProgressIndicator()
                        : CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.orange,
                            backgroundImage: user.value!.photoURL != null
                                ? NetworkImage(user.value!.photoURL!)
                                : null,
                            child: user.value!.photoURL == null
                                ? Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                  )),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      nameController.text = user.value!.displayName ?? 'User';
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Edit Name'),
                          content: TextField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(hintText: 'Enter name'),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                user.value!
                                    .updateProfile(
                                        displayName: nameController.text,
                                        photoURL: user.value!.photoURL)
                                    .then((value) {
                                  scaffoldMessenger(
                                      "Profile has been changed successfully");
                                  user.value =
                                      FirebaseAuth.instance.currentUser;
                                  loading.value = false;
                                }).catchError((e) {
                                  scaffoldMessenger(
                                      "There was an error updating profile");
                                  loading.value = false;
                                });
                                Get.back();
                              },
                              child: const Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Obx(() => Text(
                          user.value!.displayName ?? 'User',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                  ),
                ],
              ),
              Text(
                'ID: ${user.value!.uid.substring(0, 3) ?? '000'}',
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
