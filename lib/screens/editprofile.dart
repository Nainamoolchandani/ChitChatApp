import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/userproviders.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = Provider.of<UserProvider>(context, listen: false).name;
  }

  Future<void> updateName() async {
    try {
      Map<String, dynamic> dataToUpdate = {
        'name': nameController.text,
      };
      await db.collection('users').doc(Provider.of<UserProvider>(context, listen: false).uId).update(dataToUpdate);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name updated successfully!')),
      );
      Provider.of<UserProvider>(context, listen: false).getDataDetails(context: context);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update name: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                if (formKey.currentState!.validate()) {
                  updateName();
                }
              },
              child: const Icon(Icons.done),
            ),
          )
        ],
        title: const Text('Edit Profile'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Text field cannot be empty';
                  }
                  return null;
                },
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    updateName();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
