import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/main.dart';
import 'package:tomodachi/screens/auth/login.dart';
import 'package:tomodachi/utility/palette.dart';

/// Build the [AppBar] to be used in the [Scaffold].
AppBar buildAppBar(BuildContext context, String name, IconData icon) {
  return AppBar(
    title: Text(name,
        style:
            const TextStyle(color: Palette.WHITE, fontWeight: FontWeight.w700)),
    centerTitle: true,
    elevation: 0,
    iconTheme: const IconThemeData(color: Palette.WHITE),
    actions: [
      IconButton(
          onPressed: () {
            context.read<AuthProvider>().logout();
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => const AuthWrapper()));
          },
          icon: const Icon(Icons.logout, color: Palette.WHITE))
    ],
  );
}
