import 'package:get/get.dart';
import 'package:task_mgmt/controllers/auth_controller.dart';
import 'package:task_mgmt/services/firebase_service.dart';

import '../controllers/task_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
  Get.put(FirebaseService(),permanent: true);
  Get.put(AuthController(),permanent: true);
  Get.put(TaskController(),permanent: true);


  }
}