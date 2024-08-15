import 'package:chitchatapp/providers/userproviders.dart';
import 'package:chitchatapp/screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      var user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        loginScreen();
      } else {
        dashboard();
      }
    });
  }

  void dashboard() {
    Provider.of<UserProvider>(context, listen: false).getDataDetails(context: context);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return const DashBoardScreen();
    }), (route) => false);
  }

  void loginScreen() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const Loginscreen();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blueAccent[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/chatapplogo.jpeg', height: 200),
            const SizedBox(height: 20),
            const Text(
              'Welcome to ChitChat',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
