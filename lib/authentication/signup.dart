import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:rablo/authentication/login.dart';
import 'package:rablo/model/usermodel.dart';
import 'package:rablo/screens/home.dart';
import 'package:rablo/utils/check_logic.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' as Foundation;    

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formkey = GlobalKey<FormState>();

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.075,
                horizontal: screenSize.width * 0.055),
            child: Center(
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Text("Sign-Up",
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: screenSize.height * 0.0375,
                            fontWeight: FontWeight.w600,
                            color: Colors.black)),
                    SizedBox(
                      height: screenSize.height * 0.025,
                    ),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: screenSize.height * 0.0225,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: screenSize.height * 0.025,
                            fontWeight: FontWeight.w500),
                        alignLabelWithHint: true,
                        labelText: "User Name",
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
                        if (value!.isEmpty) {
                          return "Please Enter Valid Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.035,
                    ),
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
                        labelText: "E-Mail",
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
                        if (value!.isEmpty) {
                          return "Please Enter Valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.035,
                    ),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: screenSize.height * 0.0225,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                      decoration: InputDecoration(
                        suffixIcon: phoneController.text.length > 9
                            ? const Icon(
                                Icons.phone,
                                color: Colors.green,
                              )
                            : const Icon(
                                Icons.phone,
                                color: Colors.black,
                              ),
                        prefixIcon: Container(
                          width: screenSize.width * 0.29,
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                  countryListTheme: const CountryListThemeData(
                                    bottomSheetHeight: 500,
                                  ),
                                  context: context,
                                  onSelect: (value) {
                                    setState(() {
                                      selectedCountry = value;
                                    });
                                  });
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: screenSize.height * 0.014,
                                      bottom: screenSize.height * 0.014,
                                      left: screenSize.width * 0.031,
                                      right: screenSize.width * 0.01),
                                  child: Text(
                                    "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
                                    style: TextStyle(
                                        fontFamily: "Montserrat",
                                        fontSize: screenSize.height * 0.0225,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Text(
                                  "l",
                                  style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: screenSize.height * 0.07,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          ),
                        ),
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontSize: screenSize.height * 0.025,
                            fontWeight: FontWeight.w500),
                        alignLabelWithHint: true,
                        labelText: "User Phone",
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
                          return "Please Enter valid Phone Number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: screenSize.height * 0.035,
                    ),
                    TextFormField(
                      style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: screenSize.height * 0.0225,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      controller: passController,
                      textCapitalization: TextCapitalization.words,
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
                      height: screenSize.height * 0.05,
                    ),
                    ElevatedButton(
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
                            var prefs = await SharedPreferences.getInstance();
                            prefs.setString("phone",
                                "+${selectedCountry.phoneCode}${phoneController.text}");
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
                              horizontal: screenSize.width * 0.0277,
                              vertical: screenSize.height * 0.0125),
                          child: Text(
                            "Sign-  Up",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: screenSize.height * 0.025,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          )),
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
                        text: 'Already have an account?  ',
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: screenSize.height * 0.02,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'LOG-IN',
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: screenSize.height * 0.02,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Handle the login button press
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        LoginScreen()
                                        ));
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
          ),
        ),
      ),
    );
  }

  Future<void> _checkIfNumberExistsAndSignUp(BuildContext context) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String phoneNumber = '+${selectedCountry.phoneCode}${phoneController.text}';
    bool isActive = true;
    bool isAdmin = false;
    try {
      if (Foundation.kDebugMode) {
        // ignore: avoid_print
        print('+${selectedCountry.phoneCode}${phoneController.text}');
        // ignore: avoid_print
        print(emailController.text);
      }
      
      // Check if the user already exists in Firestore
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .where('phone',
              isEqualTo: '+${selectedCountry.phoneCode}${phoneController.text}')
          .where('email', isEqualTo: emailController.text)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("Old User");
        // User already exists, display a message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'The entered phone number or email is already registered. Please Login'),
          ),
        );
      } else {
        
        print("hello new");
        var prefs = await SharedPreferences.getInstance();
        await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passController.text);
        FirebaseFirestore.instance.collection("users").doc(phoneNumber).set({
          "name": nameController.text,
          "phone": phoneNumber,
          "email": emailController.text,
          "is_active": isActive,
          "is_admin": isAdmin,
          "last_used": DateTime.now(),
          "sign_up": DateTime.now(),
          "password": passController.text,
        }).then((value) async => {
              prefs.setBool("isLoggedIn", true),
              prefs.setString("userID", phoneNumber),
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("User Added"))),
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(user: UserModel(email: emailController.text,isActive: isActive,isAdmin: isAdmin,lastUsed: Timestamp.now(),signUp: Timestamp.now(),pass: passController.text,userName: nameController.text,userPhone: phoneController.text))),
              ),
            });
      }
    } catch (e) {
      print('Error checking account: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
      ));
    }
  }
}
