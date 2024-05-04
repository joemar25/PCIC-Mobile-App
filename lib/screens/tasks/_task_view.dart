import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/home/_recent_task_data.dart';
import 'package:pcic_mobile_app/screens/home/_search_button.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';
import 'package:pcic_mobile_app/screens/tasks/_task_details.dart';
import 'package:pcic_mobile_app/screens/tasks/_task_filter_button.dart';
import 'package:pcic_mobile_app/screens/tasks/_task_filter_footer.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key, Key? id, required this.tasks});
  final List<TaskManager> tasks;

  @override
  TaskContainerState createState() => TaskContainerState();
}

class TaskContainerState extends State<TaskView> {
  int _hoveredIndex = -1;
  String _sortBy = 'ID';
  bool _showCompleted = false;
  String _searchQuery = '';

  void _updateShowComplete(bool newState) {
    setState(() {
      _showCompleted = newState;
    });
  }

  void _updateSortBy(String newValue) {
    setState(() {
      _sortBy = newValue;
    });
  }

  void _updateSearchQuery(String newValue) {
    setState(() {
      _searchQuery = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sort and filter tasks based on user selection
    List<TaskManager> sortedTasks = _sortTasks(widget.tasks, _sortBy);
    List<TaskManager> filteredTasks = sortedTasks
        .where((task) => _showCompleted ? task.isCompleted : !task.isCompleted)
        .toList();

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  FilterButton(
                    onUpdateState: _updateShowComplete,
                    onUpdateValue: _updateSortBy,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  SearchButton(onUpdateValue: _updateSearchQuery),
                ],
              ),
              FilterFooter(
                showComplete: _showCompleted,
                orderBy: _sortBy,
              )
            ])),

        // _buildButtons(),
        // _buildSortByDropdown(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _refreshTasks,
            child: filteredTasks.isEmpty
                ? const Center(
                    child: Text('No tasks'),
                  )
                : ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final TaskManager task = filteredTasks[index];
                      //Move this validation later
                      String serviceGroup = task.csvData?['serviceGroup'] ?? '';
                      int ppirInsuranceId = task.ppirInsuranceId;

                      bool matchesSearchQuery = _searchQuery.isEmpty ||
                          '$serviceGroup-$ppirInsuranceId'
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());

                      if (!matchesSearchQuery) {
                        return const SizedBox
                            .shrink(); // Skip rendering if task doesn't match search query
                      }

                      return MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = -1),
                          child: GestureDetector(
                            onTap: () => _navigateToTaskDetails(context, task),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 21.0),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.5, color: Colors.black38),
                                      color: _hoveredIndex == index
                                          ? Colors.grey[200]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Color(0xFF0F7D40),
                                            offset: Offset(-5, 5))
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TaskData(task: task),
                                    ],
                                  ),
                                )),
                          ));
                    },
                  ),
          ),
        ),
      ],
    );
  }

  // Widget _buildButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       ElevatedButton(
  //         onPressed: () {
  //           setState(() {
  //             _showCompleted = true;
  //           });
  //         },
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: _showCompleted ? Colors.green : null,
  //         ),
  //         child: const Text('Complete'),
  //       ),
  //       const SizedBox(width: 10),
  //       ElevatedButton(
  //         onPressed: () {
  //           setState(() {
  //             _showCompleted = false;
  //           });
  //         },
  //         style: ElevatedButton.styleFrom(
  //           backgroundColor: !_showCompleted ? Colors.green : null,
  //         ),
  //         child: const Text('Current'),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildSortByDropdown() {
  //   return DropdownButton<String>(
  //     value: _sortBy,
  //     onChanged: (newValue) {
  //       setState(() {
  //         _sortBy = newValue!;
  //       });
  //     },
  //     items: <String>['id', 'dateAdded', 'dateAccess']
  //         .map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text('Sort by $value'),
  //       );
  //     }).toList(),
  //   );
  // }

  List<TaskManager> _sortTasks(List<TaskManager> tasks, String sortBy) {
    switch (sortBy) {
      case 'ID':
        return tasks..sort((a, b) => a.id.compareTo(b.id));
      case 'Date Added':
        return tasks..sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
      case 'Date Accessed':
        return tasks..sort((a, b) => a.dateAccess.compareTo(b.dateAccess));
      default:
        return tasks;
    }
  }

  Future<void> _refreshTasks() async {
    // Ideally, you fetch tasks from your backend or local database
    await Future.delayed(
        const Duration(seconds: 1)); // Simulating network delay
    setState(() {
      // Refresh logic or state update after fetching tasks
    });
  }

  void _navigateToTaskDetails(BuildContext context, TaskManager task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
  }
}
