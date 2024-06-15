import '../tasks/_task.dart';
import '../splash/_splash.dart';
import 'components/_home_header.dart';
import 'package:flutter/material.dart';
import 'components/_search_button.dart';
import 'controllers/sync_controller.dart';
import 'components/_task_count_container.dart';
import '../tasks/controllers/task_manager.dart';
import 'components/_recent_task_container.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final SyncController _syncController = SyncController();
  bool _isSyncing = false;
  String _syncStatus = '';

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

  Future<void> startSync() async {
    setState(() {
      _isSyncing = true;
      _syncStatus = 'Syncing data...';
    });

    try {
      await _syncController.syncData();

      setState(() {
        _isSyncing = false;
        _syncStatus = 'Sync completed successfully';
      });

      // Refresh the tasks after syncing
      await _fetchTasks();
    } catch (e) {
      setState(() {
        _isSyncing = false;
        _syncStatus = 'Sync failed: $e';
      });
    }
  }

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
        backgroundColor: mainColor,
        elevation: 2.0,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 6.0),
          child: HomeHeader(onLogout: _handleLogout),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: startSync,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 90.0),
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
                        color: mainColor,
                        fontSize: t?.headline ?? 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (_isSyncing)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(width: 16.0),
                          Text(_syncStatus),
                        ],
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
                            const SizedBox(height: 10.0),
                            _isLoadingRecentTasks
                                ? const Padding(
                                    padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.75,
                                    child: SingleChildScrollView(
                                      child: RecentTaskContainer(
                                        notCompletedTasks: _tasks,
                                        searchQuery: _searchQuery,
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 55.0),
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
      ),
    );
  }
}
