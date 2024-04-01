import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/dashboard/_settings.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String dropDownValue = '';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //Conceptualize laturrr
        // Image(
        //   image: AssetImage('storage/images/icon.png'),
        //   height: 55,
        //   width: 55,
        // ),
        const Text(
          'Hi Agent!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.menu),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'Option 1',
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
                child: const Row(
                  children: [
                    ImageIcon(AssetImage('storage/images/profile.png')),
                    SizedBox(width: 8),
                    Text('Profile'),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'Option 2',
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
                child: const Row(
                  children: [
                    ImageIcon(AssetImage('storage/images/settings.png')),
                    SizedBox(width: 8),
                    Text('Settings'),
                  ],
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: 'Option 3',
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsPage()),
                  );
                },
                child: const Row(
                  children: [
                    ImageIcon(AssetImage(
                      'storage/images/logout.png',
                    )),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ),
          ],
        ),

        // DropdownButton<String>(
        //     items: [
        //       DropdownMenuItem(value: dropDownValue),
        //       DropdownMenuItem(value: 'One', child: Text('One')),
        //       DropdownMenuItem(value: 'Two', child: Text('Two'))
        //     ],
        //     value: dropDownValue,
        //     icon: const Icon(Icons.menu),
        //     onChanged: (String? newValue) {
        //       setState(() {
        //         dropDownValue = newValue!;
        //       });
        //     }),

        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => const SettingsPage()),
        //     );
        //   },
        //   child: const Icon(Icons.menu),
        // ),
      ],
    );
  }
}
