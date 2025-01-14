import 'package:flutter/material.dart';
import 'package:get/get.dart';

scaffoldMessenger(String msg) {
  return ScaffoldMessenger.of(Get.context!).showSnackBar(
    SnackBar(content: Text(msg)),
  );
}
