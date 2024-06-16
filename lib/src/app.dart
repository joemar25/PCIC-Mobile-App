// lib/src/app.dart
import 'package:flutter/material.dart';
import 'package:flash/flash_helper.dart';

import 'tasks/_task.dart';
import 'home/_home.dart';
import 'login/_login.dart';
import 'login/_signup.dart';
import 'messages/_view.dart';
import 'geotag/_geotag.dart';
import 'settings/_view.dart';
import 'splash/_splash.dart';
import 'login/_verify_login.dart';
import 'login/_verify_signup.dart';
import 'settings/_controller.dart';
import 'tasks/controllers/task_manager.dart';

import '../utils/app/_routes.dart';
import '../utils/navigation/service.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.settingsController,
    required this.navigationService,
  });

  final SettingsController settingsController;
  final NavigationService navigationService;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return Toast(
          navigatorKey: navigationService.navigatorKey,
          child: MaterialApp(
            restorationScopeId: 'app',
            title: "PCIC Mobile App",
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            routes: {
              AppRoutes.splash: (context) => const SplashScreen(),
              AppRoutes.login: (context) => const LoginPage(),
              AppRoutes.signup: (context) => const SignupPage(),
              AppRoutes.home: (context) => const HomeScreen(),
              AppRoutes.task: (context) => const TaskPage(),
              AppRoutes.message: (context) => const MessagesPage(),
              AppRoutes.job: (context) =>
                  GeotagPage(task: TaskManager(taskId: '')),
              AppRoutes.verifyLogin: (context) =>
                  const VerifyLoginPage(isLoginSuccessful: true),
              AppRoutes.verifySignup: (context) =>
                  const VerifySignupPage(isSignupSuccessful: true),
              AppRoutes.dashboard: (context) => const HomeScreen(),
              SettingsView.routeName: (context) =>
                  SettingsView(controller: settingsController),
            },
          ),
        );
      },
    );
  }
}
