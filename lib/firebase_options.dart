// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyB6Ot-bPLP9rcRwJpKlj9mi4oGUzhmvgsk',
    appId: '1:889300396306:web:6080fbedbe9487f39f6bcb',
    messagingSenderId: '889300396306',
    projectId: 'cmsc23-tomodachi',
    authDomain: 'cmsc23-tomodachi.firebaseapp.com',
    storageBucket: 'cmsc23-tomodachi.appspot.com',
    measurementId: 'G-8QWWFPE3DP',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBxLJCyd-RJl21jNP_st03mKrHoU8zEA5s',
    appId: '1:889300396306:android:2cc9bc7ac23041a09f6bcb',
    messagingSenderId: '889300396306',
    projectId: 'cmsc23-tomodachi',
    storageBucket: 'cmsc23-tomodachi.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB6K3QRPEtYtUTvEA2G9jSax_6_vqbCOwY',
    appId: '1:889300396306:ios:e1a5626fbcc9c28a9f6bcb',
    messagingSenderId: '889300396306',
    projectId: 'cmsc23-tomodachi',
    storageBucket: 'cmsc23-tomodachi.appspot.com',
    iosClientId: '889300396306-92bpjhf7pamvqlq87j95iski0983rkvb.apps.googleusercontent.com',
    iosBundleId: 'com.example.tomodachi',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB6K3QRPEtYtUTvEA2G9jSax_6_vqbCOwY',
    appId: '1:889300396306:ios:e1a5626fbcc9c28a9f6bcb',
    messagingSenderId: '889300396306',
    projectId: 'cmsc23-tomodachi',
    storageBucket: 'cmsc23-tomodachi.appspot.com',
    iosClientId: '889300396306-92bpjhf7pamvqlq87j95iski0983rkvb.apps.googleusercontent.com',
    iosBundleId: 'com.example.tomodachi',
  );
}
