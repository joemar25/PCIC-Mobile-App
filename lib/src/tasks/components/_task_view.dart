// import '../controllers/task_manager.dart';
// import '_task_details.dart';
// import '_task_filter_button.dart';
// import '_task_filter_footer.dart';
// import '../../home/components/_search_button.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:flutter/material.dart';
// import '../../home/controllers/_recent_task_data.dart';
// import 'package:lottie/lottie.dart';

// class TaskView extends StatefulWidget {
//   const TaskView({super.key, required this.tasks, required this.initialFilter});

//   final List<TaskManager> tasks;
//   final String initialFilter;

//   @override
//   TaskContainerState createState() => TaskContainerState();
// }

// class TaskContainerState extends State<TaskView> {
//   int _hoveredIndex = -1;
//   String _sortBy = 'Date Added';
//   late String _statusFilter;
//   String _searchQuery = '';
//   bool _isLoading = false;
//   List<TaskManager> _sortedTasks = [];

//   @override
//   void initState() {
//     super.initState();
//     _statusFilter = widget.initialFilter;
//     _sortTasks(_sortBy);
//   }

//   void _updateStatusFilter(String newValue) {
//     setState(() {
//       _statusFilter = newValue;
//     });
//     _sortTasks(_sortBy);
//   }

//   void _updateSortBy(String newValue) {
//     setState(() {
//       _sortBy = newValue;
//     });
//     _sortTasks(newValue);
//   }

//   void _updateSearchQuery(String newValue) {
//     setState(() {
//       _searchQuery = newValue;
//     });
//   }

//   Future<void> _sortTasks(String sortBy) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       List<TaskManager> sortedTasks;

//       if (_statusFilter == 'Ongoing') {
//         sortedTasks = await TaskManager.getTasksByStatus('Ongoing');
//       } else if (_statusFilter == 'For Dispatch') {
//         sortedTasks = await TaskManager.getTasksByStatus('For Dispatch');
//       } else if (_statusFilter == 'Completed') {
//         sortedTasks = await TaskManager.getTasksByStatus('Completed');
//       } else {
//         sortedTasks = await TaskManager.getAllTasks();
//       }

//       setState(() {
//         _sortedTasks = sortedTasks;
//       });

//       debugPrint('Sorted Tasks: ${_sortedTasks.length}'); // Debugging statement
//     } catch (error) {
//       debugPrint("Error sorting tasks: $error");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }
//   // Color getStatusColor(String? status) {
//   //   switch (status) {
//   //     case 'For Dispatch':
//   //       return const Color(0xFFFF4500); // Red
//   //     case 'Ongoing':
//   //       return const Color(0xFF87CEFA); // Light Blue
//   //     case 'Completed':
//   //       return const Color(0xFF006400); // Dark Green
//   //     default:
//   //       return Colors.grey;
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     List<TaskManager> tasksToDisplay = _isLoading ? [] : _sortedTasks;

//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 21.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FilterButton(
//                       onUpdateState: _updateStatusFilter,
//                       onUpdateValue: _updateSortBy,
//                     ),
//                     const SizedBox(width: 8.0),
//                     Expanded(
//                       child: SearchButton(
//                         searchQuery: _searchQuery,
//                         onUpdateValue: _updateSearchQuery,
//                       ),
//                     ),
//                   ],
//                 ),
//                 FilterFooter(
//                   filter: _statusFilter,
//                   orderBy: _sortBy,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _refreshTasks,
//               child: tasksToDisplay.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Lottie.asset(
//                             'assets/animations/emptybox.json',
//                             width: 200,
//                             height: 200,
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'No tasks',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: tasksToDisplay.length,
//                       itemBuilder: (context, index) {
//                         final task = tasksToDisplay[index];

//                         bool matchesSearchQuery = _searchQuery.isEmpty ||
//                             task.taskId
//                                 .toLowerCase()
//                                 .contains(_searchQuery.toLowerCase());

//                         if (!matchesSearchQuery) {
//                           return const SizedBox.shrink();
//                         }

