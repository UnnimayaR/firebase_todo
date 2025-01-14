import 'package:flutter/material.dart';
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
        title: const Text('Todo List'),
      ),
      body: Obx(() => ListView.builder(
            itemCount: todoController.todos.length,
            itemBuilder: (context, index) {
              final todo = todoController.todos[index];
              return ListTile(
                title: Text(todo['task']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        todoController.taskController.text = todo['task'];
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Add Todo'),
                            content: TextField(
                              controller: todoController.taskController,
                              decoration:
                                  const InputDecoration(hintText: 'Enter task'),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Get.back(),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  todoController.editTodo(
                                      todo.id, todo['task']);
                                  Get.back();
                                },
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
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
                                  todoController.deleteTodo(todo.id);
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
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(
            AlertDialog(
              title: const Text('Add Todo'),
              content: TextField(
                controller: todoController.taskController,
                decoration: const InputDecoration(hintText: 'Enter task'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    todoController.addTodo();
                    Get.back();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
