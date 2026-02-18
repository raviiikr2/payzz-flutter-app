import 'package:flutter/material.dart';
import 'auth_wrapper.dart';

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
        scaffoldBackgroundColor:Theme.of(context).scaffoldBackgroundColor,
      ),
      home: const AuthWrapper(),
    );
  }
}