//                         return MouseRegion(
//                           onEnter: (_) => setState(() => _hoveredIndex = index),
//                           onExit: (_) => setState(() => _hoveredIndex = -1),
//                           child: GestureDetector(
//                             onTap: () => _navigateToTaskDetails(context, task),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 21.0),
//                               child: FutureBuilder<String?>(
//                                 future: task.status,
//                                 builder: (context, snapshot) {
//                                   // final statusColor =
//                                   //     getStatusColor(snapshot.data);
//                                   return Container(
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 8.0),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           width: 0.2, color: Colors.grey),
//                                       color: _hoveredIndex == index
//                                           ? Colors.grey[200]
//                                           : Colors.white,
//                                       borderRadius: BorderRadius.circular(15.0),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.4),
//                                           blurRadius: 1,
//                                           spreadRadius: 1,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         FutureBuilder(
//                                           future: Future.delayed(
//                                               const Duration(seconds: 1)),
//                                           builder: (context, snapshot) {
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.done) {
//                                               return TaskData(task: task);
//                                             } else {
//                                               return Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                   horizontal: 16.0,
//                                                   vertical: 16.0,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           8.0),
//                                                 ),
//                                                 child: Shimmer.fromColors(
//                                                   baseColor: Colors.grey[300]!,
//                                                   highlightColor:
//                                                       Colors.grey[100]!,
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Container(
//                                                             height: 16,
//                                                             width: 150,
//                                                             color: Colors.white,
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 8),
//                                                           Container(
//                                                             height: 12,
//                                                             width: 120,
//                                                             color: Colors.white,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .end,
//                                                         children: [
//                                                           Container(
//                                                             height: 16,
//                                                             width: 60,
//                                                             color: Colors.white,
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 8),
//                                                           Container(
//                                                             height: 12,
//                                                             width: 100,
//                                                             color: Colors.white,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _refreshTasks() async {
//     await Future.delayed(const Duration(seconds: 1));
//     _sortTasks(_sortBy);
//   }

//   void _navigateToTaskDetails(BuildContext context, TaskManager task) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
//     );
//   }
// }

// import '../controllers/task_manager.dart';
// import '_task_details.dart';
// import '_task_filter_button.dart';
// import '_task_filter_footer.dart';
// import '../../home/components/_search_button.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:flutter/material.dart';
// import '../../home/controllers/_recent_task_data.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class TaskView extends StatefulWidget {
//   const TaskView({super.key, required this.tasks, required this.initialFilter});

//   final List<TaskManager> tasks;
//   final String initialFilter;

//   @override
//   TaskContainerState createState() => TaskContainerState();
// }

// class TaskContainerState extends State<TaskView> {
//   int _hoveredIndex = -1;
//   String _sortBy = 'Date Added';
//   late String _statusFilter;
//   String _searchQuery = '';
//   bool _isLoading = false;
//   List<TaskManager> _sortedTasks = [];

//   @override
//   void initState() {
//     super.initState();
//     _statusFilter = widget.initialFilter;
//     _sortTasks(_sortBy);
//     _updateTaskCounts();
//   }

//   void _updateStatusFilter(String newValue) {
//     setState(() {
//       _statusFilter = newValue;
//     });
//     _sortTasks(_sortBy);
//   }

//   void _updateSortBy(String newValue) {
//     setState(() {
//       _sortBy = newValue;
//     });
//     _sortTasks(newValue);
//   }

//   void _updateSearchQuery(String newValue) {
//     setState(() {
//       _searchQuery = newValue;
//     });
//   }

//   Future<void> _sortTasks(String sortBy) async {
//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       List<TaskManager> sortedTasks;

//       if (_statusFilter == 'Ongoing') {
//         sortedTasks = await TaskManager.getTasksByStatus('Ongoing');
//       } else if (_statusFilter == 'For Dispatch') {
//         sortedTasks = await TaskManager.getTasksByStatus('For Dispatch');
//       } else if (_statusFilter == 'Completed') {
//         sortedTasks = await TaskManager.getTasksByStatus('Completed');
//       } else {
//         sortedTasks = await TaskManager.getAllTasks();
//       }

//       setState(() {
//         _sortedTasks = sortedTasks;
//       });

