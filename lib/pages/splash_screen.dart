import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_guide/pages/signup.dart';
import 'package:gym_guide/pages/training.dart';
import 'package:gym_guide/services/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Check if user is already authenticated
    await authProvider.checkAuthState();

    Timer(const Duration(seconds: 2), () {
      if (authProvider.currentUser != null) {
        // User is logged in - go to training page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TrainingPage()),
        );
      } else {
        // User is not logged in - go to signup page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Image.asset(
            'assets/images/app_logo.png',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
