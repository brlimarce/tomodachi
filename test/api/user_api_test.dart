import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tomodachi/api/user_api.dart';
import 'package:tomodachi/models/user_model.dart';
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
  group('User API', () {
    /// Store an instance of the service.
    UserAPI service = UserAPI();
    final db = UserAPI.db;

    /// Mock Data
    User owner = MockData.owner;
    String dummyId = '10pe8e2b';
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
    void addUser() async {
      await db.collection(USER_COLLECTION).doc(dummyId).set({
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
    }

    /// **********************************************
    /// * Test Cases
    /// **********************************************
    test('Get a stream of a specific user.', () async {
      await db.collection(USER_COLLECTION).add(data);

      Stream<DocumentSnapshot> stream = service.getUserStream(owner.id!);
      expect(stream.isEmpty, completion(equals(false)));
    });

    test('Get an empty friend stream.', () async {
      Stream<QuerySnapshot> stream =
          service.getFriendStream(owner.id!, 'friends');

      // The stream should not be able to loop through
      // since the owner does not have friends.
      stream.forEach((element) {
        expect(element.docs.isEmpty, true);
      });
    });

    test('Get an empty stream of friend requests.', () async {
      Stream<QuerySnapshot> stream =
          service.getFriendStream(owner.id!, 'receivedRequests');

      // The stream should not be able to loop through
      // since the owner did not receive friend requests.
      stream.forEach((element) {
        expect(element.docs.isEmpty, true);
      });
    });

    test('Get a search stream with no users.', () async {
      Stream<QuerySnapshot> stream = service.getSearchStream('no_match');

      // The stream should not be able to loop through
      // since there were no users that matched the search string.
      stream.forEach((element) {
        expect(element.docs.isEmpty, true);
      });
    });

    test('User should be able to edit their biography.', () async {
      addUser();
      String res = await service.editBio(dummyId, 'Hello world!');
      expect(res, SUCCESS_MESSAGE);
    });

    test('User should receive one friend request.', () async {
      addUser();
      String res = await service.updateReceivedRequests(dummyId, [MockData.mutual.id]);
      expect(res, SUCCESS_MESSAGE);
    });

    test('User should send one friend request.', () async {
      addUser();
      String res = await service.updateReceivedRequests(dummyId, [MockData.mutual.id]);
      expect(res, SUCCESS_MESSAGE);
    });

    test('User should have one friend.', () async {
      addUser();
      String res =
          await service.updateFriends(dummyId, [MockData.mutual.id]);
      expect(res, SUCCESS_MESSAGE);
    });
  });
}
