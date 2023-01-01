import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/components/loading.dart';
import 'package:tomodachi/components/person_tile.dart';
import 'package:tomodachi/components/snackbar.dart';
import 'package:tomodachi/models/user_model.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/providers/user_provider.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/helper.dart';
import 'package:tomodachi/utility/palette.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    User owner = context.read<AuthProvider>().selectedUser!;
    Stream<QuerySnapshot> requestStream =
        context.read<UserProvider>().getRequests(owner.id!);

    return StreamBuilder(
        stream: requestStream,
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return displayStreamError(snapshot);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return displaySmallLoader();
          } else if (!snapshot.hasData) {
            return displayNoStream(snapshot);
          }

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
                    icon: const Icon(Icons.person_add),
                    color: Colors.green,
                    onPressed: () async {
                      // Remove the friend requests.
                      showLoader(context);
                      String res = await context
                          .read<UserProvider>()
                          .addFriend(owner, user);

                      // Display an error or success message.
                      if (!mounted) return;
                      hideLoader(context);

                      if (res != SUCCESS_MESSAGE) {
                        notify(ERROR_SNACK, res);
                      } else {
                        notify(SUCCESS_SNACK,
                            'You\'re now friends with ${user.firstName}!');
                      }
                    },
                  ),
                  rightButton: IconButton(
                    icon: const Icon(Icons.person_off),
                    color: Palette.RED,
                    onPressed: () async {
                      // Remove the friend requests.
                      showLoader(context);
                      String res = await context
                          .read<UserProvider>()
                          .removeRequest(owner, user);

                      // Display an error or success message.
                      if (!mounted) return;
                      context
                          .read<AuthProvider>()
                          .selectedUser!
                          .receivedRequests
                          .remove(user.id);
                      hideLoader(context);

                      if (res != SUCCESS_MESSAGE) {
                        notify(ERROR_SNACK, res);
                      } else {
                        notify(SUCCESS_SNACK,
                            'You rejected ${user.firstName}\'s request!');
                      }
                    },
                  ),
                );
              }));
        }));
  }
}
