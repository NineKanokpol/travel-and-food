import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_and_food/pages/home_page.dart';
import 'package:travel_and_food/pages/sign_up_page.dart';
import 'package:travel_and_food/widget/loading_widget.dart';

import '../appManager/local_manager.dart';
import '../models/login_model.dart';
import '../models/user_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  LoginModel loginData = LoginModel();
  UserModel userDataValid = UserModel();
  bool loadingBtn = false;

  ///ตรวจสอบการ login จากบัญชีที่มีใน firebase
  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      loadingBtn = true;
    });
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // If sign-in is successful, navigate to the next screen or perform other actions
      String uid = userCredential.user!.uid;
      userDataValid.auth = uid;
      // Example: Get user data from Firestore based on UID
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      if (userData.data() != null) {
        Map<String, dynamic> userDataMap =
            userData.data() as Map<String, dynamic>;
        userDataMap.forEach((key, value) {
          if (key == "username") {
            userDataValid.password = value;
          } else if (key == "email") {
            userDataValid.email = value;
          } else if (key == "first_name") {
            userDataValid.firstName = value;
          } else if (key == "last_name") {
            userDataValid.lastName = value;
          }
          LocalStorageManager.saveLoginData(userDataValid);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        });
      }
      print('User Data: ${userData.data()}');
      setState(() {
        loadingBtn = false;
      });
    } catch (e) {
      // Handle sign-in errors
      setState(() {
        loadingBtn = false;
      });
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('Sign In Failed'),
              content: Text(e.toString()),
              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
      print('Failed to sign in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgGradient = LinearGradient(
      colors: [Color(0xFFFFD3D3), Color(0xFFEE7373)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset('assets/images/image_splash_screen.png',
                      width: 300, height: 300),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Sign In
                        Text(
                          'Sign In',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: doubleFieldValidator.validateEmail,
                          decoration: InputDecoration(
                            hintText: 'Email Address',
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: doubleFieldValidator.validate,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // LOG IN Button
                        GestureDetector(
                          onTap: () {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();
                              usernameFocusNode.unfocus();
                              passwordFocusNode.unfocus();
                              _signInWithEmailAndPassword();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD3D3), Color(0xFFEE7373)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: loadingBtn
                                  ? BaseLoadingAnimation()
                                  : Text(
                                      'LOG IN',
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Sign Up Prompt
                        Center(
                          child: RichText(
                            text: TextSpan(
                              text: 'Need an account? ',
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.black87),
                              children: [
                                TextSpan(
                                  text: 'Sign Up',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpPage()));
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///ตรวจสอบว่ากรอกข้อมูลครบและถูกต้องหรือไม่
class doubleFieldValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกข้อมูล";
    } else {
      return null;
    }
  }

  ///ตรวจสอบรูปแบบอีเมล
  static String? validateEmail(String? value) {
    final bool emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value ?? "");
    if (value == null || value.isEmpty) {
      return "กรุณากรอกข้อมูล";
    } else if (!emailValid) {
      return "รูปแบบอีเมลไม่ถูกต้อง";
    } else {
      return null;
    }
  }
}
