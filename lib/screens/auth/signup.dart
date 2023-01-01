import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/components/button.dart';
import 'package:tomodachi/components/field/date_picker.dart';
import 'package:tomodachi/components/field/email_field.dart';
import 'package:tomodachi/components/field/password_field.dart';
import 'package:tomodachi/components/field/text_field.dart';
import 'package:tomodachi/components/loading.dart';
import 'package:tomodachi/components/snackbar.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/screens/auth/login.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/errors.dart';
import 'package:tomodachi/utility/palette.dart';

// ignore: must_be_immutable
class SignupPage extends StatefulWidget {
  SignupPage({super.key});
  String? date;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // * Text Field Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // * Form Key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double dualWidth = 188;
    return Scaffold(
        backgroundColor: Palette.AMBER,
        body: Form(
            key: _formKey,
            child: Stack(children: [
              // Top Blob
              Positioned(child: Image.asset('${IMAGE_FOLDER}blob1.png')),

              // Layout
              ListView(children: [
                // Header
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: Column(children: [
                      Center(
                          child: Text('Signup'.toUpperCase(),
                              style: const TextStyle(
                                  color: Palette.RED,
                                  fontWeight: FontWeight.w700))),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Image.asset(
                            '${IMAGE_FOLDER}signup_icon.png',
                            fit: BoxFit.contain,
                            width: AUTH_ICON_SIZE,
                          ))
                    ])),

                // Text Fields
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: Column(children: [
                      // Personal Information
                      _buildLabel('Personal Information'),

                      // First & Last Names
                      Row(children: [
                        InputField(
                            controller: _firstNameController,
                            hint: 'First Name',
                            width: dualWidth),
                        const Spacer(),
                        InputField(
                            controller: _lastNameController,
                            hint: 'Last Name',
                            width: dualWidth)
                      ]),

                      // Birthdate
                      DatePicker(
                          hint: 'Birthdate',
                          controller: _birthdateController,
                          startDate: DateTime(1900),
                          endDate: DateTime.now(),
                          onchange: (value) {
                            setState(() {
                              widget.date = value;
                            });
                          }),

                      // Location
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Input Field
                            InputField(
                                controller: _locationController,
                                hint: 'Location',
                                disabled: true,
                                width: 320),

                            // Location Picker
                            IconButton(
                                icon: const Icon(Icons.search_rounded,
                                    color: Palette.ORANGE, size: 32),
                                onPressed: () {
                                  showCountryPicker(
                                    context: context,
                                    onSelect: (Country country) {
                                      // Set the text field's label to the
                                      // selected country.
                                      _locationController.text =
                                          country.displayNameNoCountryCode;
                                    },
                                    countryListTheme:
                                        const CountryListThemeData(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8),
                                      ),
                                      inputDecoration: InputDecoration(
                                        labelText: 'Search',
                                        hintText: 'Search Country',
                                        prefixIcon: Icon(Icons.search),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Palette.GREY,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                })
                          ]),

                      // Account Information
                      _buildLabel('Account Information', topMargin: 40),

                      // Username
                      InputField(
                          controller: _usernameController, hint: 'Username'),

                      // Email Address
                      EmailField(
                          controller: _emailController, hint: 'Email Address'),

                      // Space Allowance
                      const SizedBox(height: 12),

                      // Password
                      PasswordField(
                          controller: _passwordController,
                          hint: 'Password',
                          onvalidate: (value) {
                            // Check for empty values.
                            if (value == null || value.isEmpty) {
                              return getRequiredError('Password'.toLowerCase());
                            }

                            // Check for password length.
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters.';
                            }

                            // Check for the presence of each character.
                            if (!PASSWORD_REGEXP.hasMatch(value)) {
                              return 'Password must have at least:\n• 1 number \n• 1 special character \n• Both uppercase and lowercase letters';
                            }
                          }),

                      // Confirm Password
                      PasswordField(
                          controller: _confirmPasswordController,
                          hint: 'Confirm Password',
                          onvalidate: (value) {
                            // Check for empty values.
                            if (value == null || value.isEmpty) {
                              return getRequiredError(
                                  'Confirm Password'.toLowerCase());
                            }

                            // Check if password matches.
                            if (_passwordController.text != value) {
                              return 'Passwords do not match.';
                            }
                          }),
                    ])),

                // Buttons
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 28, 0, 80),
                    child: Column(children: [
                      // Signup Button
                      AppButton(
                          context: context,
                          label: 'Signup',
                          onclick: () async {
                            // Validate the form before submitting.
                            if (_formKey.currentState!.validate()) {
                              // Save the state.
                              _formKey.currentState?.save();

                              // Morph the username, first and last name.
                              String username =
                                  _usernameController.text.toLowerCase();

                              String firstName =
                                  _firstNameController.text.toLowerCase();
                              firstName = firstName[0].toUpperCase() +
                                  firstName.substring(1);

                              String lastName =
                                  _lastNameController.text.toLowerCase();
                              lastName = lastName[0].toUpperCase() +
                                  lastName.substring(1);

                              // Sign up in the firebase.
                              showLoader(context); // Display the loader.
                              String res = await context
                                  .read<AuthProvider>()
                                  .signup(
                                      _emailController.text,
                                      _passwordController.text,
                                      username,
                                      firstName,
                                      lastName,
                                      DateTime.parse(_birthdateController.text),
                                      _locationController.text);

                              // Hide the loader after processing.
                              if (!mounted) return;
                              hideLoader(context);
                              Navigator.pop(context);

                              // Display an error message if any.
                              if (res != SUCCESS_MESSAGE) {
                                displayToast(res);
                              }
                            }
                          },
                          isPrimary: true),

                      // Login Button
                      AppButton(
                          context: context,
                          label: 'Login',
                          onclick: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                          }),
                    ])),
              ]),

              // Bottom Blob
              Positioned(
                  right: 0,
                  bottom: 0,
                  child: Image.asset('${IMAGE_FOLDER}blob2.png'))
            ])));
  }

  /// Build a [Text] (Label) for a section of fields
  Padding _buildLabel(String label,
      {double topMargin = 8, double bottomMargin = 8}) {
    return Padding(
        padding: EdgeInsets.fromLTRB(
            HORIZONTAL_MARGIN, topMargin, HORIZONTAL_MARGIN, bottomMargin),
        child: Text(label.toUpperCase(),
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Palette.ORANGE,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8)));
  }
}
