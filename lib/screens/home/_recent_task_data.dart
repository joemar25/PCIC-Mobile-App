import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';
import 'package:pcic_mobile_app/theme/_theme_extension.dart';

class TaskData extends StatelessWidget {
  final TaskManager task;
  const TaskData({super.key, required this.task});

  String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData t = context.pcicTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${task.csvData?['serviceGroup']}-${task.ppirInsuranceId}',
              style: t.textTheme.bodyLarge,
            ),
            Text('${task.csvData?['priority']}',
                style: t.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: t.primaryColor)), //customize this base on priority
            Text(
              'Last Access: ${formatDate(task.dateAccess)}',
              style: t.textTheme.bodySmall,
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
                style: t.textTheme.bodySmall,
              )
            ],
          )
        ],
      ),
    );
  }
}
