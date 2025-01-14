import 'package:flutter_firebase/app/modules/todo/controller/todo_controller.dart';
import 'package:get/get.dart';

class TodoBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodoController());
  }
}
