import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/palette.dart';

/// Display a simple notification to let the
/// user know about any updates.
notify(String type, String message, {String? customTitle}) {
  // Set up the properties.
  late String title;
  late Color background;
  late Color foreground;

  switch (type) {
    case ERROR_SNACK:
      title = customTitle ?? 'Error!';
      background = const Color.fromARGB(255, 254, 226, 226);
      foreground = Palette.RED;
      break;
    case SUCCESS_SNACK:
      title = customTitle ?? 'Success!';
      background = const Color.fromARGB(255, 236, 252, 203);
      foreground = Colors.green;
      break;
    default:
      break;
  }

  // Pop the notification up.
  BotToast.showSimpleNotification(
      title: title,
      subTitle: message,
      align: const Alignment(0, -0.92),
      duration: const Duration(seconds: 2),
      backgroundColor: background,
      titleStyle: TextStyle(color: foreground, fontWeight: FontWeight.w700),
      subTitleStyle: TextStyle(color: foreground));
}

/// Display a regular toast for other pages.
displayToast(String message) {
  BotToast.showText(text: message, duration: const Duration(seconds: 2));
}
