import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/components/button.dart';
import 'package:tomodachi/components/field/email_field.dart';
import 'package:tomodachi/components/field/password_field.dart';
import 'package:tomodachi/components/loading.dart';
import 'package:tomodachi/components/snackbar.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/screens/auth/signup.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/errors.dart';
import 'package:tomodachi/utility/palette.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // * Text Field Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // * Form Key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                          child: Text('Login'.toUpperCase(),
                              style: const TextStyle(
                                  color: Palette.RED,
                                  fontWeight: FontWeight.w700))),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: Image.asset(
                            '${IMAGE_FOLDER}login_icon.png',
                            fit: BoxFit.contain,
                            width: AUTH_ICON_SIZE,
                          ))
                    ])),

                // Text Fields
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: Column(children: [
                      EmailField(
                          controller: _emailController, hint: 'Email Address'),
                      PasswordField(
                          controller: _passwordController,
                          hint: 'Password',
                          onvalidate: (value) {
                            if (value == null || value.isEmpty) {
                              return getRequiredError('Password'.toLowerCase());
                            }
                          }),
                    ])),

                // Buttons
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 28, 0, 0),
                    child: Column(children: [
                      // Login Button
                      AppButton(
                          context: context,
                          label: 'Login',
                          onclick: () async {
                            // Validate the form before submitting.
                            if (_formKey.currentState!.validate()) {
                              // Save the state.
                              _formKey.currentState?.save();

                              // Sign in the application.
                              showLoader(context);
                              String res = await context
                                  .read<AuthProvider>()
                                  .login(_emailController.text,
                                      _passwordController.text);
                              if (!mounted) return;
                              hideLoader(context);

                              // Display an error message if any.
                              if (res != SUCCESS_MESSAGE) {
                                displayToast(res);
                              }
                            }
                          },
                          isPrimary: true),

                      // Signup Button
                      AppButton(
                          context: context,
                          label: 'Signup',
                          onclick: () async {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SignupPage()));
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
}
