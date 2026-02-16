import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_money_screen.dart';
import 'scan_qr_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),

      /// 🔥 APP BAR UPDATED
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white), // 3 line menu
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Menu feature coming soon"),
              ),
            );
          },
        ),
        title: const Text(
          "Wallet",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            double balance = 0;
            String name = "User";

            if (snapshot.hasData && snapshot.data!.exists) {
              final data = snapshot.data!.data() as Map<String, dynamic>;
              balance = (data['balance'] ?? 0).toDouble();
              name = data['name'] ?? "User";
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Welcome
                Text(
                  "Welcome, $name",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                /// FULL WIDTH BALANCE CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// Balance Title + Eye
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Wallet Balance",
                            style: TextStyle(color: Colors.white70),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isBalanceVisible = !isBalanceVisible;
                              });
                            },
                            icon: Icon(
                              isBalanceVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Text(
                        isBalanceVisible ? "₹ $balance" : "₹ ******",
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                /// ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _actionButton(
                      icon: Icons.add,
                      label: "Add",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AddMoneyScreen(),
                          ),
                        );
                      },
                    ),
                    _actionButton(
                      icon: Icons.send,
                      label: "Send",
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Send Money Coming Soon"),
                          ),
                        );
                      },
                    ),
                    _actionButton(
                      icon: Icons.qr_code_scanner,
                      label: "Scan",
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
              ],
            );
          },
        ),
      ),
    );
  }

  /// Reusable Action Button
  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: Colors.white12,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}
