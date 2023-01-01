import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/components/loading.dart';
import 'package:tomodachi/components/person_tile.dart';
import 'package:tomodachi/components/snackbar.dart';
import 'package:tomodachi/models/user_model.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/providers/user_provider.dart';
import 'package:tomodachi/screens/index.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/helper.dart';
import 'package:tomodachi/utility/palette.dart';

class FriendPage extends StatefulWidget {
  FriendPage({super.key, required this.owner});

  @override
  State<FriendPage> createState() => _FriendPageState();
  final User owner;
}

class _FriendPageState extends State<FriendPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> friendStream =
        context.watch<UserProvider>().getFriends(widget.owner.id!);
    return StreamBuilder(
        stream: friendStream,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return displayStreamError(snapshot);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return displaySmallLoader();
          } else if (!snapshot.hasData) {
            return displayNoStream(snapshot);
          }

          // Create a state for unfriending permissions.
          bool isDisabled =
              context.read<AuthProvider>().loggedUser!.uid == widget.owner.id;

          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                // Get the data in JSON.
                Map<String, dynamic> data =
                    snapshot.data?.docs[index].data() as Map<String, dynamic>;
                User user = User.fromJson(data);

                return PersonTile(
                  firstName: user.firstName,
                  username: user.username,
                  leftButton: IconButton(
                    icon: const Icon(Icons.person),
                    color: Colors.blue,
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => buildProfile(user.id!)));
                    },
                  ),
                  rightButton: IconButton(
                    icon: const Icon(Icons.person_remove_alt_1_rounded),
                    color: isDisabled ? Palette.RED : Colors.transparent,
                    onPressed: () async {
                      if (isDisabled) {
                        // Remove both OWNER and MUTUAL from the friends list.
                        showLoader(context);
                        String res = await context
                            .read<UserProvider>()
                            .removeFriend(widget.owner, user);
                        if (!mounted) return;
                        hideLoader(context);

                        // Reflect on the selected user.
                        context
                            .read<AuthProvider>()
                            .selectedUser!
                            .friends
                            .remove(user.id);

                        // Display an error or success message.
                        if (res != SUCCESS_MESSAGE) {
                          notify(ERROR_SNACK, res);
                        } else {
                          notify(SUCCESS_SNACK,
                              'You\'re no longer friends with ${user.firstName}.');
                        }
                      }
                    },
                  ),
                );
              }));
        }));
  }
}
