import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';

class RecentTaskFooter extends StatelessWidget {
  final Task task;

  const RecentTaskFooter({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Align items symmetrically
        children: [
          _buildDateInfo('Date Added', task.dateAdded, const Color(0xFFC5C23F)),
          _buildDateInfo(
              'Date Access', task.dateAccess, const Color(0xFF45C53F)),
        ],
      ),
    );
  }

  Widget _buildDateInfo(String label, DateTime date, Color color) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          color: color,
        ),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(color: color),
            ),
            Text(
              date
                  .toString()
                  .substring(0, 10), // Display date with YYYY-MM-DD format
              style: TextStyle(color: color),
            ),
          ],
        ),
      ],
    );
  }
}
