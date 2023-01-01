import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tomodachi/api/user_api.dart';
import 'package:tomodachi/models/user_model.dart';
import 'package:tomodachi/utility/constants.dart';

class UserProvider with ChangeNotifier {
  late UserAPI service;

  /// **********************************************
  /// * Constructor
  /// **********************************************

  UserProvider() {
    service = UserAPI();
  }

  /// Get a [Stream] of [DocumentSnapshot] of a
  /// specific [User] based on [User.uid].
  ///
  /// * Note: This is used for the profile to
  /// * update the information.
  Stream<DocumentSnapshot> getUserStream(String id) {
    return service.getUserStream(id);
  }

  /// Returns a [Stream] of [User] (MUTUAL) that is in
  /// the OWNER's friend requests.
  Stream<QuerySnapshot> getRequests(String id) {
    return service.getFriendStream(id, 'sentRequests');
  }

  /// Returns a [Stream] of [User] (MUTUAL) that is in
  /// the OWNER's list of friends.
  Stream<QuerySnapshot> getFriends(String id) {
    return service.getFriendStream(id, 'friends');
  }

  /// Fetch a [Stream] of [User] in Firebase
  /// based on the search string.
  Stream<QuerySnapshot> searchUsers(String search) {
    return service.getSearchStream(search);
  }

  /// Edit the [biography] of a [User].
  Future<String> editBiography(String id, String biography) async {
    String res = await service.editBio(id, biography);
    notifyListeners();
    return res;
  }

  /// Add a friend request from OWNER => MUTUAL.
  Future<String> addRequest(User owner, User mutual) async {
    try {
      // Add ID of OWNER into MUTUAL's received FRs.
      mutual.receivedRequests.add(owner.id);
      String res = await service.updateReceivedRequests(
          mutual.id, mutual.receivedRequests);
      if (res != SUCCESS_MESSAGE) {
        throw Exception(res);
      }

      // Add ID of MUTUAL into OWNER's sent FRs.
      owner.sentRequests.add(mutual.id);
      res = await service.updateSentRequests(owner.id, owner.sentRequests);

      notifyListeners();
      return res;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  /// Remove the friend requests from both OWNER and MUTUAL.
  Future<String> removeRequest(User owner, User mutual) async {
    try {
      // Remove ID of MUTUAL in OWNER's received FRs.
      owner.receivedRequests.remove(mutual.id);
      String res = await service.updateReceivedRequests(
          owner.id, owner.receivedRequests);
      if (res != SUCCESS_MESSAGE) {
        throw Exception(res);
      }

      // Remove ID of OWNER in MUTUAL's sent FRs.
      mutual.sentRequests.remove(owner.id);
      res = await service.updateSentRequests(mutual.id, mutual.sentRequests);

      notifyListeners();
      return res;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  /// Let OWNER and MUTUAL add each other as friends.
  Future<String> addFriend(User owner, User mutual) async {
    try {
      // Remove the sent and received requests.
      String res = await removeRequest(owner, mutual);
      if (res != SUCCESS_MESSAGE) {
        throw Exception(res);
      }

      // Add the users as friends.
      owner.friends.add(mutual.id);
      res = await service.updateFriends(owner.id, owner.friends);
      if (res != SUCCESS_MESSAGE) {
        throw Exception(res);
      }

      mutual.friends.add(owner.id);
      res = await service.updateFriends(mutual.id, mutual.friends);

      notifyListeners();
      return res;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  /// Remove OWNER and MUTUAL from each other's
  /// friends list.
  Future<String> removeFriend(User owner, User mutual) async {
    try {
      // Remove OWNER and MUTUAL from friends list.
      owner.friends.remove(mutual.id);
      String res = await service.updateFriends(owner.id, owner.friends);
      if (res != SUCCESS_MESSAGE) {
        throw Exception(res);
      }

      mutual.friends.remove(owner.id);
      res = await service.updateFriends(mutual.id, mutual.friends);
      return res;
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
