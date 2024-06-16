// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:logging/logging.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'src/app.dart';
import 'utils/app/_firebase.dart';
import 'src/messages/controllers/_filter.dart';
import 'src/settings/_service.dart';
import 'src/settings/_controller.dart';
import 'src/tasks/components/_filter_task.dart';
import 'package:pcic_mobile_app/utils/navigation/service.dart';

Future<void> main() async {
  setPathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();

  await initializeServices();

  runApp(MyApp());
}

Future<void> initializeServices() async {
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Firebase App Check for mobile
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  // Configure the logger
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });
}

class MyApp extends StatelessWidget {
  final NavigationService navigationService = NavigationService();
  final SettingsController settingsController =
      SettingsController(SettingsService());

  MyApp() {
    settingsController.loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageFiltersNotifier()),
        ChangeNotifierProvider(create: (_) => TaskFiltersNotifier()),
      ],
      child: App(
        settingsController: settingsController,
        navigationService: navigationService,
      ),
    );
  }
}
