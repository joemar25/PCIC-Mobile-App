// filename: _task_filter_footer.dart
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

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
    final t = Theme.of(context).extension<CustomThemeExtension>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            'Applied Filter:',
            style:
                TextStyle(fontSize: t?.overline, fontWeight: FontWeight.w600),
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
                  fontSize: t?.overline,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            width: 4.0,
          ),
          Text(
            'Order by:',
            style:
                TextStyle(fontSize: t?.overline, fontWeight: FontWeight.w600),
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
              style: TextStyle(fontSize: t?.overline),
            ),
          ),
        ],
      ),
    );
  }
}
