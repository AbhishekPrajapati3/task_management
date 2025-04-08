import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../services/firebase_service.dart';

class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  RxString email = ''.obs;
  RxString password = ''.obs;
  Rx<User?> user = Rx<User?>(null);

  Future<void> signUp() async {
    User? newUser = await _firebaseService.signUp(email.value, password.value);
    if (newUser != null) {
      Get.offNamed('/home');
    }
  }

  Future<void> login() async {
    User? loggedInUser = await _firebaseService.login(email.value, password.value);
    if (loggedInUser != null) {
      Get.offNamed('/home');
    }
  }

  Future<void> logout() async {
    await _firebaseService.logout();
    Get.offNamed('/login');
  }

  void checkAuthState() {
    _firebaseService.authStateChanges.listen((User? firebaseUser) {
      user.value = firebaseUser;
      String currentRoute = Get.currentRoute;
      if (firebaseUser == null && currentRoute != '/login') {
        Get.offAllNamed('/login');
      } else if (firebaseUser != null && currentRoute != '/home') {
        Get.offAllNamed('/home');
      }
    });
  }

  @override
  void onInit() {
    checkAuthState();
    super.onInit();
  }
}