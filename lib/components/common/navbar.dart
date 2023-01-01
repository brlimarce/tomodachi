import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/screens/index.dart';

// ignore: must_be_immutable
class Navbar extends StatelessWidget {
  /// **********************************************
  /// * Properties
  /// **********************************************

  /// Contains the information needed
  /// for each page.
  ///
  /// * title: Name of the page
  /// * color: Color upon selection
  /// * icon: Describes the page in the navbar.
  List<Map<String, dynamic>> items;

  /// The selected page in the navbar.
  int index;

  /// **********************************************
  /// * Constructor
  /// **********************************************
  Navbar({super.key, required this.items, required this.index});

  @override
  Widget build(BuildContext context) {
    return StylishBottomBar(
      items: _buildItems(items),
      iconSize: 32,
      barAnimation: BarAnimation.fade,
      hasNotch: true,
      fabLocation: StylishBarFabLocation.center,
      opacity: 0.3,
      currentIndex: index,
      onTap: (index) {
        late Widget page;
        String uid = context.read<AuthProvider>().loggedUser!.uid;

        switch (index) {
          // * Tasks
          case 0:
            page = buildTaskPage(uid);
            break;
          // * Profile
          case 1:
            page = buildProfile(uid);
            break;
          // * Friend Requests
          case 2:
            page = buildRequests();
            break;
          // * Search
          case 3:
            page = buildSearchPage();
            break;
        }

        // Navigate to the selected page.
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }

  /// Build a List of [AnimatedBarItems] containing
  /// the page's information.
  List<AnimatedBarItems> _buildItems(List<Map<String, dynamic>> items) {
    List<AnimatedBarItems> bubbleItems = [];
    for (var element in items) {
      bubbleItems.add(AnimatedBarItems(
          icon: Icon(element['icon'], size: 28),
          selectedColor: element['color'],
          title: Text(element['title'],
              style: const TextStyle(fontWeight: FontWeight.w700))));
    }

    return bubbleItems;
  }
}
