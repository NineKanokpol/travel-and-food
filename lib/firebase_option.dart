import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

///เลือก option platform ของ firebase และกำหนด google service
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      // return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      return android;
      case TargetPlatform.iOS:
        // return ios;
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
    apiKey: 'AIzaSyAasFdj3hej83rQc1o-ExJARHGUsutgHYM',
    appId: '1:318661611178:android:c16d22c19c3249d1c68ad3',
    messagingSenderId: '318661611178',
    projectId: 'travel-and-food-9bd5b',
    storageBucket: 'travel-and-food-9bd5b.firebasestorage.app',
  );

  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyAxxA-roH8l22K44T2SWTKoiKaFTtQs77I',
  //   appId: '1:32016133613:android:744d0665c41aab2ce58be4',
  //   messagingSenderId: '32016133613',
  //   projectId: 'tempdashboard-5d96a',
  //   storageBucket: 'tempdashboard-5d96a.appspot.com',
  //   // androidClientId: '683968561069-78kespt11jkdo1u3q92douikkdusni7k.apps.googleusercontent.com',
  //   // iosClientId: '683968561069-jdhu6537kgchue8d6n5kk9852qfirgd9.apps.googleusercontent.com',
  //   // iosBundleId: 'com.mobilysttech.driver.psu.staging',
  // );
}