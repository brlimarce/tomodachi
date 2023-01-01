import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tomodachi/api/task_api.dart';
import 'package:tomodachi/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  late TaskAPI service;

  /// **********************************************
  /// * Constructor
  /// **********************************************

  TaskProvider() {
    service = TaskAPI();
  }

  /// Fetch a [Stream] of [Task] from Firebase
  /// based on [User.id].
  // Stream<QuerySnapshot> get tasks => _taskStream;
  Stream<QuerySnapshot> getAllTasks(String uid) {
    return service.getAllTasks(uid);
  }

  /// Adds a [Task] in Firebase based on [User.id].
  Future<String> addTask(Task task) async {
    String res = await service.addTask(task.toJson(task));
    notifyListeners();
    return res;
  }

  /// Deletes a [Task] in Firebase based on [User.id].
  ///
  /// * Note: Only OWNER can delete the task.
  Future<String> deleteTask(String? id) async {
    String res = await service.deleteTask(id);
    notifyListeners();
    return res;
  }

  /// Edits a [Task] in Firebase based on [User.id].
  ///
  /// * Note: Only OWNER can edit the complete
  /// * details of the task.
  Future<String> editTask(String? id, String title, String description,
      DateTime deadline, String status, String editor) async {
    String res = await service.editTask(
        id, title, description, deadline, status, editor);
    notifyListeners();
    return res;
  }

  /// Edits a [Task] in Firebase based on [User.id].
  ///
  /// * Note: Only FRIEND can edit a user's task
  /// * except for the status.
  Future<String> editFriendTask(String? id, String title, String description,
      DateTime deadline, String editor) async {
    String res =
        await service.editFriendTask(id, title, description, deadline, editor);
    notifyListeners();
    return res;
  }
}
