import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAbYbbDpDagmLtDq6c2rbFGJhBgD2yPzhI",
            authDomain: "nuvana-qdgji9.firebaseapp.com",
            projectId: "nuvana-qdgji9",
            storageBucket: "nuvana-qdgji9.firebasestorage.app",
            messagingSenderId: "39957190401",
            appId: "1:39957190401:web:fa3165dd9cef221c602d00",
            measurementId: "G-7BTTHB85D6"));
  } else {
    await Firebase.initializeApp();
  }
}
