import 'package:chitchatapp/providers/userproviders.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatRoomsScreen extends StatefulWidget {
  final String chatName;
  final String chatId;

  const ChatRoomsScreen({super.key, required this.chatName, required this.chatId});

  @override
  State<ChatRoomsScreen> createState() => _ChatRoomsScreenState();
}

class _ChatRoomsScreenState extends State<ChatRoomsScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController messageController = TextEditingController();

  Future<void> sendMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> sendToMessage = {
        'text': messageController.text,
        'sender_name': Provider.of<UserProvider>(context, listen: false).name,
        'chatroom_id': widget.chatId,
        'sender_id': Provider.of<UserProvider>(context, listen: false).uId,
        'timestamp': FieldValue.serverTimestamp(),
      };
      messageController.clear();
      try {
        await db.collection('messages').add(sendToMessage);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Widget singleChatItem({
    required String sender_name,
    required String text,
    required String sender_Id,
  }) {
    bool isCurrentUser = sender_Id == Provider.of<UserProvider>(context, listen: false).uId;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
        decoration: BoxDecoration(
          gradient: isCurrentUser
              ? const LinearGradient(colors: [Colors.blueAccent, Colors.lightBlueAccent])
              : LinearGradient(colors: [Colors.grey.shade300, Colors.grey.shade400]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              sender_name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isCurrentUser ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 5.0),
            Text(
              text,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatName),
        backgroundColor: Colors.blueAccent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.lightBlueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: db
                  .collection('messages')
                  .where('chatroom_id', isEqualTo: widget.chatId)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Some error occurred!'));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                var allMessages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  itemCount: allMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    var message = allMessages[index].data();
                    return singleChatItem(
                      sender_name: message['sender_name'],
                      text: message['text'],
                      sender_Id: message['sender_id'],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Write anything you want...',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                InkWell(
                  onTap: sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Colors.blueAccent, Colors.lightBlueAccent],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
