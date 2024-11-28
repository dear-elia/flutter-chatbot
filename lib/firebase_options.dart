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
    apiKey: 'AIzaSyCMcNxILZkux68VytZb7HjNEhTo8M_ha28',
    appId: '1:34546718908:web:ee3e1703f3f500b13f98b9',
    messagingSenderId: '34546718908',
    projectId: 'chatbotapppai',
    authDomain: 'chatbotapppai.firebaseapp.com',
    storageBucket: 'chatbotapppai.firebasestorage.app',
    measurementId: 'G-09KELLXNVS',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDgp9OmhIKOyM3f_UiSw9XyvvH4BIgK5t8',
    appId: '1:34546718908:android:6f94dee91b4a449c3f98b9',
    messagingSenderId: '34546718908',
    projectId: 'chatbotapppai',
    storageBucket: 'chatbotapppai.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBN7ZVI_yW9BC0qWzz1Psmn6NvCagj1HPo',
    appId: '1:34546718908:ios:efd68f78da1d305b3f98b9',
    messagingSenderId: '34546718908',
    projectId: 'chatbotapppai',
    storageBucket: 'chatbotapppai.firebasestorage.app',
    iosBundleId: 'com.codepluscircle.chatbotapp',
  );
}
