// src/tasks/components/_filter_task.dart
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

class FilterFooter extends StatefulWidget {
  final String filter;
  final String orderBy;
  const FilterFooter({
    super.key,
    required this.filter,
    required this.orderBy,
  });

  @override
  State<FilterFooter> createState() => _FilterFooterState();
}

class _FilterFooterState extends State<FilterFooter> {
  final Map<String, Color> _filterColors = {
    'Ongoing': const Color(0xFF87CEFA), // Light green
    'For Dispatch': const Color(0xFFFF4500), // Amber
    'Completed': const Color(0xFF006400), // Green
  };

  final Map<String, Color> _filterTextColors = {
    'Ongoing': Colors.white,
    'For Dispatch': Colors.white,
    'Completed': Colors.white,
  };

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Text(
            'Applied Filter:',
            style: TextStyle(
                color: Colors.black54,
                fontSize: t?.overline,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: _filterColors[widget.filter],
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              widget.filter,
              style: TextStyle(
                color: _filterTextColors[widget.filter],
                fontSize: 11.24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4.0),
          Text(
            'Order by:',
            style: TextStyle(
                color: Colors.black54,
                fontSize: t?.overline,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: const Color(0xFFD9F7FA),
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              widget.orderBy,
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 11.24,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
