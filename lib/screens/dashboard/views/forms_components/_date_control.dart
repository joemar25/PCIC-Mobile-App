import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  final String labelText;
  final DateTime? initialDate;
  final ValueChanged<DateTime?> onDateChanged;

  const DateInputField({
    super.key,
    required this.labelText,
    this.initialDate,
    required this.onDateChanged,
  });

  @override
  DateInputFieldState createState() => DateInputFieldState();
}

class DateInputFieldState extends State<DateInputField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: widget.labelText,
            border: const OutlineInputBorder(),
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          controller: TextEditingController(
            text: _selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                : null,
          ),
        ),
      ),
    );
  }
}
