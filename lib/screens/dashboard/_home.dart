import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pcic_mobile_app/screens/_splash.dart';
import 'package:pcic_mobile_app/screens/dashboard/_message.dart';
import 'package:pcic_mobile_app/screens/dashboard/_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_components/_home_header.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_components/_profile_container.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_components/_recent_task_container.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/home_components/_search_button.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirm Exit'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => SystemNavigator.pop(),
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
  String? _token;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchTasks();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      // Redirect to the splash screen if token is null
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    } else {
      setState(() {
        _token = token;
      });
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    // Redirect to the splash screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SplashScreen()),
    );
  }

  Future<void> _fetchTasks() async {
    try {
      List<Task> tasks = await Task.getAllTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (error) {
      debugPrint('Error fetching tasks: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    // If there's no token, show a loading indicator while waiting for the redirection to complete.
    if (_token == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
              RecentTaskContainer(tasks: _tasks),
            ],
          ),
        ),
      ),
    );
  }
}
