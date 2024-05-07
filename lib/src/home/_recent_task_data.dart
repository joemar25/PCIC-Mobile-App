// filename: _recent_task_data.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../theme/_theme.dart';
import '../tasks/_control_task.dart';

class TaskData extends StatelessWidget {
  final TaskManager task;
  const TaskData({super.key, required this.task});

  String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${task.csvData?['serviceGroup']}-${task.ppirInsuranceId}',
              style: TextStyle(
                  fontSize: t?.title ?? 16.0, fontWeight: FontWeight.bold),
            ),
            Text(
              '${task.csvData?['priority']}',
              style: TextStyle(
                  fontSize: t?.caption ?? 12.0,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F7D40)),
            ), //customize this base on priority
            Text(
              'Last Access: ${formatDate(task.dateAccess)}',
              style: TextStyle(
                fontSize: t?.overline ?? 10.0,
              ),
            )
          ]),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/storage/images/fileopen.svg',
                colorFilter:
                    const ColorFilter.mode(Color(0xFF0F7D40), BlendMode.srcIn),
                height: 35,
                width: 35,
              ),
              Text(
                'View Task',
                style: TextStyle(
                  fontSize: t?.overline ?? 10.0,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}