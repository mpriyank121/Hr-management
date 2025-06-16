import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class CustomToast {
  static void show({
    required BuildContext context,
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (isError) {
      // Show Cupertino Alert Dialog for errors
      _showErrorDialog(context: context, message: message);
    } else {
      // Show toast for success messages
      _showSuccessToast(context: context, message: message, duration: duration);
    }
  }

  static void _showErrorDialog({
    required BuildContext context,
    required String message,
  }) {
    try {
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.exclamationmark_triangle_fill,
                  color: CupertinoColors.systemRed,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text('Error'),
              ],
            ),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Fallback to Get.snackbar if context is not available
      Get.snackbar(
        'Error',
        message,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
        borderRadius: 8,
        icon: const Icon(
          Icons.error_outline,
          color: Colors.white,
          size: 20,
        ),
      );
    }
  }

  static void _showSuccessToast({
    required BuildContext context,
    required String message,
    required Duration duration,
  }) {
    try {
      final overlay = Overlay.of(context);
      final overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).padding.top + 50,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade700,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);

      Future.delayed(duration, () {
        overlayEntry.remove();
      });
    } catch (e) {
      // Fallback to Get.snackbar if context is not available
      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green.shade700,
        colorText: Colors.white,
        duration: duration,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
        borderRadius: 8,
        icon: const Icon(
          Icons.check_circle_outline,
          color: Colors.white,
          size: 20,
        ),
      );
    }
  }

  // Helper function to replace Get.snackbar
  static void showMessage({
    required BuildContext context,
    String? title,
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 2),
  }) {
    final fullMessage = title != null ? '$title: $message' : message;
    show(
      context: context,
      message: fullMessage,
      isError: isError,
      duration: duration,
    );
  }

  // Additional helper methods for cleaner code usage
  static void showError({
    required BuildContext context,
    required String message,
  }) {
    show(context: context, message: message, isError: true);
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    show(context: context, message: message, isError: false, duration: duration);
  }
}