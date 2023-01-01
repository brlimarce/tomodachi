import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tomodachi/api/auth_api.dart';
import 'package:tomodachi/api/user_api.dart';
import 'package:tomodachi/models/user_model.dart' as tomodachi;

class AuthProvider with ChangeNotifier {
  late AuthAPI service;
  User? loggedUser;

  /// Indicates the authentication state
  /// of the application.
  User? get user => loggedUser;
  bool get isAuthenticated {
    return user != null;
  }

  /// Store the data of the logged user (owner).
  tomodachi.User? selectedUser;
  tomodachi.User get userdata => selectedUser!;

  /// **********************************************
  /// * Constructor
  /// **********************************************

  AuthProvider() {
    service = AuthAPI();
    service.getUser().listen((User? newUser) async {
      // Store Firebase-related data.
      loggedUser = newUser;

      // Store data from the database.
      if (isAuthenticated) {
        // Get the data of the user.
        UserAPI userService = UserAPI();
        DocumentSnapshot snapshot =
            await userService.getUserDocument(loggedUser!.uid);
        selectedUser =
            tomodachi.User.fromJson(snapshot.data() as Map<String, dynamic>);
      }

      // Notify the listeners.
      notifyListeners();
    }, onError: (e) {});
  }

  /// Sign in the application via Firebase.
  Future<String> login(String email, String password) async {
    return await service.login(email, password);
  }

  /// Sign out of the application.
  logout() {
    service.logout();
    notifyListeners();
  }

  /// Sign up in the application with the provided data.
  Future<String> signup(
      String email,
      String password,
      String username,
      String firstName,
      String lastName,
      DateTime birthdate,
      String country) async {
    return await service.signup(
        email, password, username, firstName, lastName, birthdate, country);
  }
}
