import 'package:flutter/material.dart';

class ScreenArgs {
  /// **********************************************
  /// * Properties
  /// **********************************************

  /// Name of the page that will reflect in
  /// the app and nav bar.
  String name;

  /// Name of the page that can reflect
  /// in the nav bar.
  String? title;

  /// An icon that represents the page.
  IconData icon;

  /// The page to be selected in the nav bar.
  int index;

  /// The widget to be displayed in the container.
  Widget child;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  ScreenArgs(this.name, this.icon, this.index, this.child, {this.title});
}
