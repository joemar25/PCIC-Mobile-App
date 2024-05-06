import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import the flutter_svg package

void showFlashMessage(
    BuildContext context, String status, String title, String content) {
  context.showFlash(
    duration: const Duration(seconds: 3),
    builder: (context, controller) => FlashBar(
      controller: controller,
      behavior: FlashBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        side: BorderSide(
          color: status == 'Success' ? Colors.green : Colors.red,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      surfaceTintColor: Colors.white,
      margin: const EdgeInsets.all(32.0),
      clipBehavior: Clip.antiAlias,
      indicatorColor: status == 'Success' ? Colors.green : Colors.red,
      icon: SvgPicture.asset(
        status == 'Success'
            ? 'assets/storage/images/success.svg'
            : 'assets/storage/images/error.svg',
        height: 35,
        colorFilter: ColorFilter.mode(
            status == 'Success' ? Colors.green.shade900 : Colors.red.shade900,
            BlendMode.srcIn),
      ),
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
