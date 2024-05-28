// account_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AccountService {
  static Future<void> createAccountsForEmails(List<String> emails) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (final email in emails) {
      try {
        final password = _generateRandomPassword();
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        if (user != null) {
          String name = _getNameFromEmail(email);

          await firestore.collection('users').doc(user.uid).set({
            'authUid': user.uid,
            'email': email,
            'name': name,
            'profilePicUrl':
                'https://firebasestorage.googleapis.com/v0/b/pcic-mobile-app.appspot.com/o/profile_pics%2Fdefault.png?alt=media&token=cecb3e4c-6f43-48fa-96ab-f743c4d8abe5',
            'role': 'user',
            'verified': true,
          });

          await sendEmail(
            email,
            'Your New Account Details',
            'Your account has been created.\nEmail: $email\nPassword: $password',
          );
        }
      } catch (e) {
        if (e is FirebaseAuthException && e.code == 'email-already-in-use') {
          // Account already exists, skip creation
        } else {
          // Log the error
          debugPrint('Error creating account for email: $email - $e');
        }
      }
    }
  }

  static String _getNameFromEmail(String email) {
    final localPart = email.split('@')[0];
    return localPart[0].toUpperCase() + localPart.substring(1);
  }

  static String _generateRandomPassword({int length = 12}) {
    // import 'dart:math';
    // const chars =
    //     'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    // final rand = Random();
    // return List.generate(length, (index) => chars[rand.nextInt(chars.length)])
    //     .join();
    return 'admin1234';
  }

  static Future<void> sendEmail(
    String recipientEmail,
    String subject,
    String body,
  ) async {
    String username = 'quanbydevs@gmail.com';
    String password = 'ghpnvhypovidmqdn';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Quanby Admin')
      ..recipients.add(recipientEmail)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      debugPrint('Message sent: $sendReport');
    } on MailerException catch (e) {
      debugPrint('Message not sent.');
      for (var p in e.problems) {
        debugPrint('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
