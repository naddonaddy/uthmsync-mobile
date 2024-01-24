import 'package:flutter/material.dart';
import 'package:uthmsync5/background/custom_background.dart';
import 'package:uthmsync5/screen/staff_registration.dart';
import 'package:uthmsync5/screen/student_registration.dart';

class Role extends StatefulWidget {
  const Role({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RoleState createState() => _RoleState();
}

class _RoleState extends State<Role> {
  String? selectedRole;
  bool showError = false;

  // Function to show the error dialog
  void showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Please select your role.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                backgroundColor:
                    Colors.blue, // Set the background color to blue
              ),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white, // Set the text color to white
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomBackground(
        child: Column(
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/role.png',
                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Are you a',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set the text color to white
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
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedRole = 'Staff';
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .green; // When pressed, show green background
                              }
                              return selectedRole == 'Staff'
                                  ? Colors.green
                                  : const Color(0xFFA2D2FF);
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center the text horizontally
                              children: [
                                if (selectedRole ==
                                    'Staff') // Display check icon if selected
                                  const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                  ),
                                const Center(
                                  child: Text(
                                    'Staff',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedRole = 'Student';
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (states) {
                              if (states.contains(MaterialState.pressed)) {
                                return Colors
                                    .green; // When pressed, show green background
                              }
                              return selectedRole == 'Student'
                                  ? Colors.green
                                  : const Color(0xFFA2D2FF);
                            }),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center the text horizontally
                              children: [
                                if (selectedRole ==
                                    'Student') // Display check icon if selected
                                  const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                  ),
                                const Center(
                                  child: Text(
                                    'Student',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  if (showError)
                    const Text(
                      'Please select your role',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedRole == null) {
                        setState(() {
                          showError = true;
                        });
                        showErrorDialog(context); // Show the error dialog
                      } else {
                        // Navigate to the appropriate registration screen
                        if (selectedRole == 'Staff') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StaffRegistration(),
                            ),
                          );
                        } else if (selectedRole == 'Student') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StudentRegistration(),
                            ),
                          );
                        }
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
          ],
        ),
      ),
    );
  }
}