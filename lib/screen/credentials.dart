// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:uthmsync5/background/custom_background.dart';
import 'package:uthmsync5/screen/login.dart';
import 'package:uthmsync5/utils/firebase_operation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Credentials extends StatefulWidget {
  final String? fullName;
  final String? staffID;
  final String? phoneNumber;
  final String? faculty;
  final String? imageDownloadUrl;
  final String? studentID;
  final String? role;
  final bool isStaff;

  const Credentials({
    Key? key,
    this.fullName,
    this.staffID,
    this.phoneNumber,
    this.faculty,
    this.imageDownloadUrl,
    this.studentID,
    required this.isStaff,
    this.role,
  }) : super(key: key);

  @override
  _CredentialsState createState() => _CredentialsState();
}

class _CredentialsState extends State<Credentials> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? email;
  String? password;
  String? confirmPassword;
  bool unsavedChanges = false;
  bool passwordsMatch = true;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  final _passwordController = TextEditingController();
  String? passwordStrength;

  Future<bool> _onWillPop() async {
    if (unsavedChanges) {
      // If there are unsaved changes, show a confirmation dialog
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Unsaved Changes'),
              content: const Text(
                  'You have unsaved changes. Are you sure you want to leave??'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Cancel exit
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(true); // Confirm exit
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Background color
                  ),
                  child: const Text(
                    'Leave',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ) ??
          false; // Return false if the dialog is dismissed
    } else {
      // No unsaved changes, can leave without confirmation
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: CustomBackground(
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final localContext = context;
                      bool canPop = await _onWillPop();
                      if (canPop) {
                        Navigator.of(localContext).pop();
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Credentials Registration',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              // const Center(
              //   child: Text(
              //     'Credentials',
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontStyle: FontStyle.italic,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 50.0), // Adjusted margin
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: () {
                      setState(() {
                        unsavedChanges = true;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Username',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your username',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(() {
                              username = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Email',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!isValidEmail(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            setState(
                              () {
                                email = value;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          obscureText: !isPasswordVisible,
                          controller: _passwordController,
                          onChanged: (value) {
                            if (value == confirmPassword) {
                              setState(() {
                                passwordsMatch = true;
                              });
                            } else {
                              setState(() {
                                passwordsMatch = false;
                              });
                            }
                            _updatePasswordStrength(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your password',
                            // ignore: prefer_const_constructors
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordVisible = !isPasswordVisible;
                                });
                              },
                            ),
                            errorText: passwordsMatch
                                ? null
                                : 'Passwords do not match',
                            suffix:
                                _passwordStrengthStatus(), // Display password strength here
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            password = value;
                          },
                        ),
                        const SizedBox(height: 5),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Strong password suggestion:',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '\u2022 At least 12 characters long but 14 or more is better.',
                            style: TextStyle(
                              fontSize: 10, // Small font size
                              color: Colors.black, // Hint text color
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '\u2022 A combination of uppercase letters, lowercase letters, numbers, and symbols.',
                            style: TextStyle(
                              fontSize: 10, // Small font size
                              color: Colors.black, // Hint text color
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '\u2022 Not a word that can be found in a dictionary or the name of a person, character, product, or organization.',
                            style: TextStyle(
                              fontSize: 10, // Small font size
                              color: Colors.black, // Hint text color
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '\u2022 Significantly different from your previous passwords.',
                            style: TextStyle(
                              fontSize: 10, // Small font size
                              color: Colors.black, // Hint text color
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '\u2022 Easy for you to remember but difficult for others to guess.',
                            style: TextStyle(
                              fontSize: 10, // Small font size
                              color: Colors.black, // Hint text color
                            ),
                          ),
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '\u2022 Consider using a memorable phrase like "6MonkeysRLooking^".',
                            style: TextStyle(
                              fontSize: 10, // Small font size
                              color: Colors.black, // Hint text color
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Confirm Password',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          obscureText: !isConfirmPasswordVisible,
                          onChanged: (value) {
                            if (value == _passwordController.text) {
                              // Check against the password field's value
                              setState(() {
                                passwordsMatch = true;
                              });
                            } else {
                              setState(() {
                                passwordsMatch = false;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Re-enter your password',
                            hintStyle: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isConfirmPasswordVisible =
                                      !isConfirmPasswordVisible;
                                });
                              },
                            ),
                            errorText: passwordsMatch
                                ? null
                                : 'Passwords do not match',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please re-enter your password';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            confirmPassword = value;
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: SizedBox(
                  width: 90,
                  child: ElevatedButton(
                    onPressed: () async {
                      final form = _formKey.currentState;
                      if (form != null && form.validate()) {
                        form.save();
                        unsavedChanges = false;
                        try {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );

                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .createUserWithEmailAndPassword(
                            email: email!,
                            password: password!,
                          );

                          String userUid = userCredential.user?.uid ??
                              ''; // Get the user UID

                          if (widget.isStaff) {
                            // If the user is staff, create a staff user account
                            await StaffRegistrationFirebase.saveStaffDetails(
                              username: username,
                              email: email,
                              password: password,
                              staffID: widget.staffID,
                              fullName: widget.fullName,
                              phoneNumber: widget.phoneNumber,
                              faculty: widget.faculty,
                              imageDownloadUrl: widget.imageDownloadUrl,
                              role: 'staff',
                              userUid:
                                  userUid, // Save the user UID to the database
                            );
                          } else {
                            // If the user is not staff, create a student user account
                            await StudentRegistrationFirebase.saveStudentDetails(
                              username: username,
                              email: email,
                              password: password,
                              studentID: widget.studentID,
                              fullName: widget.fullName,
                              phoneNumber: widget.phoneNumber,
                              faculty: widget.faculty,
                              imageDownloadUrl: widget.imageDownloadUrl,
                              role: 'student',
                              userUid:
                                  userUid, // Save the user UID to the database
                            );
                          }

                          // Send email verification
                          await userCredential.user?.sendEmailVerification();

                          // Close the loading indicator dialog
                          Navigator.pop(context);

                          // Navigate to the Login page after successful registration
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          // Handle registration errors, e.g., if the email is already in use
                          print('Failed to register user: $e');
                          // Close the loading indicator dialog
                          Navigator.pop(context);
                          showRegistrationErrorDialog(
                              context, e.message ?? 'Registration failed.');
                        }
                      } else {
                        // Show an error dialog if the form is not valid
                        showRequiredFieldsDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updatePasswordStrength(String password) {
    if (password.length >= 14 &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      passwordStrength = 'Strong';
    } else if (password.length < 12) {
      if (password.contains(RegExp(r'[0-9]')) ||
          password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
        passwordStrength = 'Medium';
      } else {
        passwordStrength = 'Weak';
      }
    } else {
      passwordStrength = 'Medium';
    }
  }

  Widget _passwordStrengthStatus() {
    if (passwordStrength == 'Strong') {
      return const Text(
        'Strong',
        style: TextStyle(color: Colors.green),
      );
    } else if (passwordStrength == 'Medium') {
      return const Text('Medium', style: TextStyle(color: Colors.orange));
    } else if (passwordStrength == 'Weak') {
      return const Text('Weak', style: TextStyle(color: Colors.red));
    } else {
      return const SizedBox(); // Hide status if not evaluated yet
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }

  void showRequiredFieldsDialog(BuildContext context, [String? message]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(
              message ?? 'Please fill in all the required fields accordingly.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void showRegistrationErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registration Error'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
