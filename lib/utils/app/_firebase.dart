// src/utils/app/_firebase.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBubGH0CGZ9bZ8ohnJ36WCcLZ0LpjtIchw',
    appId: '1:702340663817:web:672a56b60fd6a9b19846d8',
    messagingSenderId: '702340663817',
    projectId: 'pcic-mobile-app',
    authDomain: 'pcic-mobile-app.firebaseapp.com',
    storageBucket: 'pcic-mobile-app.appspot.com',
    measurementId: 'G-D8S8W0PRJE',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXKdpMjXMMFNGD56nj4Qux717K98of3Qo',
    appId: '1:702340663817:android:a4a69e51685e466d9846d8',
    messagingSenderId: '702340663817',
    projectId: 'pcic-mobile-app',
    storageBucket: 'pcic-mobile-app.appspot.com',
  );
}
