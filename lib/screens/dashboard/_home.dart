import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/_message.dart';
import 'package:pcic_mobile_app/screens/dashboard/_settings.dart';
import 'package:pcic_mobile_app/screens/dashboard/_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_views/_home_header.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_views/_profile_container.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_views/_recent_task_container.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_views/_search_button.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MessagesPage(),
    TaskPage(),
    // SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          _buildNavigationBarItem('storage/images/home-2.png', 'Home', 0),
          _buildNavigationBarItem('storage/images/message.png', 'Messages', 1),
          _buildNavigationBarItem('storage/images/calendar-2.png', 'Tasks', 2),
          // _buildNavigationBarItem(Icons.settings, 'Settings', 3),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  BottomNavigationBarItem _buildNavigationBarItem(
    String icon,
    String label,
    int index,
  ) {
    final isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFF89C53F).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageIcon(
              AssetImage(icon),
              color: const Color(0xFF7C7C7C),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isSelected ? 1.0 : 0.0,
                child: Text(label,
                    style: const TextStyle(
                        color: Color(0xFF89C53F), fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
      label: '',
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeHeader(),
          SizedBox(height: 16),
          ProfileContainer(),
          SizedBox(height: 8),
          SearchButton(),
          SizedBox(height: 16),
          Text(
            'Recent Task',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          RecentTaskContainer()
        ],
      ),
    );
  }
}
