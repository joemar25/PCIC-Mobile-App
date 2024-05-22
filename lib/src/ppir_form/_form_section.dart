import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormSection extends StatefulWidget {
  final Map<String, dynamic> formData;
  final List<DropdownMenuItem<int>> uniqueSeedsItems;
  final Map<String, int> seedTitleToIdMap;

  const FormSection({
    super.key,
    required this.formData,
    required this.uniqueSeedsItems,
    required this.seedTitleToIdMap,
  });

  @override
  FormSectionState createState() => FormSectionState();
}

class FormSectionState extends State<FormSection> {
  int? dropdownValue;
  final TextEditingController _ppirNameInsuredController =
      TextEditingController();
  final TextEditingController _ppirNameIuiaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeDropdownValue();
    _initializeTextControllers();
  }

  void _initializeDropdownValue() {
    String? seedTitle = widget.formData['ppirSvpAct']?.trim();
    debugPrint("dropdownValue from form data: $seedTitle");

    if (seedTitle != null && widget.seedTitleToIdMap.containsKey(seedTitle)) {
      dropdownValue = widget.seedTitleToIdMap[seedTitle];
      debugPrint("Dropdown value found in items: $dropdownValue");
    } else {
      dropdownValue = null; // Set to null to show the placeholder
      debugPrint("Dropdown value set to first item: $dropdownValue");
    }

    setState(() {
      widget.formData['ppirSvpAct'] = seedTitle;
    });
  }

  void _initializeTextControllers() {
    _ppirNameInsuredController.text = widget.formData['ppirNameInsured'] ?? '';
    _ppirNameIuiaController.text = widget.formData['ppirNameIuia'] ?? '';
  }

  Future<void> _pickDate(BuildContext context, String key) async {
    DateTime initialDate = DateTime.now();
    if (widget.formData[key] != null && widget.formData[key].isNotEmpty) {
      initialDate = DateTime.parse(widget.formData[key]);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        widget.formData[key] = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<int>(
          decoration: const InputDecoration(
            labelText: 'Seed Variety',
            border: OutlineInputBorder(),
          ),
          value: dropdownValue,
          items: widget.uniqueSeedsItems,
          onChanged: (value) {
            setState(() {
              dropdownValue = value;
              widget.formData['ppirSvpAct'] = widget.seedTitleToIdMap.entries
                  .firstWhere((entry) => entry.value == value)
                  .key;
            });
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.formData['ppirAreaAct'],
          decoration: const InputDecoration(
            labelText: 'Actual Area Planted',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            widget.formData['ppirAreaAct'] = value;
          },
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _pickDate(context, 'ppirDopdsAct'),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Actual Date of Planting (DS)',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: widget.formData['ppirDopdsAct'],
              ),
              onChanged: (value) {
                widget.formData['ppirDopdsAct'] = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _pickDate(context, 'ppirDoptpAct'),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Actual Date of Planting (TP)',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(
                text: widget.formData['ppirDoptpAct'],
              ),
              onChanged: (value) {
                widget.formData['ppirDoptpAct'] = value;
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: widget.formData['ppirRemarks'],
          decoration: const InputDecoration(
            labelText: 'Remarks',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            widget.formData['ppirRemarks'] = value;
          },
        ),
      ],
    );
  }
}
