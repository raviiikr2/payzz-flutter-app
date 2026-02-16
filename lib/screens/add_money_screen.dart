import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen> {
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String selectedSource = "UPI";
  bool isLoading = false;

  final List<String> sources = ["UPI", "Bank Transfer", "Debit Card"];

  Future<void> addMoney() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid amount")),
      );
      return;
    }

    setState(() => isLoading = true);

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
        'source': selectedSource,
        'note': noteController.text.trim(),
        'date': FieldValue.serverTimestamp(),
      });
    });

    setState(() => isLoading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Add Money",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// Amount Field
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Enter Amount",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Source Dropdown
            DropdownButtonFormField<String>(
              value: selectedSource,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              items: sources
                  .map((source) => DropdownMenuItem(
                        value: source,
                        child: Text(source),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedSource = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Select Source",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Note Field
            TextField(
              controller: noteController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Note (Optional)",
                labelStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// Add Money Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : addMoney,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Add Money",
                        style: TextStyle(fontSize: 16,
                        color: Colors.white),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
