import 'package:flutter/material.dart';
import 'package:plot_twist/features/auth/presentation/pages/login_page.dart';
import 'package:plot_twist/features/auth/presentation/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // Initially, show the login page
  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        showRegisterPage: toggleScreens,
      ); // Pass the toggle function
    } else {
      return RegisterPage(
        showLoginPage: toggleScreens,
      ); // Pass the toggle function
    }
  }
}
