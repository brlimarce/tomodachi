import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomodachi/api/user_api.dart';
import 'package:tomodachi/models/user_model.dart';
import 'package:tomodachi/providers/user_provider.dart';
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
  group('User Provider', () {
    final db = UserAPI.db;
    UserProvider provider = UserProvider();

    /// Mock Data
    User owner = MockData.owner;
    User mutual = MockData.mutual;

    String dummyId = owner.id!;
    Map<String, dynamic> data = {
      'id': owner.id,
      'username': owner.username,
      'email': owner.email,
      'firstName': owner.firstName,
      'lastName': owner.lastName,
      'birthdate': owner.birthdate,
      'country': owner.country,
      'biography': owner.biography,
      'friends': owner.friends,
      'receivedRequests': owner.receivedRequests,
      'sentRequests': owner.sentRequests
    };

    /// A helper function to add the user's
    /// data in the database.
    Future<void> addUser() async {
      await db.collection(USER_COLLECTION).doc(dummyId).set({
        'id': dummyId,
        'username': owner.username,
        'email': owner.email,
        'firstName': owner.firstName,
        'lastName': owner.lastName,
        'birthdate': owner.birthdate,
        'country': owner.country,
        'biography': owner.biography,
        'friends': owner.friends,
        'receivedRequests': owner.receivedRequests,
        'sentRequests': owner.sentRequests
      });

      // Add the mutual user.
      await db.collection(USER_COLLECTION).doc(mutual.id).set({
        'id': mutual.id,
        'username': mutual.username,
        'email': mutual.email,
        'firstName': mutual.firstName,
        'lastName': mutual.lastName,
        'birthdate': mutual.birthdate,
        'country': mutual.country,
        'biography': mutual.biography,
        'friends': mutual.friends,
        'receivedRequests': mutual.receivedRequests,
        'sentRequests': mutual.sentRequests
      });
    }

    /// **********************************************
    /// * Test Cases
    /// **********************************************
    test('Get a stream of a specific user.', () async {
      await db.collection(USER_COLLECTION).add(data);

      Stream<DocumentSnapshot> stream = provider.getUserStream(owner.id!);
      expect(stream.isEmpty, completion(equals(false)));
    });

    test('Get an empty friend stream.', () async {
      Stream<QuerySnapshot> stream = provider.getFriends(owner.id!);

      // The stream should not be able to loop through
      // since the owner does not have friends.
      stream.forEach((element) {
        expect(element.docs.isEmpty, true);
      });
    });

    test('Get an empty stream of friend requests.', () async {
      Stream<QuerySnapshot> stream = provider.getRequests(owner.id!);

      // The stream should not be able to loop through
      // since the owner did not receive friend requests.
      stream.forEach((element) {
        expect(element.docs.isEmpty, true);
      });
    });

    test('Get a non-empty search stream.', () async {
      Stream<QuerySnapshot> stream = provider.searchUsers(owner.username);

      // The stream should not be able to loop through
      // since there were no users that matched the search string.
      stream.forEach((element) {
        expect(element.docs.isEmpty, false);
      });
    });

    test('User should be able to edit their biography.', () async {
      await addUser();
      String res =
          await provider.editBiography(dummyId, 'I changed my biography.');
      expect(res, SUCCESS_MESSAGE);
    });

    test('Owner should send a request to mutual.', () async {
      await addUser();
      String res = await provider.addRequest(owner, mutual);
      expect(res, SUCCESS_MESSAGE);
    });

    test('Remove friend requests from both owner and mutual', () async {
      // Send a friend request.
      await addUser();
      String res = await provider.addRequest(owner, mutual);
      expect(res, SUCCESS_MESSAGE);

      // Then, try to remove those requests.
      res = await provider.removeRequest(owner, mutual);
      expect(res, SUCCESS_MESSAGE);
    });

    test('Owner and mutual should be friends.', () async {
      await addUser();
      String res = await provider.addFriend(owner, mutual);
      expect(res, SUCCESS_MESSAGE);
    });

    test('Owner and mutual should no longer be friends.', () async {
      await addUser();
      String res = await provider.removeFriend(owner, mutual);
      expect(res, SUCCESS_MESSAGE);
    });
  });
}
