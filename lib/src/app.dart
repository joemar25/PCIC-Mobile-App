// filename: app.dart
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/src/settings/_controller.dart';
import 'package:pcic_mobile_app/src/settings/_view.dart';

import '../utils/agent/_login.dart';
import '../utils/agent/_signup.dart';
import '../utils/agent/_verify_login.dart';
import '../utils/agent/_verify_signup.dart';
import '../utils/app/_routes.dart';
import '_starting.dart';
import 'geotag/_geotag.dart';
import 'home/_home.dart';
import 'messages/_view.dart';
import 'navigation/service.dart';
import 'splash/_splash.dart';
import 'tasks/controller_component/task_manager.dart';
import 'tasks/_task.dart';

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
        return Toast(
            navigatorKey: navigationService.navigatorKey,
            child: MaterialApp(
              restorationScopeId: 'app',
              title: "PCIC Mobile App",

              // theme: ThemeData.light(),
              // darkTheme: ThemeData.dark(),
              // themeMode: settingsController.themeMode,

              debugShowCheckedModeBanner: false,

              initialRoute: AppRoutes.splash,

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
                        formId: '',
                        taskId: '',
                        type: '',
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
            ));
      },
    );
  }
}
