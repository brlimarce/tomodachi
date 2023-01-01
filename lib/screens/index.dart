import 'package:flutter/material.dart';
import 'package:tomodachi/models/user_model.dart';
import 'package:tomodachi/screens/common/router.dart';
import 'package:tomodachi/screens/common/screen_args.dart';
import 'package:tomodachi/screens/friends/friend_page.dart';
import 'package:tomodachi/screens/friends/request_page.dart';
import 'package:tomodachi/screens/user/profile.dart';
import 'package:tomodachi/screens/user/search_page.dart';
import 'package:tomodachi/screens/task/task_page.dart';

/// The main page to display a [Stream] of [User].
RouterPage buildProfile(String uid) {
  return RouterPage(
      args: ScreenArgs('Profile', Icons.person, 1, ProfilePage(uid: uid)),
      overflow: true);
}

/// Build the page for searching [User].
RouterPage buildSearchPage() {
  return RouterPage(
      args: ScreenArgs('Search', Icons.person, 3, const SearchPage()));
}

/// The main page to display a [Stream] of [Task].
RouterPage buildTaskPage(String uid) {
  return RouterPage(
      args: ScreenArgs('Tasks', Icons.task_alt_rounded, 0, TaskPage(uid: uid)));
}

/// Build the page for displaying friend requests.
RouterPage buildRequests() {
  return RouterPage(
      args: ScreenArgs('Friend Requests', Icons.person_add_alt_1_rounded, 2,
          const RequestPage()));
}

/// Build the page for displaying [User.friends].
RouterPage buildFriends(User user) {
  return RouterPage(
      args: ScreenArgs('Friends', Icons.person_add_alt_1_rounded, 1,
          FriendPage(owner: user)));
}
