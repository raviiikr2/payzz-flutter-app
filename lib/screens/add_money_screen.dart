import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final amountController = TextEditingController();
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_SH6kWulpHBxkrq', // 🔴 Replace this
      'amount': (amount * 100).toInt(), // paise
      'name': 'Payzz Wallet',
      'description': 'Add Money',
      'prefill': {
        'contact': '9999999999',
        'email': FirebaseAuth.instance.currentUser?.email ?? ''
      }
    };

    _razorpay.open(options);
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    double amount = double.parse(amountController.text);

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);
      double currentBalance = 0;

      if (snapshot.exists) {
        currentBalance = (snapshot.data()?['balance'] ?? 0).toDouble();
      }

      double newBalance = currentBalance + amount;

      transaction.set(userRef, {
        'balance': newBalance,
      }, SetOptions(merge: true));

      final transactionRef = userRef.collection('transactions').doc();

      transaction.set(transactionRef, {
        'type': 'credit',
        'amount': amount,
        'source': 'Razorpay',
        'date': FieldValue.serverTimestamp(),
        'paymentId': response.paymentId,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful")),
    );

    Navigator.pop(context);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed")),
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Money")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Enter Amount"),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                double? amount =
                    double.tryParse(amountController.text.trim());
                if (amount != null && amount > 0) {
                  openCheckout(amount);
                }
              },
              child: const Text("Pay with Razorpay"),
            ),
          ],
        ),
      ),
    );
  }
}
