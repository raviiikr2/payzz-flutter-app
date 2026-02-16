import 'package:flutter/material.dart';
import 'screens/auth_wrapper.dart';

class PayzzApp extends StatelessWidget {
  const PayzzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Payzz',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const AuthWrapper(),
    );
  }
}
