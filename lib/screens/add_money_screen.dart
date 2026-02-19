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
  final TextEditingController amountController = TextEditingController();
  late Razorpay _razorpay;

  bool isLoading = false;

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
    amountController.dispose();
    super.dispose();
  }

  void openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_SH6kWulpHBxkrq',
      'amount': (amount * 100).toInt(),
      'name': 'Payzz Wallet',
      'description': 'Add Money',
      'prefill': {
        'contact': '9999999999',
        'email': FirebaseAuth.instance.currentUser?.email ?? '',
      },
    };

    _razorpay.open(options);
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    double amount = double.tryParse(amountController.text) ?? 0;

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(userRef);

      double currentBalance = 0;
      if (snapshot.exists) {
        currentBalance = (snapshot.data()?['balance'] ?? 0).toDouble();
      }

      double newBalance = currentBalance + amount;

      transaction.set(
        userRef,
        {'balance': newBalance},
        SetOptions(merge: true),
      );

      final transactionRef = userRef.collection('transactions').doc();

      transaction.set(transactionRef, {
        'type': 'credit',
        'amount': amount,
        'source': 'Razorpay',
        'date': FieldValue.serverTimestamp(),
        'paymentId': response.paymentId,
      });
    });

    amountController.clear();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Successful 🎉")),
    );

    setState(() => isLoading = false);
    Navigator.pop(context);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Payment Failed ❌")),
    );

    setState(() => isLoading = false);
  }

  void handleExternalWallet(ExternalWalletResponse response) {}

  Widget _quickAmountButton(String amount) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () => amountController.text = amount,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          "₹$amount",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: const Text("Add Money"),
        backgroundColor: colorScheme.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),

            Text(
              "Top up your wallet",
              style: theme.textTheme.titleMedium,
            ),

            const SizedBox(height: 25),

            /// Card Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: theme.brightness == Brightness.dark
                        ? Colors.black.withOpacity(0.4)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: 15,
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    "Enter Amount",
                    style: theme.textTheme.labelLarge,
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    style: theme.textTheme.headlineSmall,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.currency_rupee),
                      hintText: "0.00",
                      filled: true,
                      fillColor: colorScheme.surfaceVariant,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _quickAmountButton("100"),
                      _quickAmountButton("500"),
                      _quickAmountButton("1000"),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () {
                              FocusScope.of(context).unfocus();

                              double? amount = double.tryParse(
                                  amountController.text.trim());

                              if (amount == null || amount <= 0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Please enter valid amount")),
                                );
                                return;
                              }

                              setState(() => isLoading = true);
                              openCheckout(amount);
                            },
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          :  Text(
                              "Pay with Razorpay",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
