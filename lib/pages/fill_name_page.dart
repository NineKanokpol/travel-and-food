import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_and_food/pages/login_page.dart';
import 'package:travel_and_food/widget/loading_widget.dart';

class FillNamePage extends StatefulWidget {
  final String email;
  final String password;
  const FillNamePage({super.key, required this.email, required this.password});

  @override
  State<FillNamePage> createState() => _FillNamePageState();
}

class _FillNamePageState extends State<FillNamePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  bool isLoadingBtn = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _register() async {
    setState(() {
      isLoadingBtn = true;
    });
    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email.trim(),
        password: widget.password.trim(),
      );
      await FirebaseFirestore.instanceFor(app: Firebase.app())
          .collection('Users')
          .doc(userCredential.user!.uid)
          .set({
        'username': widget.email.trim(),
        'password': widget.password.trim(),
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
      });
      setState(() {
        isLoadingBtn = false;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print('Failed to create user: ${e.message}');
      isLoadingBtn = false;
      showCupertinoDialog(
          context: context,
          builder: (context){
            return CupertinoAlertDialog(
              title: Text('Error'),
              content: Text(e.message ?? 'An unexpected error occurred.'),
              actions: [
                CupertinoDialogAction(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    } catch (e) {
      print('Unexpected error: $e');
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Image.asset('assets/images/image_splash_screen.png',
                      width: 300, height: 300),
                ),
                Text(
                  'Welcome to Travel & Food',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Title
                      Text(
                        'Enter you name',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Email
                      TextFormField(
                        controller: _firstNameController,
                        validator: doubleFieldValidator.validate,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Firstname',
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
                        controller: _lastNameController,
                        validator: doubleFieldValidator.validate,
                        decoration: InputDecoration(
                          hintText: 'Lastname',
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

                      // Next button
                      GestureDetector(
                        onTap: () {
                          _register();
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
                            child: isLoadingBtn ? BaseLoadingAnimation():Text(
                              'Create account',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // เพิ่ม bottom padding ถ้าต้องการ
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class doubleFieldValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return "กรุณากรอกข้อมูล";
    } else {
      return null;
    }
  }
}
