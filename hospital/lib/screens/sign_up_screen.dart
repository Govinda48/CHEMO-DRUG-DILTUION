import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:flutter/material.dart';
import 'package:hospital/widgets/social_login_button.dart';
import '../utils/validations.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _obscurePassword = true; // Toggle for password visibility
  bool _obscureConfirmPassword = true; // Toggle for confirm password visibility
  String _errorMessage = ''; // To display error messages

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create a new user with Firebase Authentication
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // Get the user ID to store in Firestore
        String userId = userCredential.user!.uid;

        // Store user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'username': _username,
          'email': _email,
        });

        // Optionally, show success message or navigate
        print('Sign up with: $_username, $_email');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful!')),
        );

        // Clear input fields after successful signup
        _formKey.currentState!.reset();
        setState(() {
          _username = '';
          _email = '';
          _password = '';
          _confirmPassword = '';
          _errorMessage = ''; // Clear error message
        });

        // Navigate to another screen, if desired
        // Navigator.pushNamed(context, '/someOtherScreen');
      } on FirebaseAuthException catch (e) {
        // Handle errors
        setState(() {
          _errorMessage = e.message ?? 'An error occurred';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: screenHeight * 0.18, // 20% of the screen height
                ),
                Text(
                  'Hi!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Create a new account',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                if (_errorMessage.isNotEmpty) ...[
                  Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                ],
                CustomTextField(
                  hintText: 'Username',
                  onChanged: (value) => _username = value,
                  validator: Validators.validateUsername,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Email',
                  onChanged: (value) => _email = value,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  onChanged: (value) => _password = value,
                  validator: Validators.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Confirm Password',
                  obscureText: _obscureConfirmPassword,
                  onChanged: (value) => _confirmPassword = value,
                  validator: (value) =>
                      Validators.validateConfirmPassword(value, _password),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'SIGN UP',
                  onPressed: _submit,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Or"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      child: const Text('Sign in'),
                      onPressed: () => Navigator.pushNamed(context, '/signin'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
