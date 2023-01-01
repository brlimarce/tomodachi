import 'package:flutter_test/flutter_test.dart';
import 'package:tomodachi/api/auth_api.dart';
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
  group('Auth API', () {
    /// Store an instance of the service.
    AuthAPI service = AuthAPI();

    /// **********************************************
    /// * Test Cases
    /// **********************************************
    test('Log in the application.', () async {
      String res = await service.login(MockData.email, MockData.password);
      expect(res, SUCCESS_MESSAGE);
    });

    test('Log out of the application.', () async {
      String res = await service.login(MockData.email, MockData.password);

      // Response should be a success message,
      // and the logout function should not
      // throw an exception
      expect(res, SUCCESS_MESSAGE);
      expect(service.logout, returnsNormally);
    });

    test('Sign up in the application.', () async {
      User user = MockData.owner;
      String res = await service.signup(
          MockData.email,
          MockData.password,
          user.username,
          user.firstName,
          user.lastName,
          user.birthdate.toDate(),
          user.country);
      
      // Response should be a success message.
      expect(res, SUCCESS_MESSAGE);
    });

    test('Save the user\'s data in Firebase.', () async {
      User user = MockData.owner;
      String res = await service.signup(
          MockData.email,
          MockData.password,
          user.username,
          user.firstName,
          user.lastName,
          user.birthdate.toDate(),
          user.country);
      
      // Response should be a success message.
      expect(res, SUCCESS_MESSAGE);
    });
  });
}
