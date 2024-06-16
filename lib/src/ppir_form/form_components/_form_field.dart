// src/ppir_form/form_components/_form_field.dart
import 'package:flutter/material.dart';

class FormField extends StatelessWidget {
  final String labelText;
  final String initialValue;
  final bool enabled;
  final int maxLines;

  const FormField({
    super.key,
    required this.labelText,
    required this.initialValue,
    this.enabled = true,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
