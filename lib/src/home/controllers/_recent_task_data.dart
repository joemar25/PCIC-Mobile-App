import 'package:intl/intl.dart';
import '../../theme/_theme.dart';
import 'package:flutter/material.dart';
import '../../tasks/controllers/task_manager.dart';

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
    // final captionFontSize = isPortrait ? 6.0 : t?.caption ?? 14.0;
    final heheFontSize = isPortrait ? 10.0 : t?.caption ?? 14.0;
    // final overlineFontSize = isPortrait ? 9.0 : t?.overline ?? 12.0;
    final statusFontSize = isPortrait ? 10.0 : t?.caption ?? 14.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<List<dynamic>>(
                  future: Future.wait([
                    task.farmerName,
                    task.north,
                    task.south,
                    task.east,
                    task.west,
                    task.address,
                    task.assignmentID,
                  ]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      );
                    }

                    if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final farmerName = data[0] ?? 'Unknown Farmer';
                      final north = data[1] ?? 'N/A';
                      final south = data[2] ?? 'N/A';
                      final east = data[3] ?? 'N/A';
                      final west = data[4] ?? 'N/A';
                      final address = data[5] ?? 'N/A';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            farmerName,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 45,
                            child: Text(
                              '(N: $north, S: $south, E: $east, W: $west)',
                              style: TextStyle(
                                fontSize: heheFontSize,
                              ),
                            ),
                          ),
                          Text(
                            'Address: $address',
                            style: TextStyle(
                              fontSize: heheFontSize,
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
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
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
                          fontSize: statusFontSize,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                    return const SizedBox();
                  },
                ),
                FutureBuilder<int?>(
                  future: task.assignmentID,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final assignmentID = snapshot.data!;
                      return Text(
                        'PPIR Assignment ID: ${assignmentID.toString()}',
                        style: TextStyle(
                          fontSize: statusFontSize,
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
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
                          fontSize: statusFontSize,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
