import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pcic_mobile_app/screens/home/_recent_task_data.dart';
import 'package:pcic_mobile_app/screens/tasks/_control_task.dart';
import 'package:pcic_mobile_app/screens/tasks/_task_details.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key, Key? id, required this.tasks});
  final List<TaskManager> tasks;

  @override
  TaskContainerState createState() => TaskContainerState();
}

class TaskContainerState extends State<TaskView> {
  int _hoveredIndex = -1;
  String _sortBy = 'id';
  bool _showCompleted = false;

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
            child: SizedBox(
              height: 100,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showBottomSheet(
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(15.0),
                                        topRight: Radius.circular(15.0))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 21.0, vertical: 10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Filter By:',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: SvgPicture.asset(
                                                  'assets/storage/images/close.svg'))
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _showCompleted = true;
                                                Navigator.pop(context);
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              // padding: EdgeInsets.zero,
                                              // foregroundColor: Colors.black,
                                              backgroundColor:
                                                  const Color(0xFFD2FFCB),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                  style: BorderStyle.solid,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            child: const Text(
                                              'Completed Task',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.11,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                _showCompleted = false;
                                                Navigator.pop(context);
                                              });
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFD9F7FA),
                                              // foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                    style: BorderStyle.solid,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                            ),
                                            child: const Text(
                                              'Current Task',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.11,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Text('Sort By:',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              // Add your button action logic here
                                            },
                                            style: TextButton.styleFrom(
                                              // padding: EdgeInsets.zero,
                                              // foregroundColor: Colors.black,
                                              backgroundColor:
                                                  const Color(0xFFD2FFCB),
                                              shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                  color: Colors.black,
                                                  width: 1.0,
                                                  style: BorderStyle.solid,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                            ),
                                            child: const Text(
                                              'ID',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.11,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Add your button action logic here
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFD9F7FA),
                                              // foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                    style: BorderStyle.solid,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                            ),
                                            child: const Text(
                                              'Date Added',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.11,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              // Add your button action logic here
                                            },
                                            style: TextButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFFD9F7FA),
                                              // foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                    color: Colors.black,
                                                    width: 1.0,
                                                    style: BorderStyle.solid,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0)),
                                            ),
                                            child: const Text(
                                              'Date Access',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.11,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ));
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(45, 45),
                      padding: EdgeInsets.zero, // Remove default padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: const BorderSide(
                          color: Colors.black, // Set the border color
                          width: 1.0, // Set the border width
                        ),
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/storage/images/filter.svg',
                      height: 35,
                      width: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                      child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    height: 45,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Task',
                        border: InputBorder.none,
                        suffixIcon: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SvgPicture.asset(
                                'assets/storage/images/search.svg')),

                        // contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ))
                ],
              ),
            )

            // child: Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //       width: 45,
            //       height: 45,
            //       decoration: BoxDecoration(border: Border.all()),
            //     )
            //   ],
            // ),
            ),

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
                    // shrinkWrap: true,
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final TaskManager task = filteredTasks[index];
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
                                      border: Border.all(),
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
                                    children: [TaskData(task: task)],
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

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showCompleted = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _showCompleted ? Colors.green : null,
          ),
          child: const Text('Complete'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showCompleted = false;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: !_showCompleted ? Colors.green : null,
          ),
          child: const Text('Current'),
        ),
      ],
    );
  }

  Widget _buildSortByDropdown() {
    return DropdownButton<String>(
      value: _sortBy,
      onChanged: (newValue) {
        setState(() {
          _sortBy = newValue!;
        });
      },
      items: <String>['id', 'dateAdded', 'dateAccess']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text('Sort by $value'),
        );
      }).toList(),
    );
  }

  List<TaskManager> _sortTasks(List<TaskManager> tasks, String sortBy) {
    switch (sortBy) {
      case 'id':
        return tasks..sort((a, b) => a.id.compareTo(b.id));
      case 'dateAdded':
        return tasks..sort((a, b) => a.dateAdded.compareTo(b.dateAdded));
      case 'dateAccess':
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
