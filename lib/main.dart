import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sih_spot_sync/Homepage.dart';
import 'package:sih_spot_sync/LandingPages.dart';
import 'package:sih_spot_sync/Login.dart';
import 'package:sih_spot_sync/ProfilePage.dart';
import 'package:sih_spot_sync/SignUpPage.dart';
import 'package:sih_spot_sync/loginandsigninredirector.dart';
import 'package:sih_spot_sync/welcome_screens/screen1.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBe-YjLqjQgAmXmzQzFweeFLoXKdId7v6w",
          appId: "1:556248166395:web:f2cbe97fe6c1034cb2e55e",
          messagingSenderId: "556248166395",
          databaseURL: "https://team007-dc442.firebaseio.com/",
          storageBucket: "gs://team007-dc442.appspot.com",
          projectId: "team007-dc442"));
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
        home: SignUpPage(),
    );
  }
}