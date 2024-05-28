import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:uuid/uuid.dart';

import '_tap_to_signature.dart';
import '../../tasks/controllers/task_manager.dart';

class SignatureSection extends StatefulWidget {
  final TaskManager task;
  final bool isSubmitting;

  const SignatureSection(
      {super.key, required this.task, required this.isSubmitting});

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
    _loadSignatures();
  }

  @override
  void dispose() {
    _confirmedByNameController.dispose();
    _preparedByNameController.dispose();
    _confirmedBySignatureController.dispose();
    _preparedBySignatureController.dispose();
    super.dispose();
  }

  Future<void> _initializeSignatureNames() async {
    final confirmedByName = await widget.task.confirmedByName;
    final preparedByName = await widget.task.preparedByName;

    setState(() {
      _confirmedByNameController.text = confirmedByName ?? '';
      _preparedByNameController.text = preparedByName ?? '';
    });
  }

  Future<void> _loadSignatures() async {
    final signatures = await _fetchSignatures();
    setState(() {
      _confirmedByUrl = signatures['ppirSigInsured'];
      _preparedByUrl = signatures['ppirSigIuia'];
    });
  }

  Future<Map<String, String>> _fetchSignatures() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('PPIR_SAVES/${widget.task.formId}/Attachments');

    final ListResult result = await storageRef.listAll();
    Map<String, String> signatures = {};

    for (Reference fileRef in result.items) {
      final downloadUrl = await fileRef.getDownloadURL();
      if (fileRef.name.contains('ppirSigInsured')) {
        signatures['ppirSigInsured'] = downloadUrl;
      } else if (fileRef.name.contains('ppirSigIuia')) {
        signatures['ppirSigIuia'] = downloadUrl;
      }
    }

    return signatures;
  }

  bool validate() {
    bool isValid = true;

    if (_confirmedByNameController.text.trim().isEmpty) {
      isValid = false;
    }
    if (_preparedByNameController.text.trim().isEmpty) {
      isValid = false;
    }
    if (_confirmedBySignatureController.isEmpty && _confirmedByUrl == null) {
      isValid = false;
    }
    if (_preparedBySignatureController.isEmpty && _preparedByUrl == null) {
      isValid = false;
    }

    return isValid;
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
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: widget.isSubmitting &&
                    _confirmedByNameController.text.trim().isEmpty
                ? 'This field is required'
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _confirmedByNameController.text = value;
            });
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => setState(() {}),
          child: Container(
            height: 200,
            color: widget.isSubmitting &&
                    (_confirmedBySignatureController.isEmpty &&
                        _confirmedByUrl == null)
                ? Colors.red[100]
                : Colors.grey,
            child: TapToSignature(
              task: widget.task,
              controller: _confirmedBySignatureController,
              height: 200,
              backgroundColor: Colors.white70,
              isError: widget.isSubmitting &&
                  (_confirmedBySignatureController.isEmpty &&
                      _confirmedByUrl == null),
              isSubmitting: widget.isSubmitting,
              isEmpty: _confirmedBySignatureController.isEmpty,
              onSaveSignature: (Uint8List signatureBytes) async {
                return await _saveSignatureToFirebase(
                    signatureBytes, 'ppirSigInsured');
              },
              signatureType: 'ppirSigInsured',
            ),
          ),
        ),
        if (widget.isSubmitting &&
            (_confirmedBySignatureController.isEmpty &&
                _confirmedByUrl == null))
          const Text(
            'This field is required',
            style: TextStyle(color: Colors.red),
          ),
        const SizedBox(height: 20),
        const Text(
          'Prepared by:',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.normal, color: Colors.black),
        ),
        TextFormField(
          controller: _preparedByNameController,
          decoration: InputDecoration(
            labelText: 'Name',
            errorText: widget.isSubmitting &&
                    _preparedByNameController.text.trim().isEmpty
                ? 'This field is required'
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _preparedByNameController.text = value;
            });
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => setState(() {}),
          child: Container(
            height: 200,
            color: widget.isSubmitting &&
                    (_preparedBySignatureController.isEmpty &&
                        _preparedByUrl == null)
                ? Colors.red[100]
                : Colors.grey,
            child: TapToSignature(
              task: widget.task,
              controller: _preparedBySignatureController,
              height: 200,
              backgroundColor: Colors.white70,
              isError: widget.isSubmitting &&
                  (_preparedBySignatureController.isEmpty &&
                      _preparedByUrl == null),
              isSubmitting: widget.isSubmitting,
              isEmpty: _preparedBySignatureController.isEmpty,
              onSaveSignature: (Uint8List signatureBytes) async {
                return await _saveSignatureToFirebase(
                    signatureBytes, 'ppirSigIuia');
              },
              signatureType: 'ppirSigIuia',
            ),
          ),
        ),
        if (widget.isSubmitting &&
            (_preparedBySignatureController.isEmpty && _preparedByUrl == null))
          const Text(
            'This field is required',
            style: TextStyle(color: Colors.red),
          ),
        const SizedBox(height: 20),
      ],
    );
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

    final ListResult result = await folderRef.listAll();

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

    return downloadUrl;
  }

  SignatureController get confirmedBySignatureController =>
      _confirmedBySignatureController;
  SignatureController get preparedBySignatureController =>
      _preparedBySignatureController;
}
