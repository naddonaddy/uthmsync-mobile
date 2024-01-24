import 'package:flutter/material.dart';
import 'package:uthmsync5/background/custom_background.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({Key? key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: CustomBackground(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 30.0), // Adjust the top value as needed
          child: Stack(
            children: <Widget>[
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/forgot.png',
                      height: 200,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Forgot Password',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Enter Email Address',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'Enter your email address',
                              hintStyle: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            keyboardType: TextInputType
                                .emailAddress, // Use email input type
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email address';
                              }
                              if (!isValidEmail(value)) {
                                return 'Please enter a valid email address';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        String email = emailController.text.trim();

                        if (isValidEmail(email)) {
                          try {
                            // Send password reset email
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);

                            // Show success message or navigate to a success screen
                            // For simplicity, here we just print a success message
                            print('Password reset email sent successfully.');

                            // Navigate users back to the previous page
                            Navigator.of(context).pop();
                          } on FirebaseAuthException catch (e) {
                            // Handle errors, e.g., if the email is not found
                            print('Failed to send password reset email: $e');
                          }
                        } else {
                          // Show an error message or handle invalid email address
                          print('Invalid email address');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      child: const Text('Continue'),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 20,
                left:
                    1, // Adjust the left value to move the button closer to the left
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white, // Set the color to white
                  ),
                  onPressed: () {
                    // Navigate users back to the previous page
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // A simple email format validation
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }
}
