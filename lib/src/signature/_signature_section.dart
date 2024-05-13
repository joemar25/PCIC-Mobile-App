import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../pcic_form/_tap_to_signature.dart';
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
    // _confirmedByNameController.text =
    //     widget.task.csvData?['ppirNameInsured'] ?? '';
    // _preparedByNameController.text = widget.task.csvData?['ppirNameIuia'] ?? '';
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

    final confirmedByBytes = await _confirmedBySignatureController.toPngBytes();
    final preparedByBytes = await _preparedBySignatureController.toPngBytes();

    signatureData['ppirSigInsured'] = confirmedByBytes;
    signatureData['ppirSigIuia'] = preparedByBytes;
    signatureData['ppirNameInsured'] = _confirmedByNameController.text;
    signatureData['ppirNameIuia'] = _preparedByNameController.text;

    return signatureData;
  }

  SignatureController get confirmedBySignatureController =>
      _confirmedBySignatureController;
  SignatureController get preparedBySignatureController =>
      _preparedBySignatureController;
}
