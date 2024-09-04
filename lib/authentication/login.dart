import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rablo/authentication/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rablo/model/usermodel.dart';
import 'package:rablo/screens/home.dart';
import 'package:rablo/utils/check_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
          child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: screenSize.height * 0.075,
            horizontal: screenSize.width * 0.055),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Login",
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: screenSize.height * 0.0375,
                        fontWeight: FontWeight.w600,
                        color: Colors.black)),
                SizedBox(height: screenSize.height * 0.035),
                TextFormField(
                  
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: screenSize.height * 0.0225,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  controller: emailController,
                  decoration: InputDecoration(
                    
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontSize: screenSize.height * 0.025,
                        fontWeight: FontWeight.w500),
                    alignLabelWithHint: true,
                    labelText: "E-mail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 10 || value.isEmpty) {
                      return "Please Enter valid E-Mail";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.025,
                ),
                TextFormField(
                  
                  style: TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: screenSize.height * 0.0225,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  controller: passwordController,
                  obscureText: _obscureText,
                  
                  decoration: InputDecoration(
                    
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontFamily: "Montserrat",
                        fontSize: screenSize.height * 0.025,
                        fontWeight: FontWeight.w500),
                    alignLabelWithHint: true,
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.black,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.red,
                      ),
                    ),
                    suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                  ),
                  validator: (value) {
                    if (value!.length < 6 || value.isEmpty) {
                      return "Please Enter valid Password";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: screenSize.height * 0.025,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState?.validate() == true) {
                        bool isConnected =
                            await CheckLogic.checkInternetConnectivity();
                        if (isConnected == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "No internet connection. Please try again."),
                            ),
                          );
                        } else {
                          _checkIfNumberExistsAndSignUp(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 5,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * 0.0125,
                          horizontal: screenSize.width * 0.0277),
                      child: Text(
                        "Login",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: screenSize.height * 0.025,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenSize.height * 0.03,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.4,
                      height: screenSize.height * 0.03,
                      child: const Divider(
                        color: Colors.blueGrey,
                      ),
                    ),
                    Text(
                      "OR",
                      style: TextStyle(
                          fontFamily: "Oswald",
                          fontSize: screenSize.height * 0.025),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.4,
                      height: screenSize.height * 0.03,
                      child: const Divider(
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenSize.height * 0.03,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Not a User?  ',
                    style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: screenSize.height * 0.02,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'SIGN-UP',
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: screenSize.height * 0.02,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                        // Add an onTap handler for the TextButton
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle the login button press
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                            print('Login button pressed');
                          },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
  Future<void> _checkIfNumberExistsAndSignUp(BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      
      // Check if the user already exists in Firestore
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: emailController.text)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("New User");
        // User already exists, display a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'The entered email is not registered. Please Signup'),
          ),
        );
      } else {
        
        print("hello new");
        var prefs = await SharedPreferences.getInstance();
         UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    );
    if(userCredential != null){
      String email = emailController.text;
      QuerySnapshot userSnapshot = await firestore.collection('users').where('email', isEqualTo: email).get();

      if(userSnapshot.docs.isNotEmpty){
        DocumentSnapshot userDoc = userSnapshot.docs.first;
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        // Update last used timestamp
        await firestore.collection('users').doc(userDoc.id).update({
          'last_used': DateTime.now(),
        });
        prefs.setBool("isLoggedIn", true);
        prefs.setString("userID", userDoc.id);
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("User Logged In")));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(user: UserModel( email: userData['email'],
                isActive: userData['is_active'],
                isAdmin: userData['is_admin'],
                lastUsed: userData['last_used'],
                signUp: userData['sign_up'],
                pass: passwordController.text, 
                userName: userData['name'],
                userPhone: userData['phone'],))),
              );

      }
    }

      }
    } catch (e) {
      print('Error checking account: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
      ));
    }
  }
  }
