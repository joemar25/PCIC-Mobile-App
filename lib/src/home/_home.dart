import '_home_header.dart';
import '../tasks/_task.dart';
import '_search_button.dart';
import '../messages/_view.dart';
import '../splash/_splash.dart';
import '_task_count_container.dart';
import '../tasks/_control_task.dart';
import '_recent_task_container.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String? _token;
  List<TaskManager> _tasks = [];
  String _searchQuery = '';
  bool _isLoadingRecentTasks = true;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _fetchTasks();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _navigateToTaskPage(bool isCompleted) {
    String val = isCompleted ? "Completed" : "Ongoing";
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskPage(initialFilter: val),
      ),
    );
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _token = token;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }

  Future<void> _fetchTasks() async {
    try {
      List<TaskManager> tasks = await TaskManager.getNotCompletedTasks();
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoadingRecentTasks = false;
        });
      }
    } catch (error) {
      if (mounted) {
        debugPrint('Error fetching tasks: $error');
        setState(() => _isLoadingRecentTasks = false);
      }
    }
  }

  Future<void> _onRefresh() async {
    await _fetchTasks();
  }

  // void _updateSearchQuery(String newValue) {
  //   setState(() {
  //     _searchQuery = newValue;                            _searchQuery = value;

  //   });
  // }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    final CustomThemeExtension? t =
        Theme.of(context).extension<CustomThemeExtension>();

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
        ),
      ),
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
                      fontSize: t?.headline ?? 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        children: [
                          SearchButton(
                            searchQuery: _searchQuery,
                            onUpdateValue: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          _isLoadingRecentTasks
                              ? const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : RecentTaskContainer(
                                  notCompletedTasks: _tasks,
                                  searchQuery: _searchQuery,
                                ),
                          const SizedBox(height: 8.0),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
