import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomodachi/models/user_model.dart';
import 'package:tomodachi/utility/mock_data.dart';

/// To run this test, disable the configurations
/// of the REAL firebase.
///
/// 1. Comment out Lines 33-35 of `main.dart`.
/// 2. For API classes, comment out the real Firebase
/// instantiation and uncomment its mock counterparts.
///
void main() {
  group('User Model', () {
    test('A User instance should be created.', () {
      Timestamp timestamp = Timestamp.fromDate(DateTime.now());
      final instance = User(
          id: 'some_uid',
          username: 'some_username',
          email: 'some_email',
          firstName: 'Jane',
          lastName: 'Doe',
          birthdate: timestamp,
          country: 'Philippines',
          biography: 'This is Jane\'s biography.',
          friends: [],
          receivedRequests: [],
          sentRequests: []);

      // Check if the data matches with the instance.
      expect(instance.id, 'some_uid');
      expect(instance.username, 'some_username');
      expect(instance.email, 'some_email');
      expect(instance.firstName, 'Jane');
      expect(instance.lastName, 'Doe');
      expect(instance.birthdate, timestamp);
      expect(instance.country, 'Philippines');
      expect(instance.biography, 'This is Jane\'s biography.');
      expect(instance.friends, []);
      expect(instance.receivedRequests, []);
      expect(instance.sentRequests, []);
    });

    test('A User should be converted into JSON.', () {
      final user = MockData.owner;
      final converted = user.toJson(user);

      // Check if the converted data matches
      // those of the Task instance.
      expect(converted, {
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'birthdate': user.birthdate,
        'country': user.country,
        'biography': user.biography,
        'friends': user.friends,
        'receivedRequests': user.receivedRequests,
        'sentRequests': user.sentRequests
      });
    });
  });
}