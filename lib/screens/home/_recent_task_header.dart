import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';

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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${task.csvData?['serviceGroup']} ${task.ppirInsuranceId}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${task.csvData?['priority']}',
                      // 'PPIR INSURANCE ID: ${task.ppirInsuranceId}',
                      style: const TextStyle(
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
