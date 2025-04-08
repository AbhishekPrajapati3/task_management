import 'package:get/get.dart';
import '../services/firebase_service.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  final FirebaseService _firebaseService = Get.find();
  RxList<TaskModel> tasks = <TaskModel>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    fetchTasks();
    super.onInit();
  }

  void fetchTasks() {
    String? userId = _firebaseService.getCurrentUser()?.uid;
    print('Fetching Tasks for UserID: $userId');
    if (userId != null) {
      isLoading.value = true;
      _firebaseService.firestore
          .collection('tasks')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .listen((snapshot) {
        tasks.value = snapshot.docs.map((doc) {
          return TaskModel.fromFirestore(doc.data(), doc.id);
        }).toList();
        print('Tasks Fetched: ${tasks.length} tasks');
        isLoading.value = false;
      }, onError: (e) {
        isLoading.value = false;
        print('Error Fetching Tasks: $e');
        Get.snackbar('Error', 'Failed to fetch tasks: $e');
      });
    } else {
      isLoading.value = false;
      print('No UserID Found');
    }
  }

  Future<void> addTask(String title) async {
    String? userId = _firebaseService.getCurrentUser()?.uid;
    if (userId != null) {
      TaskModel newTask = TaskModel(
        title: title,
        userId: userId,
      );
      await _firebaseService.addTask(newTask);
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _firebaseService.firestore.collection('tasks').doc(taskId).delete();
      Get.snackbar('Success', 'Task deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: $e');
    }
  }

  Future<void> updateTask(String taskId, String newTitle) async {
    try {
      await _firebaseService.firestore.collection('tasks').doc(taskId).update({
        'title': newTitle,
      });
      Get.snackbar('Success', 'Task updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task: $e');
    }
  }
}