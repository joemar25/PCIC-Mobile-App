// GPX File Buttons
import 'package:flutter/material.dart';

class GPXFileButton extends StatelessWidget {
  final VoidCallback openGpxFile;

  const GPXFileButton({
    super.key,
    required this.openGpxFile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: openGpxFile,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: const TextStyle(fontSize: 16),
        ),
        child: const Text('Open GPX File'),
      ),
    );
  }
}
