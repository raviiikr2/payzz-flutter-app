import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payzz/screens/home_screen.dart';

class BillStatusScreen extends StatefulWidget {
  final double amount;
  final String type;

  const BillStatusScreen({super.key, required this.amount, required this.type});

  @override
  State<BillStatusScreen> createState() => _BillStatusScreenState();
}

class _BillStatusScreenState extends State<BillStatusScreen> {
  bool isSuccess = false;
  bool isFailed = false;
  String message = "Processing Payment...";
  String transactionId = "";

  @override
  void initState() {
    super.initState();
    _processPayment();
  }

  Future<void> _processPayment() async {
    await Future.delayed(const Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);

        double currentBalance = (snapshot.data()?['balance'] ?? 0).toDouble();

        /// 🔴 Insufficient Balance
        if (currentBalance < widget.amount) {
          throw Exception("Insufficient");
        }

        double newBalance = currentBalance - widget.amount;

        /// Generate Transaction ID
        transactionId =
            "TXN${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(999)}";

        /// Update Balance
        transaction.update(userRef, {'balance': newBalance});

        /// Add Transaction Entry
        final txnRef = userRef.collection('transactions').doc();

        transaction.set(txnRef, {
          'type': 'debit',
          'amount': widget.amount,
          'source': widget.type,
          'txnId': transactionId,
          'date': FieldValue.serverTimestamp(),
        });
      });

      setState(() {
        isSuccess = true;
        message = "Payment Successful";
      });
    } catch (e) {
      setState(() {
        isFailed = true;
        message = "Insufficient Balance";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = isSuccess
        ? Colors.green
        : isFailed
        ? Colors.red
        : const Color(0xFF121212);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: isSuccess || isFailed
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isSuccess ? Icons.check_circle : Icons.cancel,
                    color: Colors.white,
                    size: 90,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "₹ ${widget.amount}",
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  if (isSuccess) ...[
                    const SizedBox(height: 10),
                    Text(
                      "Transaction ID:",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transactionId,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: isSuccess ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.white),
                  SizedBox(height: 20),
                  Text(
                    "Processing Payment...",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
