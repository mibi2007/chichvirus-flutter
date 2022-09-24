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
    apiKey: 'AIzaSyBfk1Yym4EUMCkh_D6zm-1sfKJF78pfsdc',
    appId: '1:765201314695:web:7e410543f41ede7cef9922',
    messagingSenderId: '765201314695',
    projectId: 'mibi-demo',
    authDomain: 'mibi-demo.firebaseapp.com',
    databaseURL: 'https://mibi-demo.firebaseio.com',
    storageBucket: 'mibi-demo.appspot.com',
    measurementId: 'G-EMQNY2W9SX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBwgQiwd2b6M7ZlaSurpA59VZT7PLGttXU',
    appId: '1:765201314695:android:7061cc8ca399a961ef9922',
    messagingSenderId: '765201314695',
    projectId: 'mibi-demo',
    databaseURL: 'https://mibi-demo.firebaseio.com',
    storageBucket: 'mibi-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCm9zkGR5QYDH7taxcFZ6CM15XD2GznqaY',
    appId: '1:765201314695:ios:b7febd3ec7561500ef9922',
    messagingSenderId: '765201314695',
    projectId: 'mibi-demo',
    databaseURL: 'https://mibi-demo.firebaseio.com',
    storageBucket: 'mibi-demo.appspot.com',
    androidClientId: '765201314695-dflii9l2lgj9coskq1qpfrsf6fa2jhbm.apps.googleusercontent.com',
    iosClientId: '765201314695-v047nj2jlb6s171ghd0ine4he6hm5bnl.apps.googleusercontent.com',
    iosBundleId: 'com.mibi.chichvirus.chichvirus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCm9zkGR5QYDH7taxcFZ6CM15XD2GznqaY',
    appId: '1:765201314695:ios:b7febd3ec7561500ef9922',
    messagingSenderId: '765201314695',
    projectId: 'mibi-demo',
    databaseURL: 'https://mibi-demo.firebaseio.com',
    storageBucket: 'mibi-demo.appspot.com',
    androidClientId: '765201314695-dflii9l2lgj9coskq1qpfrsf6fa2jhbm.apps.googleusercontent.com',
    iosClientId: '765201314695-v047nj2jlb6s171ghd0ine4he6hm5bnl.apps.googleusercontent.com',
    iosBundleId: 'com.mibi.chichvirus.chichvirus',
  );
}