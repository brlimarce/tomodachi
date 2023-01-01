import 'package:flutter/material.dart';
import 'package:tomodachi/components/common/app_bar.dart';
import 'package:tomodachi/components/common/navbar.dart';
import 'package:tomodachi/screens/common/screen_args.dart';
import 'package:tomodachi/screens/task/task_modal.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/palette.dart';

// ignore: must_be_immutable
class RouterPage extends StatelessWidget {
  /// **********************************************
  /// * Properties
  /// **********************************************
  ScreenArgs args;
  bool? overflow = false;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  RouterPage({super.key, required this.args, this.overflow});

  @override
  Widget build(BuildContext context) {
    overflow = overflow ?? false;
    return Scaffold(
      // Primary Color
      backgroundColor: Palette.AMBER,

      // App Bar
      appBar: buildAppBar(context, args.title ?? args.name, args.icon),

      // Widget to be rendered
      body: Padding(
          padding: overflow!
              ? const EdgeInsets.all(0)
              : const EdgeInsets.symmetric(
                  vertical: 28, horizontal: HORIZONTAL_MARGIN),
          child: args.child),

      // FAB for Add Task
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    TaskModal(action: ADD_TASK, isOwner: true));
          },
          backgroundColor: Palette.ORANGE,
          child: const Icon(Icons.add, color: Palette.WHITE)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Navigation Bar
      bottomNavigationBar: Navbar(index: args.index, items: PAGES),
    );
  }
}
