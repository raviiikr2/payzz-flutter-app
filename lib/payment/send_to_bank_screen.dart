import 'package:flutter/material.dart';
import 'package:payzz/bill_payment/bill_status_screen.dart';

class SendToBankScreen extends StatefulWidget {
  const SendToBankScreen({super.key});

  @override
  State<SendToBankScreen> createState() => _SendToBankScreenState();
}

class _SendToBankScreenState extends State<SendToBankScreen> {
  final accountController = TextEditingController();
  final ifscController = TextEditingController();
  final amountController = TextEditingController();

  bool isValidIfsc(String ifsc) {
    final regex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    return regex.hasMatch(ifsc);
  }

  Future<void> processTransfer() async {
    final account = accountController.text.trim();
    final ifsc = ifscController.text.trim().toUpperCase();
    final amount = double.tryParse(amountController.text.trim());

    if (account.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Account Number")),
      );
      return;
    }

    if (!isValidIfsc(ifsc)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid IFSC Code")),
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
          type: "Bank Transfer",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Send to Bank")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 Account Number
            Text("Account Number", style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.account_balance),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: accountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: "Enter Account Number",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// 🔹 IFSC
            Text("IFSC Code", style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.confirmation_number),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: ifscController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        hintText: "ABCD0123456",
                        border: InputBorder.none,
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  if (isValidIfsc(ifscController.text.toUpperCase()))
                    const Icon(Icons.check_circle, color: Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔹 Amount
            Text("Amount", style: theme.textTheme.labelMedium),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                _amountChip(1000),
                _amountChip(5000),
                _amountChip(10000),
                _amountChip(20000),
              ],
            ),

            const SizedBox(height: 40),

            /// 🔹 Transfer Button
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
                onPressed: processTransfer,
                child: Text(
                  "Transfer Now",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimary,
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
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withAlpha(15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "₹ $amount",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
