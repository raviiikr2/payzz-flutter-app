import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Transaction History",
        style: TextStyle(
          color: Colors.white
        ),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('transactions')
              .orderBy('date', descending: true)
              .snapshots(),
          builder: (context, snapshot) {

            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final transactions = snapshot.data!.docs;

            if (transactions.isEmpty) {
              return const Center(
                child: Text(
                  "No transactions yet",
                  style: TextStyle(color: Colors.white54),
                ),
              );
            }

            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {

                final data =
                    transactions[index].data() as Map<String, dynamic>;

                final isCredit = data['type'] == 'credit';
                final amount = data['amount'] ?? 0;
                final source = data['source'] ?? "Unknown";

                return ListTile(
                  title: Text(
                    source,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    "${isCredit ? "+" : "-"} ₹$amount",
                    style: TextStyle(
                      color: isCredit ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
