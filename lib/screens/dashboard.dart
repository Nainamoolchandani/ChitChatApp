import 'package:chitchatapp/providers/userproviders.dart';
import 'package:chitchatapp/screens/chatroom.dart';
import 'package:chitchatapp/screens/loginscreen.dart';
import 'package:chitchatapp/screens/profilescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> chatRoomsList = [];
  List<String> chatRoomsId = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getChatroom();
  }

  void getChatroom() async {
    try {
      final snapshot = await db.collection('chatrooms').get();
      chatRoomsList = snapshot.docs.map((doc) => doc.data()).toList();
      chatRoomsId = snapshot.docs.map((doc) => doc.id).toList();
      setState(() {});
    } catch (e) {
      print("Error fetching chat rooms: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            scaffoldKey.currentState!.openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CircleAvatar(
              radius: 20,
              child: Text(
                userProvider.name.isNotEmpty ? userProvider.name[0] : '',
              ),
            ),
          ),
        ),
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
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userProvider.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(userProvider.email),
              currentAccountPicture: CircleAvatar(
                child: Text(
                  userProvider.name.isNotEmpty ? userProvider.name[0] : '',
                  style: const TextStyle(fontSize: 40.0),
                ),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const UserProfile();
                }));
              },
              leading: const Icon(Icons.person, color: Colors.purple),
              title: const Text('Profile'),
            ),
            ListTile(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return const Loginscreen();
                }));
              },
              leading: const Icon(Icons.logout, color: Colors.purple),
              title: const Text('Logout'),
            ),
          ],
        ),
      ),
      body: chatRoomsList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: chatRoomsList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: ListTile(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ChatRoomsScreen(
                    chatName: chatRoomsList[index]['chatroom_name'] ?? '',
                    chatId: chatRoomsId[index],
                  );
                }));
              },
              leading: CircleAvatar(
                child: Text(
                  chatRoomsList[index]['chatroom_name']?[0] ?? '',
                ),
              ),
              title: Text(chatRoomsList[index]['chatroom_name'] ?? ''),
              subtitle: Text(chatRoomsList[index]['desc'] ?? ''),
            ),
          );
        },
      ),
    );
  }
}
