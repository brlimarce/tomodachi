import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:tomodachi/components/field/field.dart';
import 'package:tomodachi/utility/errors.dart';

class EmailField extends StatelessWidget {
  /// **********************************************
  /// * Properties
  /// **********************************************
  final TextEditingController controller;

  /// Resembles the `hint text` of the text field.
  final String hint;

  /// The default width is `full width`.
  double? width;

  /// Represents the top and horizontal margins.
  double? topMargin;
  double? horizMargin;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  EmailField(
      {super.key,
      required this.controller,
      required this.hint,
      this.width,
      this.topMargin,
      this.horizMargin});

  @override
  Widget build(BuildContext context) {
    return Field(
        controller: controller,
        hint: hint,
        width: width,
        topMargin: topMargin,
        horizMargin: horizMargin,
        onvalidate: (value) {
          // Check for empty values.
          if (value == null || value.isEmpty) {
            return getRequiredError(hint.toLowerCase());
          }

          // Check for invalid email addresses.
          if (!EmailValidator.validate(value)) {
            return InvalidEmailError;
          }
        });
  }
}
