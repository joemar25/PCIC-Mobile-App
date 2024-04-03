import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:pcic_mobile_app/utils/_app_firebase.dart';
import 'package:provider/provider.dart';
import 'package:pcic_mobile_app/screens/_splash.dart';
import 'package:pcic_mobile_app/screens/_starting.dart';
import 'package:pcic_mobile_app/screens/dashboard/_home.dart';
import 'package:pcic_mobile_app/screens/dashboard/_message.dart';
import 'package:pcic_mobile_app/screens/dashboard/_task.dart';
import 'package:pcic_mobile_app/utils/controls/_filter_message.dart';
import 'package:pcic_mobile_app/utils/controls/_filter_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_geotag.dart';
import 'package:pcic_mobile_app/utils/authentication/_login.dart';
import 'package:pcic_mobile_app/utils/authentication/_signup.dart';
import 'package:pcic_mobile_app/utils/authentication/_verify_login.dart';
import 'package:pcic_mobile_app/utils/authentication/_verify_signup.dart';
import 'package:pcic_mobile_app/utils/_app_routes.dart';
import 'package:pcic_mobile_app/utils/controls/_control_task.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  await dotenv.load(fileName: "assets/config/.env");
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
                task: Task(
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
