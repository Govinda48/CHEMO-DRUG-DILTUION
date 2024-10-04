import 'package:flutter/material.dart';
import 'package:hospital/services/auth.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Authentication class
    final Authentication auth = Authentication();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: double.infinity, // Makes the button full-width
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white, // Google button red color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            padding: const EdgeInsets.symmetric(vertical: 15), // Button height
          ),
          icon: Image.asset(
            'assets/google.png', // Replace with your Google icon asset
            height: 24.0, // Icon size
          ),

          label: const Text(
            ' |   Sign In with Google',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () => auth.signup(context), // Trigger Google signup method
        ),
      ),
    );
  }
}
