// file: signature/_signature_section.dart
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';

import '../ppir_form/_tap_to_signature.dart';
import '../tasks/_control_task.dart';

class SignatureSection extends StatefulWidget {
  final TaskManager task;
  const SignatureSection({super.key, required this.task});

  @override
  SignatureSectionState createState() => SignatureSectionState();
}

class SignatureSectionState extends State<SignatureSection> {
  final _confirmedByNameController = TextEditingController();
  final _preparedByNameController = TextEditingController();

  final _confirmedBySignatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3,
    exportBackgroundColor: Colors.white,
  );

  final _preparedBySignatureController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 3,
    exportBackgroundColor: Colors.white,
  );

  String? _confirmedByUrl;
  String? _preparedByUrl;

  @override
  void initState() {
    super.initState();
    _initializeSignatureNames();
  }

  @override
  void dispose() {
    _confirmedByNameController.dispose();
    _preparedByNameController.dispose();
    super.dispose();
  }

  void _initializeSignatureNames() {
    // Initialize signature names if needed
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Confirmed by:',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextFormField(
          controller: _confirmedByNameController,
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          child: Container(
            height: 200,
            color: Colors.grey,
            child: TapToSignature(
              controller: _confirmedBySignatureController,
              height: 200,
              backgroundColor: Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Prepared by:',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextFormField(
          controller: _preparedByNameController,
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          child: Container(
            height: 200,
            color: Colors.grey,
            child: TapToSignature(
              controller: _preparedBySignatureController,
              height: 200,
              backgroundColor: Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _clearSignatures,
              child: const Text('Clear Signatures'),
            ),
          ],
        ),
      ],
    );
  }

  void _clearSignatures() {
    setState(() {
      _confirmedBySignatureController.clear();
      _preparedBySignatureController.clear();
    });
  }

  Future<Map<String, dynamic>> getSignatureData() async {
    Map<String, dynamic> signatureData = {};

    if (_confirmedByUrl == null) {
      final confirmedByBytes =
          await _confirmedBySignatureController.toPngBytes();
      if (confirmedByBytes != null) {
        _confirmedByUrl = await _saveSignatureToFirebase(
          confirmedByBytes,
          'ppirSigInsured',
        );
      }
    }

    if (_preparedByUrl == null) {
      final preparedByBytes = await _preparedBySignatureController.toPngBytes();
      if (preparedByBytes != null) {
        _preparedByUrl = await _saveSignatureToFirebase(
          preparedByBytes,
          'ppirSigIuia',
        );
      }
    }

    signatureData['ppirSigInsured'] = _confirmedByUrl;
    signatureData['ppirSigIuia'] = _preparedByUrl;
    signatureData['ppirNameInsured'] = _confirmedByNameController.text;
    signatureData['ppirNameIuia'] = _preparedByNameController.text;

    return signatureData;
  }

  Future<String> _saveSignatureToFirebase(
    Uint8List signatureBytes,
    String signatureName,
  ) async {
    final storageRef = FirebaseStorage.instance.ref();
    final folderRef =
        storageRef.child('PPIR_SAVES/${widget.task.formId}/Attachments');

    // List all items in the folder
    final ListResult result = await folderRef.listAll();

    // Delete all existing signature files in the folder
    for (Reference fileRef in result.items) {
      if (fileRef.name.contains(signatureName)) {
        await fileRef.delete();
      }
    }

    const uuid = Uuid();
    final signatureFilename = '${uuid.v4()}_$signatureName.png';
    final signatureFileRef = folderRef.child(signatureFilename);

    await signatureFileRef.putData(signatureBytes);

    final downloadUrl = await signatureFileRef.getDownloadURL();
    debugPrint('Signature uploaded to Firebase: $downloadUrl');

    return downloadUrl;
  }

  SignatureController get confirmedBySignatureController =>
      _confirmedBySignatureController;
  SignatureController get preparedBySignatureController =>
      _preparedBySignatureController;
}
