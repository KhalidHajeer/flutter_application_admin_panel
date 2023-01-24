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
    apiKey: 'AIzaSyAFh9MnVrv5cVR6I6KXuTBheEPRnuTxER4',
    appId: '1:570888501526:web:108c65aadee6a442a7b837',
    messagingSenderId: '570888501526',
    projectId: 'fir-example-5cc62',
    authDomain: 'fir-example-5cc62.firebaseapp.com',
    databaseURL: 'https://fir-example-5cc62-default-rtdb.firebaseio.com',
    storageBucket: 'fir-example-5cc62.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_RhaVguuuFe23Sx9KB8J-zoVxpUxxH-k',
    appId: '1:570888501526:android:cee12c0bdb1ae279a7b837',
    messagingSenderId: '570888501526',
    projectId: 'fir-example-5cc62',
    databaseURL: 'https://fir-example-5cc62-default-rtdb.firebaseio.com',
    storageBucket: 'fir-example-5cc62.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUHoAY15OIv_uR6E_UbSMhb9PzYbxwiZk',
    appId: '1:570888501526:ios:7ca69ca431a5848fa7b837',
    messagingSenderId: '570888501526',
    projectId: 'fir-example-5cc62',
    databaseURL: 'https://fir-example-5cc62-default-rtdb.firebaseio.com',
    storageBucket: 'fir-example-5cc62.appspot.com',
    androidClientId: '570888501526-rvfuthalduqm06p5chsm9jmcmfg4a2hp.apps.googleusercontent.com',
    iosClientId: '570888501526-gcpcjggbk0dtk0377akfvpsp2tmetcru.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplicationAdminPanel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBUHoAY15OIv_uR6E_UbSMhb9PzYbxwiZk',
    appId: '1:570888501526:ios:7ca69ca431a5848fa7b837',
    messagingSenderId: '570888501526',
    projectId: 'fir-example-5cc62',
    databaseURL: 'https://fir-example-5cc62-default-rtdb.firebaseio.com',
    storageBucket: 'fir-example-5cc62.appspot.com',
    androidClientId: '570888501526-rvfuthalduqm06p5chsm9jmcmfg4a2hp.apps.googleusercontent.com',
    iosClientId: '570888501526-gcpcjggbk0dtk0377akfvpsp2tmetcru.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApplicationAdminPanel',
  );
}
