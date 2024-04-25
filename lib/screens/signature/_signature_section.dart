// filename: signature_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';

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

  bool hasChanges = false;

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
    _confirmedByNameController.text =
        widget.task.csvData?['ppirNameInsured'] ?? '';
    _preparedByNameController.text = widget.task.csvData?['ppirNameIuia'] ?? '';
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
          onChanged: (value) {
            setState(() {
              hasChanges = true;
            });
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              hasChanges = true;
            });
          },
          child: Container(
            height: 200,
            color: Colors.grey,
            child: Signature(
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
          onChanged: (value) {
            setState(() {
              hasChanges = true;
            });
          },
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              hasChanges = true;
            });
          },
          child: Container(
            height: 200,
            color: Colors.grey,
            child: Signature(
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
            const SizedBox(width: 10),
            if (hasChanges)
              IconButton(
                onPressed: _saveSignatures,
                icon: const Icon(Icons.save),
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
      hasChanges = true;
    });
  }

  void _saveSignatures() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Save'),
          content: const Text('Are you sure you want to save signatures?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _performSaveSignatures();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _performSaveSignatures() async {
    Map<String, String> signatureData = {};

    // Capture and save the confirmed by signature screenshot
    if (_confirmedBySignatureController.isNotEmpty) {
      final confirmedBySignatureBytes =
          await _confirmedBySignatureController.toPngBytes();
      final confirmedByDirectory = await getExternalStorageDirectory();
      final confirmedByFile = File(
          '${confirmedByDirectory!.path}/${widget.task.ppirInsuranceId}_confirmed_by.png');
      await confirmedByFile.writeAsBytes(confirmedBySignatureBytes!);
      debugPrint('Confirmed by signature saved: ${confirmedByFile.path}');
      signatureData['ppirSigInsured'] =
          '${widget.task.ppirInsuranceId}_confirmed_by.png';
    } else {
      signatureData['ppirSigInsured'] = '';
    }

    // Capture and save the prepared by signature screenshot
    if (_preparedBySignatureController.isNotEmpty) {
      final preparedBySignatureBytes =
          await _preparedBySignatureController.toPngBytes();
      final preparedByDirectory = await getExternalStorageDirectory();
      final preparedByFile = File(
          '${preparedByDirectory!.path}/${widget.task.ppirInsuranceId}_prepared_by.png');
      await preparedByFile.writeAsBytes(preparedBySignatureBytes!);
      debugPrint('Prepared by signature saved: ${preparedByFile.path}');
      signatureData['ppirSigIuia'] =
          '${widget.task.ppirInsuranceId}_prepared_by.png';
    } else {
      signatureData['ppirSigIuia'] = '';
    }

    // Update the task's CSV data with the signature names
    widget.task.updateCsvData({
      'ppirNameInsured': _confirmedByNameController.text,
      'ppirNameIuia': _preparedByNameController.text,
      ...signatureData,
    });

    // Save the updated CSV data back to the file
    widget.task.saveCsvData().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signatures saved successfully')),
      );
      setState(() {
        hasChanges = false;
      });
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving signatures')),
      );
    });
  }
}
