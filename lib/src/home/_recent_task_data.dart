// filename: home/_recent_task_container.dart
import '../theme/_theme.dart';
import 'package:intl/intl.dart';
import '../tasks/_control_task.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class TaskData extends StatelessWidget {
  final TaskManager task;
  const TaskData({super.key, required this.task});

  String formatDate(DateTime? date) {
    if (date != null) {
      return DateFormat('MMMM d, y').format(date);
    }
    return '';
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
            FutureBuilder<String?>(
              future: task.taskManagerNumber,
              builder: (context, snapshot) {
                String taskType = task.type;
                String formattedTaskType = taskType.length > 4
                    ? taskType.substring(taskType.length - 4)
                    : taskType;
                if (snapshot.hasData) {
                  return Text(
                    '$formattedTaskType-${snapshot.data}', // this gets the task number
                    style: TextStyle(
                      fontSize: t?.title ?? 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
                return Text(
                  '$formattedTaskType-Task Number',
                  style: TextStyle(
                    fontSize: t?.title ?? 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
            FutureBuilder<String?>(
              future: task.status,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != 'Completed') {
                  return Text(
                    snapshot.data!,
                    style: TextStyle(
                      fontSize: t?.caption ?? 12.0,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F7D40),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            FutureBuilder<DateTime?>(
              future: task.dateAccess,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Last Access: ${formatDate(snapshot.data)}',
                    style: TextStyle(
                      fontSize: t?.overline ?? 10.0,
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
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
              ),
            ],
          ),
        ],
      ),
    );
  }
}
