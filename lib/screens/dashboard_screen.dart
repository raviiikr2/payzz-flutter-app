import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_money_screen.dart';
import 'send_money_screen.dart';
import 'scan_qr_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text("Payzz", style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Welcome Section
StreamBuilder<DocumentSnapshot>(
  stream: FirebaseFirestore.instance
      .collection('users')
      .doc(user!.uid)
      .snapshots(),
  builder: (context, snapshot) {

    String name = "User";

    if (snapshot.hasData && snapshot.data!.exists) {
      final data = snapshot.data!.data() as Map<String, dynamic>;
      name = data['name'] ?? "User";
    }

    return Text(
      "Welcome, $name",
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  },
),


            const SizedBox(height: 30),

            /// Wallet Balance Card
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                double balance = 0;

                if (snapshot.hasData && snapshot.data!.exists) {
                  final data =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  balance = (data?['balance'] ?? 0).toDouble();
                }

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Wallet Balance",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "₹ $balance",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            /// Quick Actions Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _modernActionButton(
                    icon: Icons.add_circle_outline,
                    label: "Add",
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddMoneyScreen(),
                        ),
                      );
                    },
                  ),
                  _modernActionButton(
                    icon: Icons.send_rounded,
                    label: "Send",
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SendMoneyScreen(),
                        ),
                      );
                    },
                  ),
                  _modernActionButton(
                    icon: Icons.qr_code_scanner,
                    label: "Scan",
                    color: Colors.deepPurple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ScanQrScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            /// Transactions Title
            const Text(
              "Recent Transactions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            /// Transactions List
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .collection('transactions')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final transactions = snapshot.data!.docs;

                if (transactions.isEmpty) {
                  return const Text(
                    "No transactions yet",
                    style: TextStyle(color: Colors.white54),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final data = transactions[index].data()
                        as Map<String, dynamic>;

                    final isCredit = data['type'] == 'credit';
                    final source = data['source'] ?? "Unknown";
                    final amount = data['amount'] ?? 0;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        source,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Text(
                        "${isCredit ? "+" : "-"} ₹$amount",
                        style: TextStyle(
                          color: isCredit
                              ? Colors.green
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Modern Action Button
  static Widget _modernActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
