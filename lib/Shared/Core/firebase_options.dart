// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyArs7j_m7LHAB3GnL3Y359uPQFW2--2aUg',
    appId: '1:603939798895:web:a506e7f917284d7a52b29a',
    messagingSenderId: '603939798895',
    projectId: 'mal-app-450a8',
    authDomain: 'mal-app-450a8.firebaseapp.com',
    storageBucket: 'mal-app-450a8.appspot.com',
    measurementId: 'G-RQHRVNL9QN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAn_75dT35DvRhkLPIoNP_TOjUQAPz9e9I',
    appId: '1:603939798895:android:84dc1ac5bb4f2e0b52b29a',
    messagingSenderId: '603939798895',
    projectId: 'mal-app-450a8',
    storageBucket: 'mal-app-450a8.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC4ay9pcQwdorruePZMqezLd7LuiUhtQyI',
    appId: '1:603939798895:ios:425b8655914d3f9452b29a',
    messagingSenderId: '603939798895',
    projectId: 'mal-app-450a8',
    storageBucket: 'mal-app-450a8.appspot.com',
    androidClientId: '603939798895-098njoe1eaoivp2l3grdn7n4uh9enqt5.apps.googleusercontent.com',
    iosClientId: '603939798895-tntmcc3495tcg89k2o31enc45o7j3dk9.apps.googleusercontent.com',
    iosBundleId: 'com.example.malApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC4ay9pcQwdorruePZMqezLd7LuiUhtQyI',
    appId: '1:603939798895:ios:425b8655914d3f9452b29a',
    messagingSenderId: '603939798895',
    projectId: 'mal-app-450a8',
    storageBucket: 'mal-app-450a8.appspot.com',
    androidClientId: '603939798895-098njoe1eaoivp2l3grdn7n4uh9enqt5.apps.googleusercontent.com',
    iosClientId: '603939798895-tntmcc3495tcg89k2o31enc45o7j3dk9.apps.googleusercontent.com',
    iosBundleId: 'com.example.malApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyArs7j_m7LHAB3GnL3Y359uPQFW2--2aUg',
    appId: '1:603939798895:web:13b3f81450b5ad6552b29a',
    messagingSenderId: '603939798895',
    projectId: 'mal-app-450a8',
    authDomain: 'mal-app-450a8.firebaseapp.com',
    storageBucket: 'mal-app-450a8.appspot.com',
    measurementId: 'G-BXCVZK90ET',
  );

}