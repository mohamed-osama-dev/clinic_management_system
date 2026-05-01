import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
    apiKey: 'replace-with-api-key',
    appId: '1:000000000000:flutter:placeholder',
    messagingSenderId: '000000000000',
    projectId: 'clinic-management-placeholder',
    storageBucket: 'clinic-management-placeholder.appspot.com',
  );
}
