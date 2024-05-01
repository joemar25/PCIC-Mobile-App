import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:pcic_mobile_app/theme/_theme.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'utils/app/_firebase.dart';
import 'screens/tasks/_filter_task.dart';
import 'utils/agent/_login.dart';
import 'utils/agent/_signup.dart';
import 'utils/agent/_verify_login.dart';
import 'utils/agent/_verify_signup.dart';
import 'utils/app/_routes.dart';
import 'screens/tasks/_control_task.dart';

import 'screens/_splash.dart';
import 'screens/_starting.dart';
import 'screens/home/_home.dart';
import 'screens/messages/_view.dart';
import 'screens/tasks/_task.dart';
import 'screens/messages/_filter.dart';
import 'screens/geotag/_geotag.dart';

void main() async {
  // Ensure URLs without the hash sign (#) are handled correctly
  setPathUrlStrategy();

  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: true,
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageFiltersNotifier()),
        ChangeNotifierProvider(create: (_) => TaskFiltersNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: pcicTheme,
      debugShowCheckedModeBanner: false,
      title: "PCIC Mobile App",
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(
                builder: (context) => const SplashScreen());
          case AppRoutes.starting:
            return MaterialPageRoute(
                builder: (context) => const StartingPage());
          case AppRoutes.login:
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case AppRoutes.signup:
            return MaterialPageRoute(builder: (context) => const SignupPage());
          case AppRoutes.home:
            return MaterialPageRoute(
                builder: (context) => const DashboardPage());
          case AppRoutes.task:
            return MaterialPageRoute(builder: (context) => const TaskPage());
          case AppRoutes.message:
            return MaterialPageRoute(
                builder: (context) => const MessagesPage());
          case AppRoutes.job:
            return MaterialPageRoute(
              builder: (context) => GeotagPage(
                task: TaskManager(
                  id: 1,
                  isCompleted: false,
                  dateAdded: DateTime.now(),
                  dateAccess: DateTime.now(),
                  ppirAssignmentId: 2,
                  ppirInsuranceId: 3,
                ),
              ),
            );
          case AppRoutes.verifyLogin:
            return MaterialPageRoute(
                builder: (context) =>
                    const VerifyLoginPage(isLoginSuccessful: true));
          case AppRoutes.verifySignup:
            return MaterialPageRoute(
                builder: (context) =>
                    const VerifySignupPage(isSignupSuccessful: true));
          case '/dashboard':
            return MaterialPageRoute(
                builder: (context) => const DashboardPage());
          default:
            return MaterialPageRoute(
                builder: (context) => const SplashScreen());
        }
      },
    );
  }
}
