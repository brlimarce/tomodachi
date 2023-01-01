import 'package:flutter/material.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/palette.dart';

class AppButton extends StatelessWidget {
  /// **********************************************
  /// * Properties
  /// **********************************************

  /// Used for getting the [ThemeData], specifically
  /// the typography size.
  final BuildContext context;

  /// Name of the action (must be concise).
  final String label;

  /// The handler is of type [void], which cannot
  /// take any arguments.
  final Function() onclick;

  /// Indicates if a primary style should be used.
  /// Flag is `false` by default.
  bool? isPrimary;

  /// May specify a different `primary` color.
  Color? color;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  AppButton(
      {super.key,
      required this.context,
      required this.label,
      required this.onclick,
      this.isPrimary,
      this.color});

  @override
  Widget build(BuildContext context) {
    // * Declaration
    bool flag = isPrimary ?? false;
    Color primary = color ?? Palette.ORANGE;

    return Padding(
        padding: const EdgeInsets.fromLTRB(
            HORIZONTAL_MARGIN, 8, HORIZONTAL_MARGIN, 0),
        child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: onclick,
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: flag ? primary : Colors.transparent,
                    side: flag ? null : BorderSide(width: 1, color: primary)),
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(label.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: flag ? Palette.WHITE : primary))))));
  }
}
