import 'package:flutter/material.dart';
import 'package:hospital/screens/drug_list_screen.dart';
import 'package:hospital/utils/validations.dart';
import 'package:hospital/widgets/social_login_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _obscurePassword = true; // State to manage password visibility
  String _errorMessage = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Sign in with Firebase
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        // If successful, navigate to the DrugListScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DrugListScreen()),
          (Route<dynamic> route) => false, // Remove all previous routes
        );
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: screenHeight * 0.2, // 20% of the screen height
                  ),
                  Text(
                    'Welcome!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                      height: screenHeight * 0.05), // 5% of the screen height
                  CustomTextField(
                    hintText: 'Email',
                    onChanged: (value) => _email = value,
                    validator: Validators.validateEmail,
                  ),
                  SizedBox(
                      height: screenHeight * 0.02), // 2% of the screen height
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
                          _obscurePassword =
                              !_obscurePassword; // Toggle password visibility
                        });
                      },
                    ),
                  ),
                  // Show error message if login fails
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  SizedBox(
                      height: screenHeight * 0.04), // 4% of the screen height
                  CustomButton(
                    text: 'LOGIN',
                    onPressed: _submit,
                  ),

                  SizedBox(
                      height: screenHeight * 0.02), // 2% of the screen height
                  const Text(
                    'Or',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                      height: screenHeight * 0.02), // 2% of the screen height
                  const SocialLoginButtons(),
                  SizedBox(
                      height: screenHeight * 0.02), // 2% of the screen height
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        child: const Text('Sign up'),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signup'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
