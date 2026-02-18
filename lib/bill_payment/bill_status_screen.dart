import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BillStatusScreen extends StatefulWidget {
  final double amount;
  final String type;

  const BillStatusScreen({
    super.key,
    required this.amount,
    required this.type,
  });

  @override
  State<BillStatusScreen> createState() =>
      _BillStatusScreenState();
}

class _BillStatusScreenState
    extends State<BillStatusScreen> {

  bool isSuccess = false;
  bool isFailed = false;
  String message = "Processing Payment...";

  @override
  void initState() {
    super.initState();
    _processPayment();
  }

  Future<void> _processPayment() async {

    await Future.delayed(const Duration(seconds: 2));

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {

      final snapshot = await transaction.get(userRef);

      double currentBalance = 0;

      if (snapshot.exists) {
        currentBalance =
            (snapshot.data()?['balance'] ?? 0).toDouble();
      }

      /// 🔴 Insufficient Balance Check
      if (currentBalance < widget.amount) {
        setState(() {
          isFailed = true;
          message = "Insufficient Balance";
        });
        return;
      }

      double newBalance = currentBalance - widget.amount;

      transaction.update(userRef, {
        'balance': newBalance,
      });

      final txnRef =
          userRef.collection('transactions').doc();

      transaction.set(txnRef, {
        'type': 'debit',
        'amount': widget.amount,
        'source': widget.type,
        'date': FieldValue.serverTimestamp(),
      });
    });

    if (!isFailed) {
      setState(() {
        isSuccess = true;
        message = "Payment Successful";
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    Color backgroundColor =
        isSuccess ? Colors.green :
        isFailed ? Colors.red :
        const Color(0xFF121212);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: isSuccess || isFailed
            ? Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [

                  Icon(
                    isSuccess
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: Colors.white,
                    size: 90,
                  ),

                  const SizedBox(height: 20),

                  Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "₹ ${widget.amount}",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(
                        color: isSuccess
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: const [

                  CircularProgressIndicator(
                      color: Colors.white),

                  SizedBox(height: 20),

                  Text(
                    "Processing Payment...",
                    style:
                        TextStyle(color: Colors.white),
                  ),
                ],
              ),
      ),
    );
  }
}
