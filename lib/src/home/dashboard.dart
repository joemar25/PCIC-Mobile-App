// src/home/dashboard.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '_home.dart';

import '../theme/_theme.dart';
import '../tasks/_task.dart';
import '../messages/_view.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;
  int _unseenMessagesCount = 0;
  int _tasksCount = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MessagesPage(),
    TaskPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUnseenMessagesCount();
    _loadTasksCount();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadUnseenMessagesCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _unseenMessagesCount = prefs.getInt('unseenMessagesCount') ?? 0;
    });
    // debugPrint('Unseen Messages Count: $_unseenMessagesCount');
  }

  Future<void> _loadTasksCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasksCount = prefs.getInt('tasksCount') ?? 0;
    });
    // debugPrint('Tasks Count: $_tasksCount');
  }

  @override
  Future<bool> didPopRoute() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            left: 20,
            right: 20,
            bottom: 10,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      height: 70,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                CustomBottomNavBar(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  unseenMessagesCount: _unseenMessagesCount,
                  tasksCount: _tasksCount,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  final int unseenMessagesCount;
  final int tasksCount;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.unseenMessagesCount,
    required this.tasksCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(0, 0.5),
            blurRadius: 16,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavigationBarItem(
            context,
            iconPath: 'assets/icons/home1.svg',
            index: 0,
          ),
          _buildNavigationBarItem(
            context,
            iconPath: 'assets/icons/messages1.svg',
            index: 1,
            badgeContent: unseenMessagesCount > 0
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Text(
                      '$unseenMessagesCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                : null,
          ),
          _buildNavigationBarItem(
            context,
            iconPath: 'assets/icons/notes1.svg',
            index: 2,
            badgeContent: tasksCount > 0
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                    child: Text(
                      '$tasksCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBarItem(BuildContext context,
      {required String iconPath,
      required int index,
      // String? label,
      Widget? badgeContent}) {
    bool isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Stack(
        children: [
          SvgPicture.asset(
            iconPath,
            width: 34,
            height: 34,
            color: isSelected ? mainColor : Colors.black.withOpacity(0.5),
          ),
          if (badgeContent != null)
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                constraints: const BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: Center(child: badgeContent),
              ),
            ),
        ],
      ),
    );
  }
}
