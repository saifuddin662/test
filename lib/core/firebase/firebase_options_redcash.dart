import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Created by Shakil Ahmed Shaj [shakil.shaj@reddotdigitalit.com] on 22,February,2023.

class RedCashFirebaseOptions {
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
    apiKey: 'AIzaSyCGLTH_idyLhYRIiF95RvwNUTC483qOVD8',
    appId: '1:60422785470:android:4d84edefaa14e050b2d1ef',
    messagingSenderId: '60422785470',
    projectId: 'firstcash-agent',
    storageBucket: 'firstcash-agent.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzs-abnmlFp5at14PiZKxT8GnCBDse0y0',
    appId: '1:60422785470:ios:90a6a83b45fd2b54b2d1ef',
    messagingSenderId: '60422785470',
    projectId: 'firstcash-agent',
    storageBucket: 'firstcash-agent.appspot.com',
    iosClientId: '60422785470-8n421g2o618jciksig2gm08281icmrp3.apps.googleusercontent.com',
    iosBundleId: 'com.fsiblbd.agent',
  );
}
