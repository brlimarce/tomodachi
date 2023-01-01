import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomodachi/api/task_api.dart';
import 'package:tomodachi/models/task_model.dart';
import 'package:tomodachi/providers/task_provider.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/mock_data.dart';

/// To run this test, disable the configurations
/// of the REAL firebase.
///
/// 1. Comment out Lines 33-35 of `main.dart`.
/// 2. For API classes, comment out the real Firebase
/// instantiation and uncomment its mock counterparts.
///
void main() {
  group('Task Provider', () {
    final db = TaskAPI.db;
    TaskProvider provider = TaskProvider();

    /// Mock Data
    Task task = MockData.task;
    String dummyId = 'dummy_id';
    Map<String, dynamic> data = {
      'id': task.id,
      'uid': task.uid,
      'title': task.title,
      'description': task.description,
      'status': task.status,
      'deadline': task.deadline,
      'editor': task.editor
    };

    /// A helper function to add the
    /// task in the database.
    void addTask() async {
      await db.collection(TASK_COLLECTION).doc(dummyId).set({
        'title': task.title,
        'description': task.description,
        'status': task.status,
        'deadline': task.deadline,
        'editor': task.editor
      });
    }

    /// **********************************************
    /// * Test Cases
    /// **********************************************
    test('Get a stream of tasks.', () async {
      await db.collection(TASK_COLLECTION).add(data);
      Stream<QuerySnapshot> stream = provider.getAllTasks(task.uid);

      // The stream should be able to loop through
      // since it contains tasks.
      stream.forEach((element) {
        expect(element.docs.isEmpty, false);
      });
    });

    test('Add a task to the database.', () async {
      String res = await provider.addTask(task);
      expect(res, SUCCESS_MESSAGE);
    });

    test('Change the task\'s description.', () async {
      addTask();
      String res = await provider.editTask(
          dummyId,
          task.title,
          'This is a task that I should do.',
          task.deadline.toDate(),
          task.status,
          'John');
      expect(res, SUCCESS_MESSAGE);
    });

    test('A friend should change the task\'s title.', () async {
      addTask();
      String res = await provider.editFriendTask(dummyId, 'My Task',
          task.description, task.deadline.toDate(), 'Marites');
      expect(res, SUCCESS_MESSAGE);
    });

    test('Delete a task in the database.', () async {
      addTask();
      String res = await provider.deleteTask(dummyId);
      expect(res, SUCCESS_MESSAGE);
    });
  });
}
