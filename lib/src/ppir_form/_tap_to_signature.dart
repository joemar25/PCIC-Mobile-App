import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class TapToSignature extends StatefulWidget {
  final SignatureController controller;
  final double height;
  final Color backgroundColor;
  final bool isError;
  final bool isEmpty;

  const TapToSignature(
      {super.key,
      required this.controller,
      required this.height,
      this.backgroundColor = Colors.grey,
      required this.isError,
      required this.isEmpty});

  @override
  TapToSignatureState createState() => TapToSignatureState();
}

class TapToSignatureState extends State<TapToSignature> {
  bool _isConfirmed = false;

  void _saveSignature(BuildContext context, FlashController controller) {
    setState(() {
      _isConfirmed = true;
    });

    controller.dismiss(); // Close the modal
  }

  void _cancelSignature(BuildContext context, FlashController controller) {
    controller.dismiss(); // Close the modal
  }

  void _clearSignature() {
    setState(() {
      widget.controller.clear();
    });
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
                                  reverseCurve: reverseCurve)
                              .drive(Tween<Offset>(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        _clearSignature();
                                        _cancelSignature(context, controller);
                                      },
                                      child: const Text('Cancel'),
                                    ),
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
                            ))),
                  ),
                );
              },
            ),
            child: Text(
                style: TextStyle(
                    color: widget.isError && widget.isEmpty
                        ? Colors.red
                        : Colors.black),
                _isConfirmed ? 'Show Signature' : 'Tap to Sign'),
          ),
        )
      ],
    );
  }
}



/**
 * 
 * FractionallySizedBox(
                        widthFactor: 0.9,
                        child: SizedBox(
                          height: 200,
                          child: Material(
                            elevation: 24,
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: SafeArea(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text('A custom with Flash'),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            controller
                                                .dismiss(); // Close the flash dialog
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Add your confirm action here
                                            controller
                                                .dismiss(); // Close the flash dialog
                                          },
                                          child: Text('Save Signature'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )


                      // child: !_isConfirmed
        //     ? Center(
        //         child: ElevatedButton(
        //           onPressed: () {
        //             setState(() {
        //               _isConfirmed = true;
        //             });
        //           },
        //           child: Text(
        //               style: TextStyle(
        //                   color: widget.isError && !_isConfirmed
        //                       ? Colors.red
        //                       : Colors.black),
        //               'Tap to Sign'),
        //         ),
        //       )
        //     : Signature(
        //         controller: widget.controller,
        //         height: widget.height,
        //         backgroundColor: widget.backgroundColor,
        //       ),
 * 
 * 
 * 
 */