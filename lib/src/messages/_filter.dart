import 'package:flutter/foundation.dart';

class MessageFilters {
  final String searchQuery;
  final bool sortEarliest;

  MessageFilters({
    this.searchQuery = '',
    this.sortEarliest = true,
  });
}

class MessageFiltersNotifier extends ChangeNotifier {
  MessageFilters _filters = MessageFilters();

  MessageFilters get filters => _filters;

  void updateFilters(MessageFilters filters) {
    _filters = filters;
    notifyListeners();
  }
}
