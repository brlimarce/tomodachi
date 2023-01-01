import 'package:flutter/material.dart';
import 'package:tomodachi/utility/constants.dart';

class Field extends StatelessWidget {
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

  /// Provides a custom validation for
  /// checking user input.
  String? Function(String?) onvalidate;

  /// Indicates if the text field is multiline.
  bool? multiline;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  Field(
      {super.key,
      required this.controller,
      required this.hint,
      required this.onvalidate,
      this.disabled,
      this.multiline,
      this.width,
      this.topMargin,
      this.horizMargin});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width ?? double.infinity,
        child: Padding(
            padding: EdgeInsets.fromLTRB(horizMargin ?? HORIZONTAL_MARGIN,
                topMargin ?? 16, horizMargin ?? HORIZONTAL_MARGIN, 0),
            child: TextFormField(
                controller: controller,
                minLines: multiline != null ? 6 : 1,
                maxLines: multiline != null ? 6 : 1,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(), hintText: hint),
                readOnly: disabled ?? false,
                style: Theme.of(context).textTheme.bodyText2,
                validator: onvalidate)));
  }
}
