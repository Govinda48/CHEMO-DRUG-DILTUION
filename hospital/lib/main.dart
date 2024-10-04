import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hospital/screens/drug_list_screen.dart';
import 'package:hospital/screens/sign_in_screen.dart';
import 'package:hospital/screens/sign_up_screen.dart';
import 'package:hospital/screens/spash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hospital App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/signin': (context) => const SignInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/druglist': (context) => const DrugListScreen(),
      },
      home: const SplashScreen(), // Start with SplashScreen
    );
  }
}
