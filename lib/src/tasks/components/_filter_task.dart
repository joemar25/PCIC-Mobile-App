// src/settings/_service.dart
import 'package:flutter/foundation.dart';

class TaskFilters {
  final bool isUpcomingTasksSelected;
  final String searchQuery;
  final bool sortEarliest;

  TaskFilters({
    this.isUpcomingTasksSelected = true,
    this.searchQuery = '',
    this.sortEarliest = true,
  });
}

class TaskFiltersNotifier extends ChangeNotifier {
  TaskFilters _filters = TaskFilters();

  TaskFilters get filters => _filters;

  void updateFilters(TaskFilters filters) {
    _filters = filters;
    notifyListeners();
  }
}
