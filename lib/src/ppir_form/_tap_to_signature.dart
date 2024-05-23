import 'dart:typed_data';
import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../tasks/_control_task.dart';

class TapToSignature extends StatefulWidget {
  final TaskManager task;
  final SignatureController controller;
  final double height;
  final Color backgroundColor;
  final bool isError;
  final bool isEmpty;
  final Future<String> Function(Uint8List) onSaveSignature;

  const TapToSignature(
      {super.key,
      required this.task,
      required this.controller,
      required this.height,
      this.backgroundColor = Colors.grey,
      required this.isError,
      required this.isEmpty,
      required this.onSaveSignature});

  @override
  TapToSignatureState createState() => TapToSignatureState();
}

class TapToSignatureState extends State<TapToSignature> {
  bool _isConfirmed = false;
  final _formData = <String, dynamic>{};
  String? _downloadUrl;

  @override
  void initState() {
    super.initState();
    _loadSignature();
  }

  Future<Map<String, String>> _fetchSignatures() async {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('PPIR_SAVES/${widget.task.formId}/Attachments');

    final ListResult result = await storageRef.listAll();
    Map<String, String> signatures = {};

    for (Reference fileRef in result.items) {
      if (fileRef.name.contains('ppirSigInsured')) {
        signatures['ppirSigInsured'] = await fileRef.getDownloadURL();
      }
      if (fileRef.name.contains('ppirSigIuia')) {
        signatures['ppirSigIuia'] = await fileRef.getDownloadURL();
      }
    }

    return signatures;
  }

  Future<void> _loadSignature() async {
    final signatures = await _fetchSignatures();
    setState(() {
      _downloadUrl = signatures['ppirSigInsured'] ?? signatures['ppirSigIuia'];
      _isConfirmed = _downloadUrl != null;
    });
  }

  Future<void> _saveSignature(
      BuildContext context, FlashController controller) async {
    final signatureBytes = await widget.controller.toPngBytes();
    if (signatureBytes != null) {
      final downloadUrl = await widget.onSaveSignature(signatureBytes);

      setState(() {
        _isConfirmed = true;
        _downloadUrl = downloadUrl;
      });

      if (downloadUrl.contains('ppirSigInsured')) {
        _formData['ppirSigInsured'] = downloadUrl;
      } else if (downloadUrl.contains('ppirSigIuia')) {
        _formData['ppirSigIuia'] = downloadUrl;
      }

      await widget.task.updatePpirFormData(_formData, {'status': 'Ongoing'});
    }

    controller.dismiss(); // Close the modal
  }

  void _clearSignature() {
    setState(() {
      widget.controller.clear();
      _isConfirmed = false;
      _downloadUrl = null;
    });
  }

  void _changeSignature(BuildContext context, FlashController controller) {
    setState(() {
      _downloadUrl = null;
    });

    context.showModalFlash(
      builder: (context, controller) {
        return Center(
          child: FadeTransition(
            opacity: controller.controller.drive(Tween(begin: 0.5, end: 1.0)),
            child: Flash(
              controller: controller,
              slideAnimationCreator:
                  (context, position, parent, curve, reverseCurve) {
                return CurvedAnimation(
                  parent: parent,
                  curve: curve,
                  reverseCurve: reverseCurve,
                ).drive(Tween<Offset>(
                  begin: Offset(
                    Directionality.of(context) == TextDirection.ltr
                        ? -1.0
                        : 1.0,
                    0.0,
                  ),
                  end: Offset.zero,
                ));
              },
              child: FractionallySizedBox(
                widthFactor: 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Signature(
                      controller: widget.controller,
                      height: widget.height,
                      backgroundColor: widget.backgroundColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _clearSignature();
                          },
                          child: const Text('Clear Signature'),
                        ),
                        ElevatedButton(
                          onPressed: () => _saveSignature(context, controller),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: ElevatedButton(
            onPressed: () => context.showModalFlash(
              builder: (context, controller) {
                return Center(
                  child: FadeTransition(
                    opacity: controller.controller
                        .drive(Tween(begin: 0.5, end: 1.0)),
                    child: Flash(
                      controller: controller,
                      slideAnimationCreator:
                          (context, position, parent, curve, reverseCurve) {
                        return CurvedAnimation(
                          parent: parent,
                          curve: curve,
                          reverseCurve: reverseCurve,
                        ).drive(Tween<Offset>(
                          begin: Offset(
                            Directionality.of(context) == TextDirection.ltr
                                ? -1.0
                                : 1.0,
                            0.0,
                          ),
                          end: Offset.zero,
                        ));
                      },
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        child: _downloadUrl != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    _downloadUrl!,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _changeSignature(context, controller);
                                      controller.dismiss();
                                    },
                                    child: const Text('Change Signature'),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Signature(
                                    controller: widget.controller,
                                    height: widget.height,
                                    backgroundColor: widget.backgroundColor,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _clearSignature();
                                        },
                                        child: const Text('Clear Signature'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            _saveSignature(context, controller),
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                );
              },
            ),
            child: Text(
              style: TextStyle(
                color: widget.isError && widget.isEmpty
                    ? Colors.red
                    : Colors.black,
              ),
              _isConfirmed ? 'Show Signature' : 'Tap to Sign',
            ),
          ),
        ),
      ],
    );
  }
}
