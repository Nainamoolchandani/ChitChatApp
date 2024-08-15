import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier{
   String name = '';
   String email  = '';
   String uId  = '';

   Map<String, dynamic>? userDAta = {};
   var currentUser = FirebaseAuth.instance.currentUser;
   var db = FirebaseFirestore.instance;
   bool isLoading = true;

   void getDataDetails({required BuildContext context})  {
      var currentUser = FirebaseAuth.instance.currentUser;

      try {
           db.collection('users').doc(currentUser!.uid).get().then((snapShot){
              name = snapShot.data()?['name']??  '';
              uId = snapShot.data()?['id']??  '';
              email = snapShot.data()?['email']?? '';

         });

      } catch (e) {
         ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch data: $e')),
         );
      }
      notifyListeners();
   }








}