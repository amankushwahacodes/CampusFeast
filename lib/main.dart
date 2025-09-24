import 'package:flutter/material.dart';
import 'package:campus_feast/theme.dart';
import 'package:campus_feast/screens/auth/login_screen.dart';
import 'package:campus_feast/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Feast',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isLoggedIn = false; // In real app, check from shared preferences

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? const MainScreen() : const LoginScreen();
  }
}
