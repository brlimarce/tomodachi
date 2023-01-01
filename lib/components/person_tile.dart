import 'package:flutter/material.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/palette.dart';

class PersonTile extends StatelessWidget {
  /// **********************************************
  /// * Properties
  /// **********************************************

  /// Display name of the user.
  final String firstName;

  /// Identifier of the user.
  final String username;

  /// First action to be placed on
  /// the left side.
  final IconButton leftButton;

  /// Second action to be placed on
  /// the right side.
  final IconButton rightButton;

  /// **********************************************
  /// * Constructor
  /// **********************************************

  PersonTile(
      {super.key,
      required this.firstName,
      required this.username,
      required this.leftButton,
      required this.rightButton});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                        backgroundColor: Palette.ORANGE_SWATCH[200],
                        child: Text(firstName[0],
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    color: Palette.ORANGE,
                                    fontWeight: FontWeight.w700))),

                    Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // First & Last Name
                              Text(firstName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Palette.ORANGE)),
                              // Username
                              Text('@${username}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: Palette.GREY))
                            ]))
                  ],
                ),

                // Toolbar
                Row(
                  children: [leftButton, rightButton],
                ),
              ],
            )));
  }
}
