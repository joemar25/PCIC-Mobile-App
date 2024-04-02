import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/_logout.dart';
import 'package:pcic_mobile_app/screens/dashboard/_message.dart';
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
          _buildNavigationBarItem(Icons.home, 'Home'),
          _buildNavigationBarItem(Icons.message, 'Messages'),
          _buildNavigationBarItem(Icons.calendar_today, 'Tasks'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate to the logout success page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LogoutSuccessPage()),
      );
    } catch (e) {
      // Handle logout error
      print('Logout error: $e');
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> recentTasks = [
      'Task 1',
      'Task 2',
      'Task 3',
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: HomeHeader(onLogout: _handleLogout),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const ProfileContainer(),
              const SizedBox(height: 16),
              const SearchButton(),
              const SizedBox(height: 16),
              const Text(
                'Recent Task',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RecentTaskContainer(
                tasks: recentTasks,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
