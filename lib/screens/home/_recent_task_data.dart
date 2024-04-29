import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';

class TaskData extends StatelessWidget {
  final TaskManager task;
  const TaskData({super.key, required this.task});

  String formatDate(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${task.csvData?['serviceGroup']}-${task.ppirInsuranceId}',
              style:
                  const TextStyle(fontSize: 19.2, fontWeight: FontWeight.w600),
            ),
            Text('${task.csvData?['priority']}',
                style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F7D40))),
            Text('Last Access: ${formatDate(task.dateAccess)}',
                style: const TextStyle(
                  fontSize: 13.3,
                  fontWeight: FontWeight.w600,
                ))
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
              const Text(
                'View Task',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13.3),
              )
            ],
          )
        ],
      ),
    );
  }
}
