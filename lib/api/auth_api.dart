import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/errors.dart';

// ignore: unused_import
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

// ignore: unused_import
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

// ignore: unused_import
import 'package:tomodachi/utility/mock_data.dart';

class AuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  /// **********************************************
  /// * Mock Data
  /// * ! Uncomment to try out the widget test.
  /// **********************************************
  // static final db = FakeFirebaseFirestore();
  // static final auth = MockData.auth;

  /// Get the [User] (logged in) from Firebase.
  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  /// Sign in the application through [email] and [password].
  Future<String> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return SUCCESS_MESSAGE;
    } on FirebaseAuthException catch (e) {
      // The account does not exist.
      if (e.code == USER_NOT_FOUND_CODE) {
        return UserNotFoundError;
      }

      //  The password is incorrect.
      else if (e.code == WRONG_PASSWORD_CODE) {
        return WrongPasswordError;
      }
    }

    return GenericError;
  }

  /// Sign out of the application.
  void logout() async {
    auth.signOut();
  }

  /// Sign up in the application with the
  /// provided data.
  Future<String> signup(
      String email,
      String password,
      String username,
      String firstName,
      String lastName,
      DateTime birthdate,
      String country) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Check if the user was created.
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email, username, firstName,
            lastName, birthdate, country);
      }

      return SUCCESS_MESSAGE;
    } on FirebaseAuthException catch (e) {
      // The password is weak.
      if (e.code == WEAK_PASSWORD_CODE) {
        return WeakPasswordError;
      }

      // The account already exists.
      else if (e.code == EMAIL_IN_USE_CODE) {
        return UserExistsError;
      }
    } on Exception catch (e) {
      return e.toString();
    }

    return GenericError;
  }

  /// Save [User] in Firestore (database).
  Future<String> saveUserToFirestore(
      String? uid,
      String email,
      String username,
      String firstName,
      String lastName,
      DateTime birthdate,
      String country) async {
    try {
      await db.collection(USER_COLLECTION).doc(uid).set({
        'id': uid,
        'username': username,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'birthdate': birthdate,
        'country': country,
        'biography': '',
        'friends': [],
        'receivedRequests': [],
        'sentRequests': []
      });

      return SUCCESS_MESSAGE;
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }
}
