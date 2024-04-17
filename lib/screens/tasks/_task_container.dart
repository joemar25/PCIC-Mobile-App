import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:pcic_mobile_app/screens/tasks/_task_details.dart';
import 'package:pcic_mobile_app/screens/home/_recent_task_header.dart';
import 'package:pcic_mobile_app/screens/home/_recent_task_footer.dart';

class TaskContainer extends StatefulWidget {
  const TaskContainer({super.key, required this.tasks});
  final List<Task> tasks;

  @override
  _TaskContainerState createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  int _hoveredIndex = -1;
  String _sortBy = 'id';
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    // Sort tasks based on the selected sorting option
    List<Task> sortedTasks = _sortTasks(widget.tasks, _sortBy);

    // Filter tasks based on completion status
    List<Task> filteredTasks = _showCompleted
        ? sortedTasks.where((task) => task.isCompleted).toList()
        : sortedTasks.where((task) => !task.isCompleted).toList();

    return Column(
      children: [
        _buildButtons(),
        _buildSortByDropdown(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final Task task = filteredTasks[index];
              return MouseRegion(
                onEnter: (_) => setState(() => _hoveredIndex = index),
                onExit: (_) => setState(() => _hoveredIndex = -1),
                child: GestureDetector(
                  onTap: () => _navigateToTaskDetails(context, task),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: _hoveredIndex == index
                          ? Colors.grey[200]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RecentTaskHeader(task: task),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Divider(
                            color: const Color(0xFF7C7C7C).withOpacity(0.1),
                          ),
                        ),
                        RecentTaskFooter(task: task),
                      ],
                    ),
                  ),
                ),
              );
            },
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

  List<Task> _sortTasks(List<Task> tasks, String sortBy) {
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

  void _navigateToTaskDetails(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailsPage(task: task)),
    );
  }
}
