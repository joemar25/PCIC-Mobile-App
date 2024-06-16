// src/utils/navigation/service.dart
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void navigateTo(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  void replaceWith(String routeName) {
    navigatorKey.currentState?.pushReplacementNamed(routeName);
  }

  void goBack() {
    navigatorKey.currentState?.pop();
  }
}
