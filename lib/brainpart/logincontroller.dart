import 'package:chitchatapp/screens/splashScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/dashboard.dart';

class LoginController{
 static Future<void> userLogin({required  email, required  password,required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return const SplashScreen();
      }), (route){
        return false;
      });

    }
    catch (e) {
      SnackBar messageBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(messageBar);
    }
  }





}