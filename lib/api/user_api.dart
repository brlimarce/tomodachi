import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomodachi/utility/constants.dart';

// ignore: unused_import
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

// ignore: unused_import
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// ignore: unused_import
import 'package:tomodachi/utility/mock_data.dart';

class UserAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  /// **********************************************
  /// * Mock Data
  /// * ! Uncomment to try out the widget test.
  /// **********************************************
  // static final db = FakeFirebaseFirestore();
  // static final auth = MockData.auth;

  /// Get a [Stream] of [DocumentSnapshot] of a
  /// specific [User] based on [User.uid].
  Stream<DocumentSnapshot> getUserStream(String id) {
    return db.collection(USER_COLLECTION).doc(id).snapshots();
  }

  /// Returns a [DocumentSnapshot] of a specific [User]
  /// based on [User.uid].
  ///
  /// * Note: This is used to fetch a user's data
  /// * after processing.
  Future<DocumentSnapshot> getUserDocument(String id) {
    return db.collection(USER_COLLECTION).doc(id).get();
  }

  /// Returns a [Stream] of [User] (MUTUAL) that is in
  /// the OWNER's friend requests.
  ///
  /// * Specify the field (must be of List<dynamic>) you
  /// * want to retrieve from the owner.
  Stream<QuerySnapshot> getFriendStream(String id, String field) {
    return db
        .collection(USER_COLLECTION)
        .where(field, arrayContains: id)
        .snapshots();
  }

  /// Get a [Stream] of [User] in Firebase based
  /// on a search string.
  Stream<QuerySnapshot> getSearchStream(String search) {
    const field = 'username';
    return db
        .collection(USER_COLLECTION)
        .where(field, isGreaterThanOrEqualTo: search)
        .where(field, isLessThanOrEqualTo: search + '\uf8ff')
        .snapshots();
  }

  /// Edit the [biography] of a [User].
  Future<String> editBio(String id, String biography) async {
    try {
      await db
          .collection(USER_COLLECTION)
          .doc(id)
          .update({'biography': biography});
      return SUCCESS_MESSAGE;
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  /// Update [User.receivedRequests] in Firebase.
  Future<String> updateReceivedRequests(
      String? id, List<dynamic> requests) async {
    try {
      await db
          .collection(USER_COLLECTION)
          .doc(id)
          .update({'receivedRequests': requests});
      return SUCCESS_MESSAGE;
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  /// Update [User.sentRequests] in Firebase.
  Future<String> updateSentRequests(String? id, List<dynamic> requests) async {
    try {
      await db
          .collection(USER_COLLECTION)
          .doc(id)
          .update({'sentRequests': requests});
      return SUCCESS_MESSAGE;
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }

  /// Update [User.friends] in Firebase.
  Future<String> updateFriends(String? id, List<dynamic> friends) async {
    try {
      await db.collection(USER_COLLECTION).doc(id).update({'friends': friends});
      return SUCCESS_MESSAGE;
    } on FirebaseException catch (e) {
      return e.toString();
    }
  }
}
