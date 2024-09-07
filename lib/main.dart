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
          apiKey: "",
          appId: "",
          messagingSenderId: "",
          projectId: ""));
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
        home: SplashScreen(),
    );
  }
}
