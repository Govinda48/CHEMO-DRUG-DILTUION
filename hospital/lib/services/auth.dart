import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hospital/screens/drug_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class Authentication {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        UserCredential result = await auth.signInWithCredential(authCredential);

        if (result != null) {
          // Save login state in SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful")),
          );

          // Navigate to the DrugListScreen
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DrugListScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to login")),
          );
        }
      }
    } catch (e) {
      log("Error during Google sign-in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during Google sign-in: $e")),
      );
    }
  }

  Future<void> signout(BuildContext context) async {
    try {
      await auth.signOut();
      await GoogleSignIn().signOut();

      // Clear login state from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Logout successful")),
      );

      log("Sign out successful. User: ${auth.currentUser}");
    } catch (e) {
      log("Error during sign-out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during sign-out: $e")),
      );
    }
  }
}
