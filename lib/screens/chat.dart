import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserPhone; 
  final DocumentSnapshot chatUser;

  const ChatScreen({Key? key, required this.currentUserPhone, required this.chatUser}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatUser['name']),
      ),
      body: Column(
        children: [
          Text("You are chatting with ${widget.chatUser['phone']}"),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('chatRoomId', isEqualTo: getChatRoomId(widget.currentUserPhone, widget.chatUser['phone']))
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData) {
                  return Center(child: Text('No messages available.'));
                }

                var messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,  // To show the latest message at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message = messages[index];
                    var timestamp = message['timestamp'];
                    var senderId = message['senderId'];
                    
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(senderId).get(),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                          return ListTile(
                            title: Text(message['text']),
                            subtitle: Text(
                              timestamp != null
                                  ? 'Sent at: ${timestamp.toDate()}'
                                  : 'Timestamp not available',
                            ),
                          );
                        }

                        var senderName = userSnapshot.data!['name'];
                        
                        return ListTile(
                          title: Text(message['text']),
                          subtitle: Text(
                            timestamp != null
                                ? 'Sent by $senderName at ${timestamp.toDate()}'
                                : 'Timestamp not available',
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Enter your message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    var text = _messageController.text.trim();
                    if (text.isNotEmpty) {
                      await FirebaseFirestore.instance.collection('messages').add({
                        'chatRoomId': getChatRoomId(widget.currentUserPhone, widget.chatUser['phone']),
                        'senderId': widget.currentUserPhone,
                        'receiverId': widget.chatUser['phone'],
                        'text': text,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String getChatRoomId(String phone1, String phone2) {
    return phone1.hashCode <= phone2.hashCode
        ? '$phone1\_$phone2'
        : '$phone2\_$phone1';
  }
}
