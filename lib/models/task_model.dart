import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String? id;
  final String title;
  final String userId;
  final Timestamp? createdAt;

  TaskModel({
    this.id,
    required this.title,
    required this.userId,
    this.createdAt,
  });

  factory TaskModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return TaskModel(
      id: documentId,
      title: data['title'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'userId': userId,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}