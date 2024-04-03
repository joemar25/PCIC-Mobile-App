import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

void main() => runApp(const camera());

class camera extends StatefulWidget {
  const camera({super.key});

  @override
  _cameraState createState() => _cameraState();
}

class _cameraState extends State<camera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<void>(
        future: _initializeCamera(), // Call the _initializeCamera method directly
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(title: const Text('Take a Picture')),
              body: CameraPreview(_controller),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.camera_alt),
                onPressed: () async {
                  try {
                    final image = await _controller.takePicture();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PreviewImage(imagePath: image.path),
                      ),
                    );
                  } catch (e) {
                    print(e);
                  }
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class PreviewImage extends StatelessWidget {
  final String imagePath;

  const PreviewImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview Image')),
      body: Image.file(File(imagePath)),
    );
  }
}