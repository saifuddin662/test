import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 08,February,2023.

class FirstCashFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDL_mz1E648g3X9ZzW0G8wUbehuMV1RINA',
    appId: '1:780969586721:android:70c2280570fa6a7f17f360',
    messagingSenderId: '780969586721',
    projectId: 'firstcash-customer',
    storageBucket: 'firstcash-customer.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNe9e-jkaNmJV33VfKRubaCQ03wn2_Dls',
    appId: '1:780969586721:ios:f14d5ec063e4ceb717f360',
    messagingSenderId: '780969586721',
    projectId: 'firstcash-customer',
    storageBucket: 'firstcash-customer.appspot.com',
    iosClientId: '780969586721-9hsnvv4emfsqns33ookn701ql5u8je08.apps.googleusercontent.com',
    iosBundleId: 'com.fsiblbd.customer',
  );
}
