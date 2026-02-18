import 'package:flutter/material.dart';
import 'bill_status_screen.dart';

class CreditCardBillScreen extends StatefulWidget {
  const CreditCardBillScreen({super.key});

  @override
  State<CreditCardBillScreen> createState() =>
      _CreditCardBillScreenState();
}

class _CreditCardBillScreenState
    extends State<CreditCardBillScreen> {

  final cardController =
      TextEditingController();
  final amountController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Credit Card Bill",
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            const Text("Card Number",
                style: TextStyle(
                    color: Colors.white70)),
            const SizedBox(height: 8),

            _inputField(cardController,
                "Enter card number"),

            const SizedBox(height: 20),

            const Text("Payment Amount",
                style: TextStyle(
                    color: Colors.white70)),
            const SizedBox(height: 8),

            _inputField(amountController,
                "Enter amount"),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(
                          vertical: 16),
                ),
                onPressed: () {
                  final amount = double.tryParse(
                      amountController.text);

                  if (cardController
                          .text.isEmpty ||
                      amount == null ||
                      amount <= 0) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Enter valid details")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          BillStatusScreen(
                        amount: amount,
                        type:
                            "Credit Card Bill",
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Pay Bill",
                  style: TextStyle(
                      fontWeight:
                          FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(
      TextEditingController controller,
      String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style:
          const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
