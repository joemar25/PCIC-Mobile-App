import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class TapToSignature extends StatefulWidget {
  final SignatureController controller;
  final double height;
  final Color backgroundColor;

  const TapToSignature({
    super.key,
    required this.controller,
    required this.height,
    this.backgroundColor = Colors.white,
  });

  @override
  _TapToSignatureState createState() => _TapToSignatureState();
}

class _TapToSignatureState extends State<TapToSignature> {
  bool _isConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: widget.backgroundColor,
          height: widget.height,
          child: !_isConfirmed
              ? Center(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isConfirmed = true;
                });
              },
              child: const Text('Tap to Sign'),
            ),
          )
              : Signature(
            controller: widget.controller,
            height: widget.height,
            backgroundColor: widget.backgroundColor,
          ),
        ),
      ],
    );
  }
}