//       debugPrint('Sorted Tasks: ${_sortedTasks.length}'); // Debugging statement
//     } catch (error) {
//       debugPrint("Error sorting tasks: $error");
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   Future<void> _updateTaskCounts() async {
//     final forDispatchCount =
//         (await TaskManager.getTasksByStatus('For Dispatch')).length;
//     final ongoingCount = (await TaskManager.getTasksByStatus('Ongoing')).length;
//     final tasksCount = forDispatchCount + ongoingCount;

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('tasksCount', tasksCount);

//     print('Tasks Count: $tasksCount'); // Print the count to the console
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<TaskManager> tasksToDisplay = _isLoading ? [] : _sortedTasks;

//     return Scaffold(
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 21.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     FilterButton(
//                       onUpdateState: _updateStatusFilter,
//                       onUpdateValue: _updateSortBy,
//                     ),
//                     const SizedBox(width: 8.0),
//                     Expanded(
//                       child: SearchButton(
//                         searchQuery: _searchQuery,
//                         onUpdateValue: _updateSearchQuery,
//                       ),
//                     ),
//                   ],
//                 ),
//                 FilterFooter(
//                   filter: _statusFilter,
//                   orderBy: _sortBy,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: RefreshIndicator(
//               onRefresh: _refreshTasks,
//               child: tasksToDisplay.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Lottie.asset(
//                             'assets/animations/emptybox.json',
//                             width: 200,
//                             height: 200,
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'No tasks',
//                             style: TextStyle(color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: tasksToDisplay.length,
//                       itemBuilder: (context, index) {
//                         final task = tasksToDisplay[index];

//                         bool matchesSearchQuery = _searchQuery.isEmpty ||
//                             task.taskId
//                                 .toLowerCase()
//                                 .contains(_searchQuery.toLowerCase());

//                         if (!matchesSearchQuery) {
//                           return const SizedBox.shrink();
//                         }

//                         return MouseRegion(
//                           onEnter: (_) => setState(() => _hoveredIndex = index),
//                           onExit: (_) => setState(() => _hoveredIndex = -1),
//                           child: GestureDetector(
//                             onTap: () => _navigateToTaskDetails(context, task),
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 21.0),
//                               child: FutureBuilder<String?>(
//                                 future: task.status,
//                                 builder: (context, snapshot) {
//                                   // final statusColor =
//                                   //     getStatusColor(snapshot.data);
//                                   return Container(
//                                     margin: const EdgeInsets.symmetric(
//                                         vertical: 8.0),
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           width: 0.2, color: Colors.grey),
//                                       color: _hoveredIndex == index
//                                           ? Colors.grey[200]
//                                           : Colors.white,
//                                       borderRadius: BorderRadius.circular(15.0),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.grey.withOpacity(0.4),
//                                           blurRadius: 1,
//                                           spreadRadius: 1,
//                                           offset: const Offset(0, 2),
//                                         ),
//                                       ],
//                                     ),
//                                     child: Column(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.center,
//                                       children: [
//                                         FutureBuilder(
//                                           future: Future.delayed(
//                                               const Duration(seconds: 1)),
//                                           builder: (context, snapshot) {
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.done) {
//                                               return TaskData(task: task);
//                                             } else {
//                                               return Container(
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                   horizontal: 16.0,
//                                                   vertical: 16.0,
//                                                 ),
//                                                 decoration: BoxDecoration(
//                                                   borderRadius:
//                                                       BorderRadius.circular(
//                                                           8.0),
//                                                 ),
//                                                 child: Shimmer.fromColors(
//                                                   baseColor: Colors.grey[300]!,
//                                                   highlightColor:
//                                                       Colors.grey[100]!,
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           Container(
//                                                             height: 16,
//                                                             width: 150,
//                                                             color: Colors.white,
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 8),
//                                                           Container(
//                                                             height: 12,
//                                                             width: 120,
//                                                             color: Colors.white,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .end,
//                                                         children: [
//                                                           Container(
//                                                             height: 16,
//                                                             width: 60,
//                                                             color: Colors.white,
//                                                           ),
//                                                           const SizedBox(
//                                                               height: 8),
//                                                           Container(
//                                                             height: 12,
//                                                             width: 100,
//                                                             color: Colors.white,
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               );
//                                             }
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _refreshTasks() async {
//     await Future.delayed(const Duration(seconds: 1));
//     _sortTasks(_sortBy);
//     _updateTaskCounts();
//   }

//   void _navigateToTaskDetails(BuildContext context, TaskManager task) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
//     );
//   }
// }

import '../controllers/task_manager.dart';
import '_task_details.dart';
import '_task_filter_button.dart';
import '_task_filter_footer.dart';
import '../../home/components/_search_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';
import '../../home/controllers/_recent_task_data.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key, required this.tasks, required this.initialFilter});

  final List<TaskManager> tasks;
  final String initialFilter;

  @override
  TaskContainerState createState() => TaskContainerState();
}

