import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:crypto/crypto.dart';

// import 'package:firebase_database/firebase_database.dart';

final logger = Logger();

class StaffRegistrationFirebase {
  static Future<String?> uploadImageToFirebaseStorage(String imagePath) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      File imageFile = File(imagePath);
      TaskSnapshot snapshot = await storage
          .ref('staff_ids/${DateTime.now().millisecondsSinceEpoch}.png')
          .putFile(imageFile);
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e, stackTrace) {
      logger.e('Error uploading image to Firebase Storage: $e',
          stackTrace: stackTrace);
      return null;
    }
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var hashedPassword = sha256.convert(bytes).toString();
    return hashedPassword;
  }

  static Future<void> saveStaffDetails({
    required String? fullName,
    required String? staffID,
    required String? phoneNumber,
    required String? faculty,
    required String? imageDownloadUrl,
    required String? username,
    required String? email,
    required String? password,
    required String? userUid,
    String? role = 'staff', // Default role is 'staff'
  }) async {
    String hashedPassword = hashPassword(password!); // Hash the password

    final Uri url = Uri.https(
      'uthmsync5-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/staff-registration/$staffID.json',
    );
    final response = await http.put(
      url,
      body: json.encode({
        'fullName': fullName,
        'staffID': staffID,
        'phoneNumber': phoneNumber,
        'faculty': faculty,
        'staffIDImage': imageDownloadUrl,
        'username': username,
        'email': email,
        'password': hashedPassword, // Store the hashed password
        'makeAdmin': 'false',
        'role': role,
        'userUid': userUid,
      }),
    );

    if (response.statusCode == 200) {
      logger.d('Staff details saved to Firebase.');
    } else {
      logger.e('Failed to save staff details: ${response.statusCode}');
    }
  }
}

class StudentRegistrationFirebase {
  static Future<String?> uploadImageToFirebaseStorage(String imagePath) async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    try {
      File imageFile = File(imagePath);
      TaskSnapshot snapshot = await storage
          .ref('student_ids/${DateTime.now().millisecondsSinceEpoch}.png')
          .putFile(imageFile);
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e, stackTrace) {
      logger.e('Error uploading image to Firebase Storage: $e',
          stackTrace: stackTrace);
      return null;
    }
  }

  static String hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert the password to bytes
    var hashedPassword = sha256.convert(bytes).toString();
    return hashedPassword;
  }

  static Future<void> saveStudentDetails({
    required String? fullName,
    required String? studentID,
    required String? phoneNumber,
    required String? faculty,
    required String? imageDownloadUrl,
    required String? username,
    required String? email, // Add email parameter
    required String? password,
    required String? role,
    required String? userUid,
  }) async {
    String hashedPassword = hashPassword(password!);

    final Uri url = Uri.https(
      'uthmsync5-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/student-registration/$studentID.json',
    );
    final response = await http.put(
      url,
      body: json.encode({
        'fullName': fullName,
        'studentID': studentID,
        'phoneNumber': phoneNumber,
        'faculty': faculty,
        'studentIDImage': imageDownloadUrl,
        'username': username,
        'email': email, // Include email in the data
        'password': hashedPassword,
        'role': role,
        'userUid': userUid,
      }),
    );

    if (response.statusCode == 200) {
      logger.d('Student details saved to Firebase.');
    } else {
      logger.e('Failed to save student details: ${response.statusCode}');
    }
  }
}

Future<void> saveActivityDetails({
  required String activityName,
  required String activityDescription,
  required String location,
  required String date,
  required String time,
  required String userUid,
}) async {
  final Uri url = Uri.https(
    'uthmsync5-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/user-activities.json',
  );

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'activityName': activityName,
      'activityDescription': activityDescription,
      'location': location,
      'date': date,
      'time': time,
      'userUid': userUid,
      'ongoingStatus': true, // Set ongoing status to true
    }),
  );

  if (response.statusCode == 200) {
    print('Activity details saved to Firebase.');
  } else {
    print('Failed to save activity details: ${response.statusCode}');
    // Handle the error as needed
  }
}
