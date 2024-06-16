import 'login/_login.dart';
import 'login/_signup.dart';
import 'login/_verify_login.dart';
import 'login/_verify_signup.dart';
import 'home/_home.dart';
import 'tasks/_task.dart';
import 'geotag/_geotag.dart';
import 'messages/_view.dart';
import 'splash/_splash.dart';
import '../utils/app/_routes.dart';
import 'package:flutter/material.dart';
import 'package:flash/flash_helper.dart';
import '../utils/navigation/service.dart';
import 'tasks/controllers/task_manager.dart';
import 'package:pcic_mobile_app/src/settings/_view.dart';
import 'package:pcic_mobile_app/src/settings/_controller.dart';
// filename: app.dart

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
            ));
      },
    );
  }
}
