import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/task_model.dart';

import '../controllers/auth_controller.dart';
import '../controllers/task_controller.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find();
  final TaskController taskController = Get.find();
  final TextEditingController _searchController = TextEditingController();
  RxList<TaskModel> filteredTasks = <TaskModel>[].obs;

  @override
  void initState() {
    super.initState();
    filteredTasks.value = taskController.tasks;
    _searchController.addListener(() {
      _filterTasks();
    });
  }

  void _filterTasks() {
    String query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredTasks.value = taskController.tasks;
    } else {
      filteredTasks.value = taskController.tasks
          .where((task) => task.title.toLowerCase().contains(query))
          .toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => authController.logout(),
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        shadowColor: const Color(0xffff7f3dff),
        elevation: 4,
        backgroundColor: const Color(0xfff7f3dff),
        leading: const Icon(Icons.home, color: Colors.white),
        title: const Center(
          child: Text(
            "Task Management",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'inter',
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Tasks',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (taskController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (filteredTasks.isEmpty) {
                return const Center(
                  child: Text(
                    "Add Task, No Task Found",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    String formattedTime = task.createdAt != null
                        ? DateFormat('M/d/y hh:mm').format(task.createdAt!.toDate())
                        : 'No Time';
                    final backgroundColor = index.isEven ? Colors.grey[100] : Colors.white;

                    return Container(
                      color: backgroundColor,
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(formattedTime),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditDialog(context, task);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteDialog(context,task);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddScreen());
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, TaskModel task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: const Text("Are you sure"),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await taskController.deleteTask(task.id!);
                Get.offAllNamed('/home');
              },
              child: const Text('Yes'),

            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, TaskModel task) {
    final TextEditingController editController = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(
              labelText: 'New Title',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newTitle = editController.text.trim();
                if (newTitle.isNotEmpty) {
                  await taskController.updateTask(task.id!, newTitle);
                  Get.offAllNamed('/home');
                } else {
                  Get.snackbar('Error', 'Please enter a new title');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}