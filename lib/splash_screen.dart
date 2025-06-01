import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travel_and_food/pages/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ไล่เฉดสีจากบนลงล่าง
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD3D3), Color(0xFFEE7373)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Image.asset('assets/images/image_splash_screen.png',
              width: 500, height: 500),
        ),
      ),
    );
  }
}
