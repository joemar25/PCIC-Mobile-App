import '../tasks/_task.dart';
import '../messages/_view.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

import '_home.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage>
    with WidgetsBindingObserver {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MessagesPage(),
    TaskPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
    final CustomThemeExtension? t =
        Theme.of(context).extension<CustomThemeExtension>();
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavigationBarItem(Icons.home, 'Home'),
          _buildNavigationBarItem(Icons.chat_rounded, 'Messages'),
          _buildNavigationBarItem(Icons.calendar_today_outlined, 'Tasks'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: mainColor,
        unselectedItemColor: Colors.black.withOpacity(0.7),
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: t?.overline ?? 14.0,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}
