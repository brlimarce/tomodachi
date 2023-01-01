import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/components/loading.dart';
import 'package:tomodachi/components/snackbar.dart';
import 'package:tomodachi/models/user_model.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/providers/user_provider.dart';
import 'package:tomodachi/screens/index.dart';
import 'package:tomodachi/utility/constants.dart';
import 'package:tomodachi/utility/helper.dart';
import 'package:tomodachi/utility/palette.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic> matches = {};
  String search = '';
  bool isFriend = false;
  // late final NotificationProvider service;

  // @override
  // void initState() {
  //   service = NotificationProvider();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> searchStream =
        context.watch<UserProvider>().searchUsers(search);
    return Column(children: [
      // Search Bar
      TextField(
        controller: _searchController,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Search username',
            prefixIcon: Icon(Icons.search)),
        onSubmitted: (value) async {
          // Find searches.
          setState(() {
            search = _searchController.text;
          });

          // Clear the text field.
          context.read<UserProvider>().searchUsers(_searchController.text);
          _searchController.clear();
        },
      ),

      const SizedBox(height: 32),

      Flexible(
          child: StreamBuilder(
              stream: searchStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return displayStreamError(snapshot);
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return displaySmallLoader();
                } else if (!snapshot.hasData) {
                  return displayNoStream(snapshot);
                }

                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      // Get the data in JSON.
                      Map<String, dynamic> data = snapshot.data?.docs[index]
                          .data() as Map<String, dynamic>;
                      User user = User.fromJson(data);

                      // Check if the mutual's ID is in the owner's
                      // friend or friend requests.
                      User owner = context.read<AuthProvider>().selectedUser!;
                      bool isDisabled = owner.friends.contains(user.id) ||
                          owner.sentRequests.contains(user.id) ||
                          owner.receivedRequests.contains(user.id) ||
                          owner.id == user.id;

                      // Render a list tile.
                      return Container(
                        key: Key(user.id.toString()),
                        child: ListTile(
                          title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(user.firstName,
                                    style: const TextStyle(
                                        color: Palette.BLACK,
                                        fontWeight: FontWeight.w500)),
                                Text('@${user.username}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(color: Palette.GREY))
                              ]),
                          leading: CircleAvatar(
                              child: Text(user.firstName[0],
                                  style:
                                      const TextStyle(color: Palette.ORANGE))),
                          minVerticalPadding: 20,
                          trailing:
                              Row(mainAxisSize: MainAxisSize.min, children: [
                            // Profile Button
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              buildProfile(user.id!)));
                                },
                                icon: const Icon(Icons.person,
                                    color: Colors.blue)),

                            // Friend/Unfriend Button
                            !isDisabled
                                ? IconButton(
                                    onPressed: () async {
                                      showLoader(context);
                                      String res = '';

                                      // Add Friend
                                      res = await context
                                          .read<UserProvider>()
                                          .addRequest(
                                              context
                                                  .read<AuthProvider>()
                                                  .selectedUser!,
                                              user);
                                      if (!mounted) return;
                                      hideLoader(context);

                                      // Display an error or success message.
                                      if (res != SUCCESS_MESSAGE) {
                                        notify(ERROR_SNACK, res);
                                      } else {
                                        notify(SUCCESS_SNACK,
                                            'You sent a friend request!');
                                      }
                                    },
                                    icon: const Icon(Icons.person_add,
                                        color: Colors.green))
                                : const SizedBox()
                          ]),
                        ),
                      );
                    }));
              }))
    ]);
  }
}
