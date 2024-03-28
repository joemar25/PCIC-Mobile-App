import 'package:flutter/material.dart';
import 'package:pcic_mobile_app/screens/_splash.dart';
import 'package:pcic_mobile_app/screens/_starting.dart';
import 'package:pcic_mobile_app/screens/dashboard/_job.dart';
import 'package:pcic_mobile_app/screens/dashboard/_task.dart';
import 'package:pcic_mobile_app/screens/dashboard/_home.dart';
import 'package:pcic_mobile_app/screens/dashboard/_message.dart';
import 'package:pcic_mobile_app/screens/user-control/_login.dart';
import 'package:pcic_mobile_app/screens/user-control/_signup.dart';
import 'package:pcic_mobile_app/screens/user-control/_verify_login.dart';
import 'package:pcic_mobile_app/screens/user-control/_verify_signup.dart';

const String appTITLE = "PCIC Mobile App";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTITLE,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/starting': (context) => const StartingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/verify-login': (context) =>
            const VerifyLoginPage(isLoginSuccessful: true),
        '/verify-signup': (context) =>
            const VerifySignupPage(isSignupSuccessful: true),
        '/_home': (context) => const DashboardPage(),
        '/_job': (context) => const JobPage(),
        '/_message': (context) => const MessagePage(),
        '/_task': (context) => const TaskPage(),
      },
    );
  }
}
