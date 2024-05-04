// filename: app.dart
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/settings/_controller.dart';
import 'package:pcic_mobile_app/src/settings/_view.dart';

import '../utils/agent/_login.dart';
import '../utils/agent/_signup.dart';
import '../utils/agent/_verify_login.dart';
import '../utils/agent/_verify_signup.dart';
import '../utils/app/_routes.dart';

import 'home/_home.dart';
import 'tasks/_task.dart';
import 'geotag/_geotag.dart';
import 'splash/_splash.dart';
import 'messages/_view.dart';
import 'navigation/service.dart';
import 'tasks/_control_task.dart';

import '_starting.dart';

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.settingsController,
      required this.navigationService});

  final SettingsController settingsController;
  final NavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          title: "PCIC Mobile App",

          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: settingsController.themeMode,

          debugShowCheckedModeBanner: false,

          initialRoute: AppRoutes.splash,
          navigatorKey: navigationService.navigatorKey,
          // Route configuration
          routes: {
            AppRoutes.splash: (context) => const SplashScreen(),
            AppRoutes.starting: (context) => const StartingPage(),
            AppRoutes.login: (context) => const LoginPage(),
            AppRoutes.signup: (context) => const SignupPage(),
            AppRoutes.home: (context) => const DashboardPage(),
            AppRoutes.task: (context) => const TaskPage(),
            AppRoutes.message: (context) => const MessagesPage(),
            AppRoutes.job: (context) => GeotagPage(
                  task: TaskManager(
                    id: 1,
                    isCompleted: false,
                    dateAdded: DateTime.now(),
                    dateAccess: DateTime.now(),
                    ppirAssignmentId: 2,
                    ppirInsuranceId: 3,
                  ),
                ),
            AppRoutes.verifyLogin: (context) =>
                const VerifyLoginPage(isLoginSuccessful: true),
            AppRoutes.verifySignup: (context) =>
                const VerifySignupPage(isSignupSuccessful: true),
            AppRoutes.dashboard: (context) => const DashboardPage(),
            SettingsView.routeName: (context) =>
                SettingsView(controller: settingsController),
          },
        );
      },
    );
  }
}
