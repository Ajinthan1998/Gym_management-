import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sample_app/firebase_options.dart';
import 'package:sample_app/screens/coach/coachSalary.dart';
import 'package:sample_app/screens/imgUpload/first.dart';
import 'package:sample_app/screens/imgUpload/uploadform.dart';
import 'package:sample_app/screens/member/PackageDetails.dart';
import 'package:sample_app/screens/member/home_screen.dart';
import 'package:sample_app/screens/member/nutrition.dart';

import 'screens/member/userNav.dart';
import 'screens/signin.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: Signin(),
    );
  }
}
