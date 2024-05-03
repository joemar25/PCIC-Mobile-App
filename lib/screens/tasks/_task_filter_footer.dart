import 'package:flutter/material.dart';

class FilterFooter extends StatefulWidget {
  final bool showComplete;
  final String orderBy;
  const FilterFooter(
      {super.key, required this.showComplete, required this.orderBy});

  @override
  State<FilterFooter> createState() => _FilterFooterState();
}

class _FilterFooterState extends State<FilterFooter> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            'Applied Filter:',
          ),
          const SizedBox(
            width: 4.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                color: widget.showComplete
                    ? const Color(0xFF0F7D40)
                    : const Color(0xFFD9F7FA),
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(15.0)),
            child: Text(
              widget.showComplete ? 'Completed' : 'Current',
              style: TextStyle(
                  color: widget.showComplete ? Colors.white : Colors.black,
                  fontSize: 11.11,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            'Order by:',
          ),
          const SizedBox(
            width: 4.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 0.5),
                borderRadius: BorderRadius.circular(15.0)),
            child: Text(
              widget.orderBy,
            ),
          ),
        ],
      ),
    );
  }
}
