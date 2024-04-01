import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:pcic_mobile_app/screens/_splash.dart';
import 'package:pcic_mobile_app/screens/_starting.dart';
import 'package:pcic_mobile_app/screens/dashboard/_home.dart';
import 'package:pcic_mobile_app/screens/dashboard/_message.dart';
import 'package:pcic_mobile_app/screens/dashboard/_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/controllers/_filter_message.dart';
import 'package:pcic_mobile_app/screens/dashboard/controllers/_filter_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/views/_geotag.dart';
import 'package:pcic_mobile_app/screens/user-control/_login.dart';
import 'package:pcic_mobile_app/screens/user-control/_signup.dart';
import 'package:pcic_mobile_app/screens/user-control/_verify_login.dart';
import 'package:pcic_mobile_app/screens/user-control/_verify_signup.dart';
import 'package:pcic_mobile_app/utils/_app_routes.dart';
import 'package:pcic_mobile_app/screens/dashboard/controllers/_control_task.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: "assets/config/.env");

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
      routes: {
        // routes
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.starting: (context) => const StartingPage(),
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.signup: (context) => const SignupPage(),
        AppRoutes.home: (context) => const DashboardPage(),
        AppRoutes.task: (context) => const TaskPage(),
        AppRoutes.message: (context) => const MessagesPage(),
        AppRoutes.job: (context) => GeotagPage(
                task: Task(
              id: 1,
              title: 'Sample Task',
              description: 'This is a sample task.',
              isCompleted: false,
              dateAdded: DateTime.now(),
              geotaggedPhoto: '',
              formData: {},
            )),
        // controls
        AppRoutes.verifyLogin: (context) =>
            const VerifyLoginPage(isLoginSuccessful: true),
        AppRoutes.verifySignup: (context) =>
            const VerifySignupPage(isSignupSuccessful: true),
      },
    );
  }
}
