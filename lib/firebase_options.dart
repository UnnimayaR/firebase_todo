import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'No Web configuration provided. Add web configuration in firebase_options.dart',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCIQJr-hcvipaEgWJ7dx2xu3VMyhFdraZY',
    appId: '1:22911648402:android:76b0994a492d247794dc4b',
    messagingSenderId: '22911648402',
    projectId: 'flutter-firebase-31527',
    storageBucket: 'flutter-firebase-31527.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_API_KEY',
    appId: 'YOUR_GOOGLE_APP_ID',
    messagingSenderId: 'YOUR_GCM_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_STORAGE_BUCKET',
    iosClientId: 'YOUR_CLIENT_ID',
    iosBundleId: 'com.example.yourAppName',
  );
}
