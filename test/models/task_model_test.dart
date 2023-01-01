import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomodachi/models/task_model.dart';
import 'package:tomodachi/utility/mock_data.dart';

/// To run this test, disable the configurations
/// of the REAL firebase.
///
/// 1. Comment out Lines 33-35 of `main.dart`.
/// 2. For API classes, comment out the real Firebase
/// instantiation and uncomment its mock counterparts.
///
void main() {
  group('Task Model', () {
    test('A Task instance should be created.', () {
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());
      final instance = Task(
          uid: 'some_uid',
          title: 'Test Task Constructor',
          description: 'Make this unit test work.',
          status: 'In Progress',
          deadline: timestamp,
          editor: {'editor_id': timestamp});

      // Check if the data matches with the instance.
      expect(instance.uid, 'some_uid');
      expect(instance.title, 'Test Task Constructor');
      expect(instance.description, 'Make this unit test work.');
      expect(instance.status, 'In Progress');
      expect(instance.deadline, timestamp);
      expect(instance.editor, {'editor_id': timestamp});
    });

    test('A Task should be converted into JSON.', () {
      final task = MockData.task;
      final converted = task.toJson(task);

      // Check if the converted data matches
      // those of the Task instance.
      expect(converted, {
        'id': task.id,
        'uid': task.uid,
        'title': task.title,
        'description': task.description,
        'status': task.status,
        'deadline': task.deadline,
        'editor': task.editor
      });
    });
  });
}
