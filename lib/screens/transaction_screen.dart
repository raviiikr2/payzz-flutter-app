import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Transactions"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('transactions')
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          }

          final transactions = snapshot.data!.docs;

          if (transactions.isEmpty) {
            return Center(
              child: Text(
                "No transactions yet",
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withAlpha(60),
                ),
              ),
            );
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {

                final data =
                    transactions[index].data() as Map<String, dynamic>;

                final isCredit = data['type'] == 'credit';
                final amount = data['amount'] ?? 0;
                final source = data['source'] ?? "Unknown";

                final timestamp = data['date'];
                String formattedDate = "";

                if (timestamp != null) {
                  final date =
                      (timestamp as Timestamp).toDate();
                  formattedDate =
                      DateFormat('dd MMM yyyy • hh:mm a')
                          .format(date);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [

                      /// Transaction Icon
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: isCredit
                              ? Colors.green.withAlpha(605)
                              : Colors.red.withAlpha(605),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCredit
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          color:
                              isCredit ? Colors.green : Colors.red,
                        ),
                      ),

                      const SizedBox(width: 15),

                      /// Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              source,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withAlpha(60),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Amount
                      Text(
                        "${isCredit ? "+" : "-"} ₹$amount",
                        style: TextStyle(
                          color:
                              isCredit ? Colors.green : Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
