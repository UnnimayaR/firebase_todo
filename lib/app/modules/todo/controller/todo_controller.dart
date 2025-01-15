import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/modules/todo/widgets/scaffold_messenger.dart';
import 'package:flutter_firebase/app/modules/todo/widgets/text_field_widget.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TodoController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final taskController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final todos = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;
  final DateFormat formatter = DateFormat('dd/MM/yyyy');
  var selectedPriority = 'HIGH'.obs;
  var status = 'PENDING'.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    ever(todos, (_) {});
    _fetchTodos();
  }

  Future<void> _fetchTodos() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('todos')
          .get();
      todos.value = snapshot.docs;
      update();
    } catch (e) {
      // Handle errors here
      print('Error fetching todos: $e');
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;

      dateController.text = formatter.format(selectedDate);
    }
  }

  Future<void> addTodo() async {
    if (formKey.currentState!.validate()) {
      try {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('todos')
            .add({
          'title': taskController.text,
          'description': descriptionController.text,
          'dueDate': selectedDate.toIso8601String(),
          'priority': selectedPriority.value,
          'status': 'PENDING'
        });
        taskController.clear();
        _fetchTodos();
        Get.back();
      } catch (e) {
        // Handle errors here
        scaffoldMessenger('Error adding todo: $e');
        Get.back();
      }
    }
  }

  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    } else {
      return null;
    }
  }

  Future<void> editTodo(String todoId, {bool isFromComplete = false}) async {
    log(todoId);
    try {
      if (todoId.isEmpty) {
        scaffoldMessenger('Error: todoId is empty');
        return;
      }

      if (taskController.text.isEmpty) {
        scaffoldMessenger('Error: taskController.text is empty');
        return;
      }
      if (formKey.currentState!.validate()) {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('todos')
            .doc(todoId)
            .update({
          'title': taskController.text,
          'description': descriptionController.text,
          'dueDate': selectedDate.toIso8601String(),
          'priority': selectedPriority.value,
          'status': status.value
        });
        scaffoldMessenger('Updated Successfully');

        _fetchTodos();
        Get.back();
      }
    } catch (e) {
      Get.back();
      // Handle errors here
      scaffoldMessenger('Error editing todo: $e');
    }
  }

  Future<void> deleteTodo(String todoId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('todos')
          .doc(todoId)
          .delete();
      scaffoldMessenger('Deleted Successfully');
      _fetchTodos();
    } catch (e) {
      // Handle errors here
      scaffoldMessenger('Error deleting todo: $e');
    }
  }

  completeTask(todo) {
    Get.dialog(
      AlertDialog(
        title: const Text('Complete Task'),
        content: Text('Are you sure to mark the task as completed?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              editTodo(todo.id, isFromComplete: true);
            },
            child: const Text('Okay'),
          ),
        ],
      ),
    );
  }

  todoAlert({bool isFromEdit = false, todo}) {
    Get.defaultDialog(
      title: (isFromEdit ? 'Edit Todo' : 'Add Todo'),
      content: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldWidget(
                controller: taskController,
                hintText: 'Enter task',
                validator: validateRequired,
              ),
              TextFieldWidget(
                controller: descriptionController,
                hintText: 'Enter description',
              ),
              TextFieldWidget(
                controller: dateController,
                hintText: 'Enter date',
                onTap: () {
                  selectDate(Get.context!);
                },
              ),
              Row(
                children: [
                  Text('Priority : '),
                  SizedBox(
                    width: 15,
                  ),
                  Obx(() => DropdownButton<String>(
                        value: selectedPriority.value,
                        items: <String>['HIGH', 'MEDIUM', 'LOW']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          selectedPriority.value = newValue!;
                        },
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            isFromEdit ? editTodo(todo.id) : addTodo();
          },
          child: Text(isFromEdit ? 'Update' : 'Add'),
        ),
        if (isFromEdit)
          IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Delete Task'),
                  content: Text('Are you sure to delete the task?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        deleteTodo(todo.id);
                        Get.back();
                      },
                      child: const Text('Okay'),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
