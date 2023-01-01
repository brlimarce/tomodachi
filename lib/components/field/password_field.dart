import 'package:flutter/material.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/palette.dart';

class PasswordField extends StatefulWidget {
  @override
  State<PasswordField> createState() => _PasswordFieldState();

  /// **********************************************
  /// * Properties
  /// **********************************************
  final TextEditingController controller;

  /// Resembles the `hint text` of the field.
  final String hint;

  /// The default width is `full width`.
  double? width;

  /// Represents the top and horizontal margins.
  double? topMargin;
  double? horizMargin;

  /// Provides a custom validation for
  /// checking user input.
  String? Function(String?) onvalidate;

  /// Flag to check if password should be
  /// obscure or not.
  bool _isObscure = true;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  PasswordField(
      {super.key,
      required this.controller,
      required this.hint,
      required this.onvalidate,
      this.width,
      this.topMargin,
      this.horizMargin});
}

class _PasswordFieldState extends State<PasswordField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width ?? double.infinity,
        child: Padding(
            padding: EdgeInsets.fromLTRB(
                widget.horizMargin ?? HORIZONTAL_MARGIN,
                widget.topMargin ?? 16,
                widget.horizMargin ?? HORIZONTAL_MARGIN,
                0),
            child: TextFormField(
                controller: widget.controller,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: widget.hint,

                    // Icon (To toggle text visibility)
                    suffixIcon: IconButton(
                        onPressed: () {
                          // Toggle the visibility.
                          setState(() {
                            widget._isObscure = !widget._isObscure;
                          });
                        },
                        icon: Icon(
                            widget._isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: widget._isObscure
                                ? Palette.ORANGE
                                : Palette.GREY))),
                style: Theme.of(context).textTheme.bodyText2,

                // Checks if password should be visible or not.
                obscureText: widget._isObscure,
                validator: widget.onvalidate)));
  }
}
