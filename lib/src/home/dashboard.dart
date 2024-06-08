import '_home.dart';
import '../tasks/_task.dart';
import '../messages/_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pcic_mobile_app/src/theme/_theme.dart';

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
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: CustomBottomNavBar(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
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

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(
            color: mainColor,
            offset: Offset(0, 0.5),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavigationBarItem(
            context,
            iconPath: 'assets/icons/home.svg',
            index: 0,
          ),
          _buildNavigationBarItem(
            context,
            iconPath: 'assets/icons/messages.svg',
            index: 1,
          ),
          _buildNavigationBarItem(
            context,
            iconPath: 'assets/icons/tasks.svg',
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBarItem(BuildContext context,
      {required String iconPath, required int index}) {
    bool isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: SvgPicture.asset(
        iconPath,
        width: 26,
        height: 26,
        color: isSelected ? mainColor : Colors.black.withOpacity(0.7),
      ),
    );
  }
}
