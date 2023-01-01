import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/palette.dart';
import 'package:tomodachi/utility/errors.dart';

class DatePicker extends StatelessWidget {
  /// **********************************************
  /// * Properties
  /// **********************************************
  final TextEditingController controller;

  /// Resembles the `hint text` of the text field.
  final String hint;

  /// The handler is of type [String], which cannot
  /// take any arguments.
  final Function(String) onchange;

  /// The default width is `full width`.
  double? width;

  /// Represents the top and horizontal margins.
  double? topMargin;
  double? horizMargin;

  /// Set the boundaries for the date picker.
  DateTime startDate;
  DateTime endDate;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  DatePicker(
      {super.key,
      required this.controller,
      required this.hint,
      required this.onchange,
      required this.startDate,
      required this.endDate,
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
            child: DateTimePicker(
              controller: controller,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: hint,
                  prefixIcon: const Icon(Icons.calendar_month_rounded,
                      color: Palette.GREY)),
              style: Theme.of(context).textTheme.bodyText2,
              firstDate: startDate,
              lastDate: endDate,
              dateLabelText: 'Date',
              onChanged: onchange,
              validator: (value) {
                // Check if the value is empty.
                if ((value == null) || (value == 'null') || value.isEmpty) {
                  return getRequiredError(hint.toLowerCase());
                }
              },
            )));
  }
}
