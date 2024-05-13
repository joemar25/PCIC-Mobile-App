// file: _home.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:pcic_mobile_app/src/home/_flash.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../home/_home_header.dart';
import '../home/_search_button.dart';
import '../messages/_view.dart';
import '../splash/_splash.dart';
import '../tasks/_control_task.dart';
import '../tasks/_task.dart';
import '_recent_task_container.dart';
import '_task_count_container.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
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
    final CustomThemeExtension? t =
        Theme.of(context).extension<CustomThemeExtension>();
    return PopScope(
      // onWillPop: _onWillPop,
      child: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            _buildNavigationBarItem(Icons.home, 'Home'),
            _buildNavigationBarItem(Icons.message, 'Messages'),
            _buildNavigationBarItem(Icons.calendar_today, 'Tasks'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color(0xFF0F7D40),
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize:
                t?.overline ?? 14.0, // Provide a default value if t is null
          ),
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
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? _token;
  List<TaskManager> _tasks = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchTasks();
  }

  void _navigateToTaskPage(bool isCompleted) {
    // mar latest
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => TaskPage(initialFilter: isCompleted),
    //   ),
    // );
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      // Redirect to the splash screen if token is null
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      }
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
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }

  Future<void> _fetchTasks() async {
    try {
      List<TaskManager> tasks = await TaskManager.getAllTasks();
      setState(() {
        _tasks = tasks;
      });
    } catch (error) {
      debugPrint('Error fetching tasks: $error');
    }
  }

  Future<void> _onRefresh() async {
    await _fetchTasks();
  }

  void _updateSearchQuery(String newValue) {
    setState(() {
      _searchQuery = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    final CustomThemeExtension? t =
        Theme.of(context).extension<CustomThemeExtension>();
    // If there's no token, show a loading indicator while waiting for the redirection to complete.
    if (_token == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      key: key,
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1.0,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: HomeHeader(onLogout: _handleLogout),
          )),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                TaskCountContainer(onTasksPressed: _navigateToTaskPage),
                const SizedBox(height: 16.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    'Recent Tasks',
                    style: TextStyle(
                      fontSize: t?.headline ?? 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: SearchButton(
                    onUpdateValue: _updateSearchQuery,
                  ),
                ),
                const SizedBox(height: 16.0),
                RecentTaskContainer(
                  tasks: _tasks,
                  searchQuery: _searchQuery,
                ),
                const SizedBox(height: 8.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
