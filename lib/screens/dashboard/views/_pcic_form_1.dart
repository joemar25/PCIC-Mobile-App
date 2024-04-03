import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class PCICFormPage extends StatefulWidget {
  final String imageFile;
  final String gpxFile;

  const PCICFormPage(
      {super.key, required this.imageFile, required this.gpxFile});

  @override
  _PCICFormPageState createState() => _PCICFormPageState();
}

class _PCICFormPageState extends State<PCICFormPage> {
  File? _confirmedBySignature;
  File? _preparedBySignature;

  Future<void> _pickImage(bool isConfirmedBy) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        if (isConfirmedBy) {
          _confirmedBySignature = File(pickedImage.path);
        } else {
          _preparedBySignature = File(pickedImage.path);
        }
      });
    }
  }

  void _downloadGpxFile(String gpxFilePath) async {
    try {
      final externalStorageDirectory = await getExternalStorageDirectory();
      const gpxFileName = 'route.gpx';
      final gpxFilePath = '${externalStorageDirectory!.path}/$gpxFileName';

      await FlutterDownloader.enqueue(
        url: 'file://$gpxFilePath',
        savedDir: externalStorageDirectory.path,
        fileName: gpxFileName,
        showNotification: true,
        openFileFromNotification: true,
      );
    } catch (e) {
      print('Error downloading GPX file: $e');
    }
  }

  void _openGpxFile(String gpxFilePath) async {
    try {
      final externalStorageDirectory = await getExternalStorageDirectory();
      final gpxFilePath = '${externalStorageDirectory!.path}/route.gpx';

      if (await File(gpxFilePath).exists()) {
        await OpenFile.open(gpxFilePath);
      } else {
        print('GPX file not found: $gpxFilePath');
      }
    } catch (e) {
      print('Error opening GPX file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PCIC Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: '',
              decoration: const InputDecoration(labelText: 'Area Planted*'),
              enabled: true,
            ),
            TextFormField(
              initialValue: '',
              decoration:
                  const InputDecoration(labelText: 'Date of Planting (DS)*'),
              enabled: true,
            ),
            TextFormField(
              initialValue: '',
              decoration:
                  const InputDecoration(labelText: 'Date of Planting (TP)*'),
              enabled: true,
            ),
            TextFormField(
              initialValue: '',
              decoration:
                  const InputDecoration(labelText: 'Seed Variety Planted*'),
              enabled: true,
            ),
            TextFormField(
              initialValue: '',
              decoration: const InputDecoration(labelText: 'Remarks'),
              enabled: true,
            ),
            const SizedBox(height: 20),
            const Text(
              'Confirmed by:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _pickImage(true),
              child: Container(
                height: 200,
                color: Colors.grey[200],
                child: _confirmedBySignature != null
                    ? Image.file(
                        _confirmedBySignature!,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Text(
                          'Tap to add signature',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Prepared by:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () => _pickImage(false),
              child: Container(
                height: 200,
                color: Colors.grey[200],
                child: _preparedBySignature != null
                    ? Image.file(
                        _preparedBySignature!,
                        fit: BoxFit.cover,
                      )
                    : const Center(
                        child: Text(
                          'Tap to add signature',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Map Screenshot',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.file(
              File(widget.imageFile),
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'GPX File',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _openGpxFile(widget.gpxFile),
              child: const Text('Open GPX File'),
            ),
            ElevatedButton(
              onPressed: () => '',
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              ),
              child: const Text('Finish'),
            ),
          ],
        ),
      ),
    );
  }
}
