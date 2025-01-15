import 'package:flutter/material.dart';
import 'package:flutter_firebase/app/modules/todo/widgets/text_field_widget.dart';
import 'package:get/get.dart';

import '../widgets/drawer.dart';
import '../controller/todo_controller.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TodoController todoController = Get.put(TodoController());

    return Scaffold(
      drawer: buildDrawer(),
      appBar: AppBar(
        title: const Text('Your Tasks'),
      ),
      body: Obx(() => Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: todoController.todos.length,
              itemBuilder: (context, index) {
                final todo = todoController.todos[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    onTap: () {
                      todoController.taskController.text = todo['title'];
                      todoController.descriptionController.text =
                          todo['description'];
                      todoController.dateController.text = todoController
                          .formatter
                          .format(DateTime.parse(todo['dueDate']));
                      todoController.selectedPriority.value = todo['priority'];
                      todoController.status.value = todo['status'];
                      todoController.todoAlert(isFromEdit: true, todo: todo);
                    },
                    tileColor: todo['priority'] == 'HIGH'
                        ? Colors.red[100]
                        : todo['priority'] == 'MEDIUM'
                            ? Colors.amber
                            : Colors.lightBlue[100],
                    title: Text(todo['title'] ?? ''),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo['description']),
                        Text(todoController.formatter
                            .format(DateTime.parse(todo['dueDate']))),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () {
                            todoController.taskController.text = todo['title'];
                            todoController.descriptionController.text =
                                todo['description'];
                            todoController.dateController.text = todoController
                                .formatter
                                .format(DateTime.parse(todo['dueDate']));
                            todoController.selectedPriority.value =
                                todo['priority'];
                            todoController.status.value = todo['status'];
                            todoController.completeTask(todo);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todoController.todoAlert();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class Constants {
  static const List<String> choices = <String>['Edit', 'Delete'];
}
