import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/task_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      Get.snackbar('Signup Error', e.toString());
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String message;

      if (e.code == 'invalid-email') {
        message = 'The email address format is not valid.';
      }else {
        message = 'Login failed. Please try again later.';
      }

      Get.snackbar('Login Error', message);
      return null;
    } catch (e) {
      Get.snackbar('Login Error', 'An unexpected error occurred.');
      return null;
    }
  }


  Future<void> logout() async {
    await _auth.signOut();
  }

  User? getCurrentUser() => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> addTask(TaskModel task) async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('tasks').add(task.toFirestore());
      Get.snackbar('Success', 'Task added successfully');
    } else {
      Get.snackbar('Error', 'You need to be logged in');
    }
  }
}