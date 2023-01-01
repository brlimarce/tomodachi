/// **********************************************
/// * Tomodachi 友達
/// This is a task app that allows you to share
/// your TODOs with your friends.
///
/// * Author: Bianca Raianne L. Arce
/// * Section: C-3L
/// * Date Created: November 15, 2022
/// **********************************************

import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:tomodachi/components/loading.dart';
import 'package:tomodachi/providers/auth_provider.dart';
import 'package:tomodachi/providers/user_provider.dart';
import 'package:tomodachi/providers/task_provider.dart';
import 'package:tomodachi/screens/index.dart';
import 'package:tomodachi/screens/auth/login.dart';
import 'package:tomodachi/utility/palette.dart';

// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';

// ignore: unused_import
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: ((context) => AuthProvider())),
    ChangeNotifierProvider(create: ((context) => UserProvider())),
    ChangeNotifierProvider(create: ((context) => TaskProvider()))
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget splash = SplashScreenView(
      navigateRoute: GlobalLoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Loader(),
          child: const AuthWrapper()),
      duration: 3000,
      imageSize: 88,
      imageSrc: "images/logo_inverted.png",
      backgroundColor: Palette.ORANGE,
    );

    return MaterialApp(
        title: 'Tomodachi',
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        theme: _buildTheme(),
        home: splash);
  }

  /// Returns [ThemeData] based on the app's
  /// design system in Figma.
  ///
  /// [Design System] (https://bit.ly/tomodachi-figma)
  ThemeData _buildTheme() {
    /// [theme] includes both primary swatch and font sizes.
    /// `16` is the base font size.
    ThemeData theme = ThemeData(
        primarySwatch: Palette.ORANGE_SWATCH,
        textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 61, fontWeight: FontWeight.w700),
            headline2: TextStyle(fontSize: 49, fontWeight: FontWeight.w700),
            headline3: TextStyle(fontSize: 39, fontWeight: FontWeight.w700),
            headline4: TextStyle(fontSize: 31, fontWeight: FontWeight.w500),
            headline5: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            headline6: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            bodyText2: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            button: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            caption: TextStyle(fontSize: 10, fontWeight: FontWeight.w500)));

    // Return with the Google Font (Nunito).
    return theme.copyWith(textTheme: GoogleFonts.nunitoSansTextTheme());
  }
}

/// Navigate to the login or task page, depending
/// on the authentication state.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isAuthenticated) {
      return buildTaskPage(context.read<AuthProvider>().loggedUser!.uid);
    } else {
      return const LoginPage();
    }
  }
}
