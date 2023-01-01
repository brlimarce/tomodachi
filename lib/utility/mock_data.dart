import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:tomodachi/models/task_model.dart';
import 'package:tomodachi/models/user_model.dart';

class MockData {
  /// **********************************************
  /// * Properties
  /// **********************************************
  static const String uid = '01cd03ba';
  static const String email = 'mock_user@gmail.com';
  static const String password = 'mock_password';

  /// This is used for Firebase authentication.
  static final auth = MockFirebaseAuth(
      mockUser: MockUser(
    isAnonymous: false,
    uid: uid,
    email: email,
    displayName: 'Jane',
  ));

  /// This resembles the user's task.
  static final Task task = Task(
      id: '12sx4e0a',
      uid: uid,
      title: 'Do homework',
      description: 'Pages 20-27 (MATH 27)',
      status: 'Not Started',
      deadline: Timestamp.fromDate(DateTime.now()),
      editor: {'friend_id': Timestamp.fromDate(DateTime.now())});

  /// This resembles the user (OWNER).
  static final User owner = User(
      id: uid,
      username: 'jane_doe',
      email: email,
      firstName: 'Jane',
      lastName: 'Doe',
      birthdate: Timestamp.fromDate(DateTime.now()),
      country: 'Philippines',
      biography: 'This is my profile.',
      friends: [],
      receivedRequests: [],
      sentRequests: []);

  /// This resembles another user (MUTUAL).
  static final User mutual = User(
      id: '02ab03dc',
      username: 'john_doe',
      email: 'john_doe@gmail.com',
      firstName: 'John',
      lastName: 'Doe',
      birthdate: Timestamp.fromDate(DateTime.now()),
      country: 'United States of America',
      biography: 'This is my biography.',
      friends: [],
      receivedRequests: [],
      sentRequests: []);
}
