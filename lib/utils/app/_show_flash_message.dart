// src/utils/app/_show_flash_message.dart
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';

void showFlashMessage(
    BuildContext context, String status, String title, String content) {
  Color statusColor;
  IconData statusIcon;

  switch (status) {
    case 'Success':
      statusColor = Colors.green.shade300;
      statusIcon = Icons.check_circle;
      break;
    case 'Error':
      statusColor = Colors.red.shade300;
      statusIcon = Icons.error;
      break;
    case 'Info':
      statusColor = Colors.blue.shade300;
      statusIcon = Icons.info;
      break;
    default:
      statusColor = Colors.grey.shade300;
      statusIcon = Icons.help_outline;
  }
  context.showFlash(
    duration: const Duration(seconds: 4),
    builder: (context, controller) => FlashBar(
      controller: controller,
      behavior: FlashBehavior.floating,
      shadowColor: statusColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,

      margin: const EdgeInsets.all(32.0),
      clipBehavior: Clip.antiAlias,
      shouldIconPulse: false,

      // indicatorColor:
      icon: Icon(statusIcon, size: 32, color: statusColor),

      title: Text(
        title,
        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
      ),
      content: Text(
        content,
        style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w500),
      ),
    ),
  );
}
