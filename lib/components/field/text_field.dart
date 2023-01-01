import 'package:flutter/material.dart';
import 'package:tomodachi/components/field/field.dart';
import 'package:tomodachi/utility/errors.dart';

class InputField extends StatelessWidget {
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

  /// Disable property for special fields.
  bool? disabled;

  /// Indicates if the text field is multiline.
  bool? multiline;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  InputField(
      {super.key,
      required this.controller,
      required this.hint,
      this.disabled,
      this.multiline,
      this.width,
      this.topMargin,
      this.horizMargin});

  @override
  Widget build(BuildContext context) {
    return Field(
        controller: controller,
        hint: hint,
        disabled: disabled,
        multiline: multiline,
        width: width,
        topMargin: topMargin,
        horizMargin: horizMargin,
        onvalidate: (value) {
          if (value == null || value.isEmpty) {
            return getRequiredError(hint.toLowerCase());
          }
        });
  }
}
