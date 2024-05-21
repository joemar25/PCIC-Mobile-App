// ppir_forms/_form_section.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../utils/controls/_date_control.dart';

class FormSection extends StatelessWidget {
  final Map<String, dynamic> formData;
  final List<DropdownMenuItem<String>> uniqueSeedsItems;

  const FormSection({
    super.key,
    required this.formData,
    required this.uniqueSeedsItems,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        const Text(
          'Actual Date of Planting',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        DateInputField(
          labelText: 'DS*',
          initialDate: formData['ppirDopdsAct'] != null &&
                  formData['ppirDopdsAct'].isNotEmpty
              ? DateFormat('yyyy-MM-dd').parse(formData['ppirDopdsAct'])
              : null,
          onDateChanged: (DateTime? date) {
            if (date != null) {
              formData['ppirDopdsAct'] = DateFormat('yyyy-MM-dd').format(date);
            } else {
              formData['ppirDopdsAct'] = null;
            }
          },
        ),
        const SizedBox(height: 16),
        DateInputField(
          labelText: 'TP*',
          initialDate: formData['ppirDoptpAct'] != null &&
                  formData['ppirDoptpAct'].isNotEmpty
              ? DateFormat('yyyy-MM-dd').parse(formData['ppirDoptpAct'])
              : null,
          onDateChanged: (DateTime? date) {
            if (date != null) {
              formData['ppirDoptpAct'] = DateFormat('yyyy-MM-dd').format(date);
            } else {
              formData['ppirDoptpAct'] = null;
            }
          },
        ),
        const SizedBox(height: 16),
        const Text(
          'Actual Area Planted',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          initialValue: formData['ppirAreaAct'] ?? '',
          decoration: const InputDecoration(
            labelText: 'Actual Area',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            formData['ppirAreaAct'] = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid number';
            }
            final number = num.tryParse(value);
            if (number == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        const SizedBox(height: 24),
        const Text(
          'Seed Varieties Planted and Remarks',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: DropdownButtonFormField<String>(
            value: formData['ppirVariety'],
            decoration: const InputDecoration(
              labelText: 'Select the Actual Seed Variety*',
              border: OutlineInputBorder(),
            ),
            items: uniqueSeedsItems,
            isExpanded: true,
            onChanged: (value) {
              if (value != null) {
                formData['ppirVariety'] = value;
              } else {
                formData['ppirVariety'] = null;
              }
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            initialValue: formData['ppirRemarks'] ?? '',
            decoration: const InputDecoration(
              labelText: 'Remarks',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            onChanged: (value) {
              formData['ppirRemarks'] = value;
            },
          ),
        ),
      ],
    );
  }
}
