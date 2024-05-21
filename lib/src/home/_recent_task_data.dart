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
            FutureBuilder<List<String?>>(
              future: Future.wait([
                task.farmerName,
                task.north,
                task.south,
                task.east,
                task.west
              ]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: t?.title ?? 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }

                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final farmerName = data[0] ?? 'Unknown Farmer';
                  final north = data[1] ?? 'N/A';
                  final south = data[2] ?? 'N/A';
                  final east = data[3] ?? 'N/A';
                  final west = data[4] ?? 'N/A';

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmerName,
                        style: TextStyle(
                          fontSize: t?.title ?? 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(N: $north, S: $south, E: $east, W: $west)',
                        style: TextStyle(
                          fontSize: t?.caption ?? 12.0,
                        ),
                      ),
                    ],
                  );
                }

                return Text(
                  'Error loading data',
                  style: TextStyle(
                    fontSize: t?.title ?? 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
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
            ],
          ),
        ],
      ),
    );
  }
}
