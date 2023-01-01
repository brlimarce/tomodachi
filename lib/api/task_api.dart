import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomodachi/utility/constants.dart';

// ignore: unused_import
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

// ignore: unused_import
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// ignore: unused_import
import 'package:tomodachi/utility/mock_data.dart';

class TaskAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  /// **********************************************
  /// * Mock Data
  /// * ! Uncomment to try out the widget test.
  /// **********************************************
  // static final db = FakeFirebaseFirestore();
  // static final auth = MockData.auth;

  /// Fetch all [Task] based on [User.id].
  Stream<QuerySnapshot> getAllTasks(String uid) {
    return db
        .collection(TASK_COLLECTION)
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  /// Add a [Task] from [User] (logged) in Firebase.
  Future<String> addTask(Map<String, dynamic> task) async {
    try {
      final docRef = await db.collection(TASK_COLLECTION).add(task);
      await db
          .collection(TASK_COLLECTION)
          .doc(docRef.id)
          .update({'id': docRef.id});
      return SUCCESS_MESSAGE;
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  /// Delete a [Task] from [User] based on [Task.id].
  Future<String> deleteTask(String? id) async {
    try {
      await db.collection(TASK_COLLECTION).doc(id).delete();
      return SUCCESS_MESSAGE;
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  /// Edit a [Task] from [User] based on [Task.id].
  Future<String> editTask(String? id, String title, String description,
      DateTime deadline, String status, String editor) async {
    try {
      await db.collection(TASK_COLLECTION).doc(id).update({
        'title': title,
        'description': description,
        'status': status,
        'deadline': deadline,
        'editor': {'name': editor, 'timestamp': Timestamp.now()}
      });
      return SUCCESS_MESSAGE;
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  /// Edit a [Task] from [User] based on [Task.id].
  ///
  /// * Note: This function is only available for
  /// * the user's friends.
  Future<String> editFriendTask(String? id, String title, String description,
      DateTime deadline, String editor) async {
    try {
      await db.collection(TASK_COLLECTION).doc(id).update({
        'title': title,
        'description': description,
        'deadline': deadline,
        'editor': {'name': editor, 'timestamp': Timestamp.now()}
      });
      return SUCCESS_MESSAGE;
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }
}
