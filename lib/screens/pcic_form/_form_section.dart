import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './_form_field.dart' as form_field;
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
        const SizedBox(height: 24),
        const Text(
          'Seed Varieties Planted and Remarks',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: formData['ppirVariety'],
          decoration: const InputDecoration(
            labelText: 'Select the Actual Seed Variety*',
          ),
          items: uniqueSeedsItems,
          onChanged: (value) {
            if (value != null) {
              formData['ppirVariety'] = value;
            } else {
              formData['ppirVariety'] = null;
            }
          },
        ),
        const SizedBox(height: 16),
        form_field.FormField(
          labelText: 'Remarks',
          initialValue: formData['ppirRemarks'],
          maxLines: 3,
        ),
      ],
    );
  }
}
