// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:uthmsync5/background/custom_background.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:uthmsync5/screen/activities_history.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uthmsync5/screen/login.dart';
import 'dart:io';
import 'package:uthmsync5/utils/firebase_operation.dart';
import 'package:firebase_auth/firebase_auth.dart';


class UserDashboard extends StatefulWidget {
  final String userUid;

  const UserDashboard({Key? key, required this.userUid}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  final DateTime _selectedDate = DateTime.now();
  final TimeOfDay _selectedTime = TimeOfDay.now();
  bool startTimer = false;
  Stopwatch? stopwatch;
  bool _isActivityRunning = false;

  // Initialize with the current time
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _activityDescriptionController =
      TextEditingController();
  final TextEditingController _activityNameController = TextEditingController();

  File? profilePicture;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers with the selected date and time
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    _timeController.text = '${_selectedTime.hour}:${_selectedTime.minute}';
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    stopwatch?.stop();
    super.dispose();
  }

  Timer? _timer; // Define _timer here

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'submenu1') {
                  // Do something for submenu1
                } else if (value == 'submenu2') {
                  // Do something for submenu2
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'submenu1',
                    child: Text('Submenu 1'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'submenu2',
                    child: Text('Submenu 2'),
                  ),
                ];
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFF246ee9), // Use the desired color value
                ),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Profile Picture'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (profilePicture == null)
                                        const CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.person,
                                            size: 60,
                                            color: Colors.blue,
                                          ),
                                        )
                                      else
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          backgroundImage:
                                              FileImage(profilePicture!),
                                        ),
                                      ElevatedButton(
                                        onPressed: () async {
                                          final imagePicker = ImagePicker();
                                          final XFile? image =
                                              await imagePicker.pickImage(
                                            source: ImageSource.gallery,
                                          );

                                          if (image != null) {
                                            // Handle the selected image (XFile) here
                                            // Typically, you'll want to save this image to the user's profile or display it.
                                          } else {
                                            // User canceled the image selection
                                          }
                                        },
                                        child: const Text('Upload Picture'),
                                      ),
                                      if (profilePicture != null)
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle picture change logic here
                                            // Show an image picker to allow the user to choose a new picture
                                          },
                                          child: const Text('Change Picture'),
                                        ),
                                      if (profilePicture != null)
                                        ElevatedButton(
                                          onPressed: () {
                                            // Handle picture removal logic here
                                            // Remove the existing picture
                                          },
                                          child: const Text('Remove Picture'),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'NUR NADHIRAH MOHD HARITH LIM',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Student: FSKTM',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'AI200133',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: -25, // Adjusted to prevent overflow
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Handle edit profile logic here
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 16, // Adjust the icon size as needed
                        ),
                        label: const Text('', style: TextStyle(fontSize: 10)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          elevation: 0,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // ExpansionTile(
              //   title: const Text('Item 1'),
              //   children: [
              //     ListTile(
              //       title: const Text('Submenu 1.1'),
              //       onTap: () {
              //         Navigator.pop(context);
              //       },
              //     ),
              //     ListTile(
              //       title: const Text('Submenu 1.2'),
              //       onTap: () {
              //         Navigator pop(context);
              //       },
              //     ),
              //   ],
              // ),
              ExpansionTile(
                title: const Text('Item 1'),
                children: [
                  ListTile(
                    title: const Text('Submenu 2.1'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Submenu 2.2'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text('Item 2'),
                children: [
                  ListTile(
                    title: const Text('Submenu 2.1'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Submenu 2.2'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  _signOut(context); // Pass the context
                },
                child: const ListTile(
                  title: Text('Sign Out'),
                ),
              )
            ],
          ),
        ),
        extendBodyBehindAppBar: true,
        body: CustomBackground(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 80.0),
                // Swiper for Cards
                SizedBox(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: Swiper(
                    itemCount: 2, // Number of cards
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        width: 300.0, // Set the desired width for the card
                        height: 200.0, // Set the desired height for the card
                        child: Stack(
                          children: [
                            Card(
                              elevation: 10, // Add elevation to the card
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  16.0,
                                ), // Add border radius
                              ),
                              color: Colors
                                  .transparent, // Set the card color to transparent
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue[300]!, // Start color
                                      Colors.blue[700]!, // End color
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16.0),
                                  // Add custom decoration with diagonal lines as a pattern
                                  border: Border.all(
                                    color: Colors.white, // Color of the lines
                                    width: 2.0, // Width of the lines
                                  ),
                                ),
                                child: const Center(
                                    // Remove the Text widget below to remove "Card $index"
                                    ),
                              ),
                            ),
                            if (index == 0) // Check if it's Card 0
                              Positioned(
                                left:
                                    30.0, // Adjust the left position as needed
                                top:
                                    25.0, // You can adjust the top position if needed
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hello,',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'welcome!',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if (index == 0) // Check if it's Card 0
                              Positioned(
                                left:
                                    110.0, // Adjust the left position as needed for the image
                                top:
                                    30.0, // Adjust the top position as needed for the image
                                child: Image.asset(
                                  'assets/images/card0.png',
                                  fit: BoxFit
                                      .cover, // Adjust the BoxFit as needed
                                  width:
                                      250.0, // Set the desired width for the image
                                  height:
                                      200.0, // Set the desired height for the image
                                ),
                              ),
                            if (index == 1) // Check if it's Card 1
                              Positioned(
                                left:
                                    -25.0, // Adjust the left position to place the image on the left side
                                top:
                                    0.0, // Adjust the top position to align with the card
                                child: Image.asset(
                                  'assets/images/card1a.png',
                                  fit: BoxFit
                                      .cover, // Adjust the BoxFit as needed
                                  width:
                                      150.0, // Set the desired width for the image
                                  height:
                                      200.0, // Set the desired height for the image
                                ),
                              ),
                            if (index == 1) // Check if it's Card 1
                              Positioned(
                                left:
                                    98.0, // Adjust the left position as needed for the text
                                top:
                                    80.0, // Adjust the top position as needed for the text
                                child: Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'You have completed',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '10 activities!',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'Good job!',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                    layout: SwiperLayout
                        .STACK, // Use the STACK layout for swipeable cards
                    itemWidth: 300.0, // Set the card width as needed
                    itemHeight: 200.0, // Set the card height as needed
                  ),
                ),
                // Static Column of Cards
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStaticCard(
                      [Colors.yellow, Colors.amber],
                      0, // Card index
                    ), // Gradient for static card 1
                    _buildStaticCard(
                      [Colors.yellow, Colors.orange],
                      1, // Card index
                    ), // Gradient for static card 2
                    _buildStaticCard(
                      [Colors.yellow, Colors.deepOrange],
                      2, // Card index
                    ), // Gradient for static card 3
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Align(
          alignment: const Alignment(
              0.9, 0.9), // Adjust these values to position the button
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isActivityRunning
                ? FloatingActionButton(
                    onPressed: () {
                      _stopActivity(); // Show the stop confirmation dialog
                    },
                    child: const Icon(Icons.stop),
                  )
                : FloatingActionButton(
                    onPressed: () {
                      _showPopUpForm(context); // Show the pop-up form
                    },
                    child: const Icon(Icons.add),
                  ),
          ),
        ),
      ),
    );
  }

  void _stopActivity() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Stop Activity'),
          content: const Text('Have you completed the activity?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                if (_isActivityRunning) {
                  // If activity is running, stop it and reset the timer
                  _isActivityRunning = false;
                  stopwatch?.reset(); // Reset the stopwatch
                  _timer?.cancel();
                }
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      _showStopActivityPopUpForm(context);
                      return const UserDashboard(
                        userUid: '',
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void _showPopUpForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              autovalidateMode:
                  AutovalidateMode.always, // Enable auto-validation
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text(
                    'Add Activity',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _activityNameController,
                    decoration:
                        const InputDecoration(labelText: 'Activity name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the activity name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _activityDescriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Activity description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the activity description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                    ),
                    validator: (value) {
                      // Validator function to check if the location is not empty
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null; // Return null if the validation succeeds
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Date'),
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Time'),
                    readOnly: true,
                    controller: TextEditingController(
                      text:
                          '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        startTimer = true;
                        _isActivityRunning = true;
                        stopwatch = Stopwatch()..start();

                        _timer = Timer.periodic(
                          const Duration(seconds: 1),
                          (timer) => _updateTimer(
                              timer), // Invoke your timer update function
                        );

                        try {
                          await saveActivityDetails(
                            activityName: _activityNameController.text,
                            activityDescription:
                                _activityDescriptionController.text,
                            location: _locationController.text,
                            date:
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            time:
                                '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
                            userUid: widget
                                .userUid, // Access userUid from the widget
                          );

                          Navigator.of(context).pop(); // Close the dialog
                        } catch (e) {
                          print('Error saving activity details: $e');
                          // Handle error as needed
                        }
                      } else {
                        showRequiredFieldsDialog(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showStopActivityPopUpForm(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    List<File?> uploadedPictures =
        List.filled(3, null); // Change the size based on your requirement

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Row(
                    children: [
                      Spacer(),
                      Text(
                        'Activity Summary',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _activityNameController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Activity name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter activity name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _activityDescriptionController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Activity description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter activity description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Location',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Date'),
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Time'),
                    readOnly: true,
                    controller: TextEditingController(
                      text:
                          '${TimeOfDay.now().hour}:${TimeOfDay.now().minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // ListView.builder for uploading multiple pictures
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: uploadedPictures.length,
                    itemBuilder: (context, index) {
                      String fileName = 'No file selected';
                      if (uploadedPictures[index] != null) {
                        fileName =
                            uploadedPictures[index]!.path.split('/').last;
                      }

                      TextEditingController controller = TextEditingController(
                        text: fileName,
                      );

                      return Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Picture ${index + 1}',
                              ),
                              readOnly: true,
                              controller: controller,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final imagePicker = ImagePicker();
                              final XFile? image = await imagePicker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (image != null) {
                                final updatedPictures =
                                    List<File?>.from(uploadedPictures);
                                updatedPictures[index] = File(image.path);
                                controller.text = image.name;
                                formKey.currentState!.save();
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  uploadedPictures = updatedPictures;
                                });
                              }
                            },
                            child: const Text('Upload Picture'),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      // Validate the form
                      if (formKey.currentState!.validate()) {
                        startTimer = true;
                        _isActivityRunning = true;
                        stopwatch = Stopwatch()..start();

                        _timer = Timer.periodic(
                            const Duration(seconds: 1), _updateTimer);

                        Navigator.of(context).pop(); // Close the bottom sheet
                      } else {
                        // Show the required fields dialog when validation fails
                        showRequiredFieldsDialog(context);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                  const SizedBox(height: 8.0),
                ],
              ),
            ),
          ),
        );
      },
    );
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

  void _updateTimer(Timer timer) {
    setState(() {
      // Update the stopwatch display
    });
  }

  Widget _buildStaticCard(List<Color> gradientColors, int index) {
    if (index == 1) {
      // For index 1: Ongoing activity
      return SizedBox(
        width: 300.0,
        height: 200.0,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Ongoing activity',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Activity name',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else if (index == 2) {
      // For index 2: Activities history
      return SizedBox(
        width: 300.0,
        height: 200.0,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: InkWell(
            onTap: () {
              // Navigate to ActivitiesHistory class when clicked
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ActivitiesHistory(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const Center(
                child: Text(
                  'Activity history',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: 300.0,
        height: 200.0,
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Stopwatch',
                  style: TextStyle(
                    fontSize: 20.0, // Adjust the font size as needed
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10.0), // Adjust the spacing as needed
                stopwatch != null
                    ? StopwatchText(stopwatch: stopwatch!)
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      );
    }
  }
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

void _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Login(),
      ),
    );
  } catch (e) {
    if (e is FirebaseAuthException) {
      print('Firebase Auth Error: ${e.message}');
    }
    print('Error signing out: $e');
  }
}

class StopwatchText extends StatefulWidget {
  final Stopwatch stopwatch;

  const StopwatchText({Key? key, required this.stopwatch}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StopwatchTextState createState() => _StopwatchTextState();
}

class _StopwatchTextState extends State<StopwatchText> {
  @override
  void initState() {
    super.initState();
    // Start the timer to update the stopwatch display
    Timer.periodic(const Duration(seconds: 1), _updateTimer);
  }

  void _updateTimer(Timer timer) {
    setState(() {
      // Update the stopwatch display
    });
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (widget.stopwatch.elapsedMilliseconds / 60000).floor();
    final seconds =
        ((widget.stopwatch.elapsedMilliseconds % 60000) / 1000).floor();
    final milliseconds = (widget.stopwatch.elapsedMilliseconds % 1000).floor();

    return Text(
      '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.${milliseconds.toString().padLeft(3, '0')}',
      style: const TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
