import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rablo/authentication/login.dart';
import 'package:rablo/model/usermodel.dart';
import 'package:rablo/screens/chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _currentUser;
  late String _currentUserPhoneNumber;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _currentUserPhoneNumber = widget.user.userPhone; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              var prefs = await SharedPreferences.getInstance();
              prefs.setBool("isLoggedIn", true);
              Navigator.pushReplacement(context,
  MaterialPageRoute(
    builder: (context) => LoginScreen()
  ),);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .where('phone', isNotEqualTo: _currentUserPhoneNumber) 
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var users = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    var user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(user['name'][0]),
                      ),
                      title: Text(user['name']),
                      subtitle: Text(user['email']),
                    
                      onTap: () {
                        Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ChatScreen(
      currentUserPhone: widget.user.userPhone, 
      chatUser: user,
    ),
  ),
);

                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
