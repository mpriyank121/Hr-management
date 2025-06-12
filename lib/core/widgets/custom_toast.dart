import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomToast {
  static void show({
    required BuildContext context,
    required String message,
    bool isError = false,
    Duration duration = const Duration(seconds: 2),
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
                color: isError ? Colors.red.shade700 : Colors.green.shade700,
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
                  Icon(
                    isError ? Icons.error_outline : Icons.check_circle_outline,
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
        isError ? 'Error' : 'Success',
        message,
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        colorText: Colors.white,
        duration: duration,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
        borderRadius: 8,
        icon: Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
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
    try {
      final fullMessage = title != null ? '$title: $message' : message;
      show(
        context: context,
        message: fullMessage,
        isError: isError,
        duration: duration,
      );
    } catch (e) {
      // Fallback to Get.snackbar if context is not available
      Get.snackbar(
        title ?? (isError ? 'Error' : 'Success'),
        message,
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        colorText: Colors.white,
        duration: duration,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(20),
        borderRadius: 8,
        icon: Icon(
          isError ? Icons.error_outline : Icons.check_circle_outline,
          color: Colors.white,
          size: 20,
        ),
      );
    }
  }
} 