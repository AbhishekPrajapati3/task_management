import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/task_controller.dart';

class AddScreen extends StatelessWidget {
  final TaskController taskController = Get.find();
  final TextEditingController _titleController = TextEditingController();

  AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: const Color(0xfff7f3dff),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Task Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
              String title = _titleController.text.trim();
              if (title.isNotEmpty) {
                await taskController.addTask(title);
                _titleController.clear();
                Get.offAllNamed('/home');
              } else {
                Get.snackbar('Error', 'Please enter a task title');
              }
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff7f3dff),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Add Task',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}