class TaskContainerState extends State<TaskView> {
  int _hoveredIndex = -1;
  String _sortBy = 'Date Added';
  late String _statusFilter;
  String _searchQuery = '';
  bool _isLoading = false;
  List<TaskManager> _sortedTasks = [];

  @override
  void initState() {
    super.initState();
    _statusFilter = widget.initialFilter;
    _sortTasks(_sortBy);
    _updateTaskCounts();
  }

  void _updateStatusFilter(String newValue) {
    setState(() {
      _statusFilter = newValue;
    });
    _sortTasks(_sortBy);
  }

  void _updateSortBy(String newValue) {
    setState(() {
      _sortBy = newValue;
    });
    _sortTasks(newValue);
  }

  void _updateSearchQuery(String newValue) {
    setState(() {
      _searchQuery = newValue;
    });
  }

  Future<void> _sortTasks(String sortBy) async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<TaskManager> sortedTasks;

      if (_statusFilter == 'Ongoing') {
        sortedTasks = await TaskManager.getTasksByStatus('Ongoing');
      } else if (_statusFilter == 'For Dispatch') {
        sortedTasks = await TaskManager.getTasksByStatus('For Dispatch');
      } else if (_statusFilter == 'Completed') {
        sortedTasks = await TaskManager.getTasksByStatus('Completed');
      } else {
        sortedTasks = await TaskManager.getAllTasks();
      }

      setState(() {
        _sortedTasks = sortedTasks;
      });

      // debugPrint('Sorted Tasks: ${_sortedTasks.length}');
    } catch (error) {
      // debugPrint("Error sorting tasks: $error");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateTaskCounts() async {
    try {
      final forDispatchCount =
          (await TaskManager.getTasksByStatus('For Dispatch')).length;
      final ongoingCount =
          (await TaskManager.getTasksByStatus('Ongoing')).length;
      final tasksCount = forDispatchCount + ongoingCount;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('tasksCount', tasksCount);

      // debugPrint('Tasks Count: $tasksCount');
    } catch (e) {
      // debugPrint("Error updating task counts: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TaskManager> tasksToDisplay = _isLoading ? [] : _sortedTasks;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 21.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FilterButton(
                      onUpdateState: _updateStatusFilter,
                      onUpdateValue: _updateSortBy,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: SearchButton(
                        searchQuery: _searchQuery,
                        onUpdateValue: _updateSearchQuery,
                      ),
                    ),
                  ],
                ),
                FilterFooter(
                  filter: _statusFilter,
                  orderBy: _sortBy,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshTasks,
              child: tasksToDisplay.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/animations/emptybox.json',
                            width: 200,
                            height: 200,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No tasks',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: tasksToDisplay.length,
                      itemBuilder: (context, index) {
                        final task = tasksToDisplay[index];

                        bool matchesSearchQuery = _searchQuery.isEmpty ||
                            task.taskId
                                .toLowerCase()
                                .contains(_searchQuery.toLowerCase());

                        if (!matchesSearchQuery) {
                          return const SizedBox.shrink();
                        }

                        return MouseRegion(
                          onEnter: (_) => setState(() => _hoveredIndex = index),
                          onExit: (_) => setState(() => _hoveredIndex = -1),
                          child: GestureDetector(
                            onTap: () => _navigateToTaskDetails(context, task),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 21.0),
                              child: FutureBuilder<String?>(
                                future: task.status,
                                builder: (context, snapshot) {
                                  // final statusColor =
                                  //     getStatusColor(snapshot.data);
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 0.2, color: Colors.grey),
                                      color: _hoveredIndex == index
                                          ? Colors.grey[200]
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.4),
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FutureBuilder(
                                          future: Future.delayed(
                                              const Duration(seconds: 1)),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.done) {
                                              return TaskData(task: task);
                                            } else {
                                              return Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 16.0,
                                                  vertical: 16.0,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                child: Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            height: 16,
                                                            width: 150,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Container(
                                                            height: 12,
                                                            width: 120,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            height: 16,
                                                            width: 60,
                                                            color: Colors.white,
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Container(
                                                            height: 12,
                                                            width: 100,
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    _sortTasks(_sortBy);
    _updateTaskCounts();
  }

  void _navigateToTaskDetails(BuildContext context, TaskManager task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
  }
}
