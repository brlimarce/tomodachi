import 'package:flutter/material.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/palette.dart';

class IconLabel extends StatelessWidget {
  /// **********************************************
  /// * Properties
  /// **********************************************

  /// The caption to be placed in
  /// the label.
  final String title;

  /// An icon that describes a
  /// certain label.
  final IconData icon;

  /// Size for both the icon
  /// and label.
  double? size = 16;

  /// Colors for the label and icon
  /// are separated and specific.
  Color? color;
  Color? iconColor;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  IconLabel(
      {super.key,
      required this.title,
      required this.icon,
      this.size,
      this.color,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(icon, size: size, color: iconColor ?? color ?? Palette.WHITE),
        Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: Text(title,
                style: TextStyle(
                    fontSize: size,
                    color: color ?? Palette.WHITE,
                    fontWeight: FontWeight.w700)))
      ],
    );
  }
}
