import 'package:flutter/material.dart';
import 'package:payzz/bill_payment/bill_status_screen.dart';

class PayToUpiScreen extends StatefulWidget {
  const PayToUpiScreen({super.key});

  @override
  State<PayToUpiScreen> createState() => _PayToUpiScreenState();
}

class _PayToUpiScreenState extends State<PayToUpiScreen> {
  final upiController = TextEditingController();
  final amountController = TextEditingController();

  bool isValidUpi(String upi) {
    final regex = RegExp(r'^[\w.-]+@[\w.-]+$');
    return regex.hasMatch(upi);
  }

  Future<void> processPayment() async {
    final upi = upiController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (!isValidUpi(upi)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid UPI ID (example@bank)")),
      );
      return;
    }

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid amount")),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BillStatusScreen(
          amount: amount,
          type: "UPI Payment",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay to UPI ID"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 UPI FIELD CARD
            Text(
              "UPI ID",
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.alternate_email),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: upiController,
                      decoration: const InputDecoration(
                        hintText: "example@bank",
                        border: InputBorder.none,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),

                  if (isValidUpi(upiController.text))
                    const Icon(Icons.check_circle,
                        color: Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔹 AMOUNT SECTION
            Text(
              "Amount",
              style: theme.textTheme.labelMedium,
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Text(
                    "₹",
                    style: theme.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.headlineSmall,
                      decoration: const InputDecoration(
                        hintText: "Enter amount",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Quick Amount Chips
            Wrap(
              spacing: 10,
              children: [
                _amountChip(100),
                _amountChip(500),
                _amountChip(1000),
                _amountChip(2000),
              ],
            ),

            const SizedBox(height: 40),

            /// 🔹 PAY BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: processPayment,
                child:  Text(
                  "Pay Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountChip(int amount) {
    return GestureDetector(
      onTap: () {
        amountController.text = amount.toString();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withAlpha(15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "₹ $amount",
          style: const TextStyle(
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
