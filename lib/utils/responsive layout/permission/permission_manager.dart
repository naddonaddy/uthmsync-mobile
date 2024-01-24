import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  // Singleton pattern to ensure there's only one instance of PermissionManager.
  static final PermissionManager _instance = PermissionManager._internal();

  factory PermissionManager() => _instance;

  PermissionManager._internal();

  /// Request permission to access the device's files.
  Future<bool> requestFilePermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      // Permission already granted.
      return true;
    } else {
      final result = await Permission.storage.request();
      if (result.isGranted) {
        // Permission granted after request.
        return true;
      } else if (result.isPermanentlyDenied) {
        _showPermissionDeniedDialog(
          "File Storage",
          "To use this feature, please enable file storage permission in your device settings.",
        );
      }
    }
    return false; // Permission denied.
  }

  /// Request permission to access the device's location.
  Future<bool> requestLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      // Permission already granted.
      return true;
    } else {
      final result = await Permission.location.request();
      if (result.isGranted) {
        // Permission granted after request.
        return true;
      } else if (result.isPermanentlyDenied) {
        _showPermissionDeniedDialog(
          "Location",
          "To use this feature, please enable location permission in your device settings.",
        );
      }
    }
    return false; // Permission denied.
  }

  /// Request permission to access the device's camera.
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      // Permission already granted.
      return true;
    } else {
      final result = await Permission.camera.request();
      if (result.isGranted) {
        // Permission granted after request.
        return true;
      } else if (result.isPermanentlyDenied) {
        _showPermissionDeniedDialog(
          "Camera",
          "To use this feature, please enable camera permission in your device settings.",
        );
      }
    }
    return false; // Permission denied.
  }

  void _showPermissionDeniedDialog(String permissionName, String message) {
    showDialog(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$permissionName Permission Denied'),
          content: Text(message),
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

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Usage Example:
// PermissionManager permissionManager = PermissionManager();
// bool hasFilePermission = await permissionManager.requestFilePermission();
// bool hasLocationPermission = await permissionManager.requestLocationPermission();
// bool hasCameraPermission = await permissionManager.requestCameraPermission();