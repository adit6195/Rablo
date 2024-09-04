import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rablo/authentication/login.dart';
import 'package:rablo/model/usermodel.dart';
import 'package:rablo/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CheckLogic{

    static Future<bool> checkInternetConnectivity() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }


  static void checkLogin(BuildContext context) async {
    var prefs = await SharedPreferences.getInstance();

    String? userID = prefs.getString("userID");
    var isLogin = prefs.getBool('isLoggedIn');
    print(isLogin);

    if (isLogin == true) {
      if (userID != null) {
        QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
            .instance
            .collection("users")
            .where("phone", isEqualTo: userID)
            .get();
        if (snapshot.docs.isNotEmpty) {
          // Assuming phone numbers are unique, so there should be at most one document
          DocumentSnapshot<Map<String, dynamic>> userDocument =
              snapshot.docs.first;
          
          String name = userDocument.data()!["name"];
          bool active = userDocument.data()!["is_active"];
          String email = userDocument.data()!["email"];
          String pass = userDocument.data()!["password"];
          bool admin = userDocument.data()!["is_admin"];
          Timestamp signup = userDocument.data()!["sign_up"];

          if (active == true) {
            // If there is a user with the provided isActive is true, navigate to the next screen
          FirebaseFirestore.instance
                  .collection("users")
                  .doc(userID)
                  .update({
                "last_used": DateTime.now(),
              }).then((value) async => {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Welcome Back!"))),
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen(user: UserModel(email: email,isActive: admin,isAdmin: admin,lastUsed: Timestamp.now(),pass: pass,signUp: signup,userName: name,userPhone: userID))),
                        ),
                      });

            
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
            showDialog(
                context: context,
                builder: (BuildContext) {
                  return Text(
                          "It's seems like you are not an active member.");
                });
            // Handle the case when the user is not found or isActive is not true
            // You can show a message or take appropriate action
            print("User not active, ");
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
          // No user found with the given phone number
          print('User not found');
        }
        // Check in Firestore if the storedName has isActive value as true
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
