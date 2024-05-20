// file: _gpx_file_buttons.dart
import 'package:flutter/material.dart';

class GPXFileButtons extends StatelessWidget {
  final VoidCallback openGpxFile;

  const GPXFileButtons({
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
