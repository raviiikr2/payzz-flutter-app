import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletDetailsScreen extends StatelessWidget {
  const WalletDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("My Wallet"),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          double balance = 0;

          if (snapshot.hasData && snapshot.data!.exists) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            balance = (data['balance'] ?? 0).toDouble();
          }

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            child: Column(
              children: [

                /// BALANCE CARD
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.deepPurple,
                        Colors.purpleAccent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Wallet Balance",
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary
                              .withAlpha(60),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "₹ ${balance.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// TRANSACTION TITLE
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Transaction History",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// TRANSACTION LIST
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user.uid)
                        .collection('transactions')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(
                            color:
                                theme.colorScheme.primary,
                          ),
                        );
                      }

                      final transactions =
                          snapshot.data!.docs;

                      if (transactions.isEmpty) {
                        return Center(
                          child: Text(
                            "No Transactions Yet",
                            style: TextStyle(
                              color: theme
                                  .colorScheme.onSurface
                                  .withAlpha(60),
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: transactions.length,
                        itemBuilder: (context, index) {
                          final data =
                              transactions[index].data()
                                  as Map<String, dynamic>;

                          final type =
                              data['type'] ?? '';
                          final amount =
                              (data['amount'] ?? 0)
                                  .toDouble();

                          final isCredit =
                              type == 'credit';

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  isCredit
                                      ? Colors.green
                                          .withAlpha(60)
                                      : Colors.red
                                          .withAlpha(60),
                              child: Icon(
                                isCredit
                                    ? Icons.arrow_downward
                                    : Icons.arrow_upward,
                                color: isCredit
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                            title: Text(
                              isCredit
                                  ? "Money Added"
                                  : "Money Sent",
                              style: TextStyle(
                                color: theme
                                    .colorScheme
                                    .onSurface,
                              ),
                            ),
                            subtitle: Text(
                              data['source'] ?? '',
                              style: TextStyle(
                                color: theme
                                    .colorScheme
                                    .onSurface
                                    .withAlpha(60),
                              ),
                            ),
                            trailing: Text(
                              isCredit
                                  ? "+ ₹$amount"
                                  : "- ₹$amount",
                              style: TextStyle(
                                color: isCredit
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
