// filename: home/_recent_task_container.dart
import '../theme/_theme.dart';
import 'package:intl/intl.dart';
import '../tasks/_control_task.dart';
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

  Color getStatusColor(String status) {
    switch (status) {
      case 'For Dispatch':
        return const Color(0xFFFF4500); // Red
      case 'Ongoing':
        return const Color(0xFF87CEFA); // Light Blue
      case 'Completed':
        return const Color(0xFF006400); // Dark Green
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<CustomThemeExtension>();
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    final titleFontSize = isPortrait ? 12.0 : t?.title ?? 18.0;
    final captionFontSize = isPortrait ? 6.0 : t?.caption ?? 14.0;
    final overlineFontSize = isPortrait ? 6.0 : t?.overline ?? 12.0;

    // Updated statusFontSize
    final statusFontSize = isPortrait ? 9.0 : t?.caption ?? 14.0;

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
                      fontSize: titleFontSize,
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
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(N: $north, S: $south, E: $east, W: $west)',
                        style: TextStyle(
                          fontSize: captionFontSize,
                        ),
                      ),
                    ],
                  );
                }

                return Text(
                  'Error loading data',
                  style: TextStyle(
                    fontSize: titleFontSize,
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
                  if (snapshot.hasData) {
                    final status = snapshot.data!;
                    final statusColor = getStatusColor(status);
                    return Text(
                      status,
                      style: TextStyle(
                        fontSize:
                            statusFontSize, // Updated font size for status
                        fontWeight: FontWeight.w600,
                        color: statusColor,
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
                        fontSize: overlineFontSize,
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
