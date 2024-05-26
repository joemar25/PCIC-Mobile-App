import 'src/app.dart';
import 'utils/app/_firebase.dart';
import 'src/messages/_filter.dart';
import 'src/settings/_service.dart';
import 'src/tasks/_filter_task.dart';
import 'package:flutter/material.dart';
import 'src/settings/_controller.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:pcic_mobile_app/src/navigation/service.dart';

// Comment out Firebase App Check
// import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  setPathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();

  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Comment out Firebase App Check activation
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  // );

  final navigationService = NavigationService();
  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageFiltersNotifier()),
        ChangeNotifierProvider(create: (_) => TaskFiltersNotifier()),
      ],
      child: App(
          settingsController: settingsController,
          navigationService: navigationService),
    ),
  );
}
