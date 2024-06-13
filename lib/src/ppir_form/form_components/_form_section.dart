import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class FormSection extends StatefulWidget {
  final Map<String, dynamic> formData;
  final List<DropdownMenuItem<int>> uniqueSeedsItems;
  final Map<String, int> seedTitleToIdMap;
  final bool isSubmitting;
  final int? selectedSeedId;
  final ValueChanged<int?> onSelectedSeedIdChanged;

  const FormSection({
    super.key,
    required this.formData,
    required this.uniqueSeedsItems,
    required this.seedTitleToIdMap,
    required this.isSubmitting,
    required this.selectedSeedId,
    required this.onSelectedSeedIdChanged,
  });

  @override
  FormSectionState createState() => FormSectionState();
}

class FormSectionState extends State<FormSection> {
  final TextEditingController _ppirNameInsuredController =
      TextEditingController();
  final TextEditingController _ppirNameIuiaController = TextEditingController();
  final TextEditingController _ppirAreaController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _ppirDopdsActController = TextEditingController();
  final TextEditingController _ppirDoptpActController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeTextControllers();
    _setupListeners();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDropdownValue();
    });
  }

  void _initializeDropdownValue() {
    String? seedTitle = widget.formData['ppirVariety']?.trim();
    if (seedTitle != null && widget.seedTitleToIdMap.containsKey(seedTitle)) {
      widget.onSelectedSeedIdChanged(widget.seedTitleToIdMap[seedTitle]);
    } else {
      widget.onSelectedSeedIdChanged(null);
    }

    setState(() {
      widget.formData['ppirVariety'] = seedTitle;
    });
  }

  void _initializeTextControllers() {
    _ppirNameInsuredController.text = widget.formData['ppirNameInsured'] ?? '';
    _ppirNameIuiaController.text = widget.formData['ppirNameIuia'] ?? '';
    _ppirAreaController.text = widget.formData['ppirAreaAct'] ?? '';
    _remarksController.text = widget.formData['ppirRemarks'] ?? '';
    _ppirDopdsActController.text = widget.formData['ppirDopdsAct'] ?? '';
    _ppirDoptpActController.text = widget.formData['ppirDoptpAct'] ?? '';
  }

  void _setupListeners() {
    _ppirNameInsuredController.addListener(() {
      setState(() {
        widget.formData['ppirNameInsured'] = _ppirNameInsuredController.text;
      });
    });
    _ppirNameIuiaController.addListener(() {
      setState(() {
        widget.formData['ppirNameIuia'] = _ppirNameIuiaController.text;
      });
    });
    _ppirAreaController.addListener(() {
      setState(() {
        widget.formData['ppirAreaAct'] = _ppirAreaController.text;
      });
    });
    _remarksController.addListener(() {
      setState(() {
        widget.formData['ppirRemarks'] = _remarksController.text;
      });
    });
    _ppirDopdsActController.addListener(() {
      setState(() {
        widget.formData['ppirDopdsAct'] = _ppirDopdsActController.text;
      });
    });
    _ppirDoptpActController.addListener(() {
      setState(() {
        widget.formData['ppirDoptpAct'] = _ppirDoptpActController.text;
      });
    });
  }

  Future<void> _pickDate(BuildContext context, String key) async {
    DateTime initialDate = DateTime.now();
    if (widget.formData[key] != null && widget.formData[key].isNotEmpty) {
      try {
        initialDate = DateFormat('MM-dd-yyyy').parse(widget.formData[key]);
      } catch (e) {
        initialDate = DateTime.now();
      }
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != initialDate) {
      setState(() {
        widget.formData[key] = DateFormat('MM-dd-yyyy').format(picked);
        if (key == 'ppirDopdsAct') {
          _ppirDopdsActController.text =
              DateFormat('MM-dd-yyyy').format(picked);
        }
        if (key == 'ppirDoptpAct') {
          _ppirDoptpActController.text =
              DateFormat('MM-dd-yyyy').format(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seed Variety',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey),
                ),
                child: DropdownButtonFormField<int>(
                  isExpanded: true,
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  value: widget.selectedSeedId,
                  items: widget.uniqueSeedsItems,
                  onChanged: (value) {
                    setState(() {
                      widget.onSelectedSeedIdChanged(value);
                      widget.formData['ppirVariety'] = value != null
                          ? widget.seedTitleToIdMap.entries
                              .firstWhere((entry) => entry.value == value)
                              .key
                          : null;
                    });
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a seed variety';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ppirAreaController,
                decoration: InputDecoration(
                  labelText: 'Actual Area Planted',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    widget.formData['ppirAreaAct'] = value;
                  });
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _pickDate(context, 'ppirDopdsAct'),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Actual Date of Planting (DS)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    controller: _ppirDopdsActController,
                    readOnly: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _pickDate(context, 'ppirDoptpAct'),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Actual Date of Planting (TS)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    controller: _ppirDoptpActController,
                    readOnly: true,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _remarksController,
                decoration: InputDecoration(
                  labelText: 'Remarks',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 5,
                onChanged: (value) {
                  widget.formData['ppirRemarks'] = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || _remarksController.text.trim().isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  bool validate() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    debugPrint('Form Section Validation: $isValid');
    return isValid;
  }
}
