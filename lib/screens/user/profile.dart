import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/components/button.dart';
import 'package:tomodachi/components/icon_label.dart';
import 'package:tomodachi/models/user_model.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/providers/user_provider.dart';
import 'package:tomodachi/screens/index.dart';
import 'package:tomodachi/screens/user/bio_modal.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/helper.dart';
import 'package:tomodachi/utility/palette.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
  final String uid;
}

class _ProfilePageState extends State<ProfilePage> {
  // Margins
  double vertMargin = 32;
  double horizMargin = 40;

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> stream =
        context.watch<UserProvider>().getUserStream(widget.uid);
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return displayStreamError(snapshot);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return displaySmallLoader();
          } else if (!snapshot.hasData) {
            return displayNoStream(snapshot);
          }

          User user =
              User.fromJson(snapshot.data?.data() as Map<String, dynamic>);
          User owner = context.read<AuthProvider>().selectedUser!;

          // Get the states for the toolbar.
          bool isFriend =
              owner.friends.contains(user.id) || owner.id == user.id;
          bool isReceived = owner.receivedRequests.contains(user.id);
          bool isSent = owner.sentRequests.contains(user.id);

          return ListView(children: [
            // Introduction Section
            Stack(
              children: [
                Image.asset('${IMAGE_FOLDER}background.png',
                    fit: BoxFit.cover, width: 400),
                Center(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Positioned(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              // Avatar
                              const CircleAvatar(
                                radius: 48,
                                backgroundColor: Palette.WHITE,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage('${IMAGE_FOLDER}cat.png'),
                                  radius: 44,
                                ),
                              ),

                              // Header
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 2),
                                  child: Text(
                                      '${user.firstName} ${user.lastName}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6!
                                          .copyWith(
                                              color: Palette.WHITE,
                                              fontWeight: FontWeight.w700))),

                              // Location
                              IconLabel(
                                  title: user.country,
                                  icon: Icons.location_pin),

                              // Buttons
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      horizMargin, 20, horizMargin, 0),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: _buildToolbar(user,
                                          isFriend: isFriend,
                                          isReceived: isReceived,
                                          isSent: isSent)))
                            ]))))
              ],
            ),

            // ID (Username) and Birthdate
            Padding(
                padding: EdgeInsets.fromLTRB(
                    horizMargin, vertMargin, horizMargin, vertMargin / 2),
                child: Column(children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 144, child: _buildLabel('ID', user.id!)),
                    const Spacer(),
                    SizedBox(
                        width: 136,
                        child: _buildLabel(
                            'Birthdate', formatDate(user.birthdate)))
                  ]),
                ])),

            // Biography
            Padding(
                padding: EdgeInsets.fromLTRB(horizMargin, 20, horizMargin, 0),
                child: _buildLabel(
                    'Biography',
                    user.biography == ''
                        ? 'No biography available.'
                        : user.biography,
                    foreground:
                        user.biography == '' ? Palette.GREY : Palette.BLACK)),

            // Action (Edit Biography)
            Padding(
                padding: const EdgeInsets.fromLTRB(
                    HORIZONTAL_MARGIN, 12, HORIZONTAL_MARGIN, 0),
                child: widget.uid ==
                        context.read<AuthProvider>().loggedUser!.uid
                    ? AppButton(
                        context: context,
                        label: 'Edit Biography',
                        onclick: () {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  BiographyModal(biography: user.biography));
                        })
                    : const SizedBox())
          ]);
        });
  }

  /// Build a label based on [Column] with an [Expanded] container.
  Expanded _buildLabel(String field, String data,
      {Color foreground = Palette.BLACK}) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Name
        Text(field,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: Palette.ORANGE, fontWeight: FontWeight.w700)),
        // Data
        Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Text(data,
                textAlign: TextAlign.justify,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2!
                    .copyWith(color: foreground, fontWeight: FontWeight.w500)))
      ],
    ));
  }

  /// Build a white [Button] that indicates an
  /// action for the profile.
  ElevatedButton _buildButton(
      String label, Function() clickHandler, IconData icon,
      {Color color = Palette.ORANGE}) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0, backgroundColor: Palette.WHITE),
        onPressed: clickHandler,
        child: IconLabel(icon: icon, title: label, color: color));
  }

  /// Build a [Button] toolbar for the profile.
  List<Widget> _buildToolbar(User user,
      {bool isFriend = false, bool isReceived = false, bool isSent = false}) {
    List<Widget> toolbar = [];
    SizedBox space = const SizedBox(width: 8);

    // Add to view the tasks.
    if (isFriend) {
      toolbar.add(_buildButton('View Tasks', () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => buildTaskPage(widget.uid)));
      }, Icons.add_task, color: Colors.green));
      toolbar.add(space);
    }

    // Add to view the user's friends.
    toolbar.add(_buildButton('View Friends', () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => buildFriends(user)));
    }, Icons.favorite, color: Colors.pink));

    // Add to let the user know that they received/sent
    // a friend request.
    if (isReceived || isSent) {
      toolbar.add(space);
      toolbar.add(_buildButton(
          'FR ${isReceived ? 'Received' : 'Sent'}', () {}, Icons.person_add,
          color: Palette.GREY));
    }

    return toolbar;
  }
}
