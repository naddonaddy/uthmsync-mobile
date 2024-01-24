// ignore_for_file: use_build_context_synchronously

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uthmsync5/background/custom_background.dart';
import 'package:uthmsync5/screen/credentials.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:uthmsync5/utils/firebase_operation.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StudentRegistrationState createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final _formKey = GlobalKey<FormState>();
  String? userUid;
  String? role;
  String? fullName;
  String? studentID;
  // String? email;
  String? phoneNumber;
  String? faculty;
  bool unsavedChanges = false;
  String? selectedFilePath;
  @override
  void initState() {
    super.initState();
    _requestFileStoragePermission();
  }

  Future<void> _requestFileStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // Permission granted, you can now allow the user to pick files
    } else {
      // Permission denied, you may want to handle this case
    }
  }

  Future<void> _requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      // Permission granted, you can now use the camera
      _openCamera();
    } else {
      // Handle the case where permission is denied
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Permission Denied'),
          content: const Text('Permission denied to access the camera.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _openCamera() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      // Do something with the picked image, such as displaying it
      // For example:
      setState(() {
        // Assuming you have a variable to hold the image path
        selectedFilePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: CustomBackground(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Align(
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
                ),
                Image.asset(
                  'assets/images/registration.png',
                  height: 200,
                  width: 200,
                ),
                const Text(
                  'Student Registration',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Personal Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 50.0), // Adjusted margin
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
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
                          'Role',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          initialValue: 'Student',
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: 'Student',
                            enabled: false,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Full Name',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your full name',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            fullName = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Student ID',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your Student ID',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Student ID';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            studentID = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Upload Student ID',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10), // Adjust the left padding as needed
                          child: ElevatedButton(
                            onPressed: () {
                              _requestCameraPermission(); // Ask for camera permission
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFA2D2FF),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                // Request permission
                                PermissionStatus permissionStatus =
                                    await Permission.photos.request();

                                if (permissionStatus.isGranted) {
                                  // Proceed with image selection if permission is granted
                                  final result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.image,
                                  );

                                  if (result != null) {
                                    setState(() {
                                      selectedFilePath =
                                          result.files.single.name;
                                    });
                                  }
                                } else {
                                  // Handle permission denial
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Permission Denied'),
                                      content: const Text(
                                        'Permission denied to access photos.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA2D2FF),
                                foregroundColor: Colors.black,
                              ),
                              child: const Text('Upload'),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              selectedFilePath ?? 'No file selected',
                              style: const TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Phone Number',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter your phone number',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phoneNumber = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Faculty',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: faculty ??
                              'Select Faculty', // Set the initial value
                          items: <String>[
                            'Select Faculty',
                            'FSKTM',
                            'FPTV',
                            'FKMP',
                            'FKAAB',
                            'FPTP',
                            'FKEE',
                            'FAST',
                          ].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              faculty = value;
                            });
                          },
                          validator: (value) {
                            if (value == 'Select Faculty') {
                              return 'Please select a faculty';
                            }
                            return null;
                          },
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final form = _formKey.currentState;
                    if (form != null && form.validate()) {
                      form.save();
                      unsavedChanges = false;
                      String? imageDownloadUrl =
                          'https://example.com/image.jpg';

                      // Save personal details to Firebase
                      await StudentRegistrationFirebase.saveStudentDetails(
                        fullName: fullName,
                        studentID: studentID,
                        phoneNumber: phoneNumber,
                        faculty: faculty,
                        imageDownloadUrl: imageDownloadUrl,
                        username: '',
                        email: '',
                        password: '',
                        role: 'student',
                        userUid: '',
                      );

                      // Navigate to the Credentials page while passing necessary data
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Credentials(
                            fullName: fullName,
                            studentID: studentID,
                            phoneNumber: phoneNumber,
                            faculty: faculty,
                            imageDownloadUrl: imageDownloadUrl,
                            role: 'student',
                            isStaff: false,
                          ),
                        ),
                      );
                    } else {
                      showRequiredFieldsDialog(context);
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
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (unsavedChanges) {
      final result = await showUnsavedChangesDialog(context);
      return result ?? false;
    }
    return true;
  }

  Future<bool?> showUnsavedChangesDialog(BuildContext context) async {
    final completer = Completer<bool?>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text(
            'You have unsaved changes. Are you sure you want to leave?',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false); // Return false when canceled
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                completer.complete(true); // Confirm exit
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
        );
      },
    );

    return completer.future;
  }

  void showRequiredFieldsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content:
              const Text('Please fill in all the required fields accordingly.'),
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
