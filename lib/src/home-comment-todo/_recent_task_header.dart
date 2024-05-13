// filename: _recent_task_header.dart
import 'package:flutter/material.dart';
import '../tasks/_control_task.dart';

class RecentTaskHeader extends StatelessWidget {
  final TaskManager task;
  const RecentTaskHeader({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Image.asset(
                  'assets/storage/images/FormImage.png',
                  height: 55,
                  width: 55,
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // '${task.csvData?['serviceGroup']} ${task.ppirInsuranceId}',
                      'aaa',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      // '${task.csvData?['priority']}', // 'PPIR INSURANCE ID: ${task.ppirInsuranceId}',
                      '',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
