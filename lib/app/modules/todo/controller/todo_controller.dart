import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/modules/todo/widgets/scaffold_messenger.dart';
import 'package:get/get.dart';

class TodoController extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final taskController = TextEditingController();
  final todos = <QueryDocumentSnapshot<Map<String, dynamic>>>[].obs;

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

  Future<void> addTodo() async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('todos')
          .add({'task': taskController.text});
      taskController.clear();
      _fetchTodos();
    } catch (e) {
      // Handle errors here
      print('Error adding todo: $e');
    }
  }

  Future<void> editTodo(String todoId, String currentTask) async {
    try {
      if (todoId.isEmpty) {
        scaffoldMessenger('Error: todoId is empty');
        return;
      }

      if (taskController.text.isEmpty) {
        scaffoldMessenger('Error: taskController.text is empty');
        return;
      }

      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('todos')
          .doc(todoId)
          .update({'task': taskController.text});
      scaffoldMessenger('Updated Successfully');

      _fetchTodos();
    } catch (e) {
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
}
