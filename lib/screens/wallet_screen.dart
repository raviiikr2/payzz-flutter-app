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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Wallet",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Menu Coming Soon")),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
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
              final data =
                  snapshot.data!.data() as Map<String, dynamic>;
              balance = (data['balance'] ?? 0).toDouble();
              name = data['name'] ?? "User";
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Welcome
                  Text(
                    "Welcome, $name",
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white),
                  ),

                  const SizedBox(height: 25),

                  /// WALLET CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
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
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        /// Title + Eye
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Wallet Balance",
                              style: TextStyle(
                                  color: Colors.white70),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isBalanceVisible =
                                      !isBalanceVisible;
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

                        /// Balance + Stylish Add Button
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          crossAxisAlignment:
                              CrossAxisAlignment.center,
                          children: [

                            /// Balance
                            Text(
                              isBalanceVisible
                                  ? "₹ $balance"
                                  : "₹ ******",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            /// Stylish Add Button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.25),
                                    blurRadius: 8,
                                    offset:
                                        const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.circular(
                                          30),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const AddMoneyScreen(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 22,
                                      vertical: 12,
                                    ),
                                    child: Row(
                                      mainAxisSize:
                                          MainAxisSize.min,
                                      children: const [
                                        Icon(
                                          Icons.add,
                                          color: Colors
                                              .deepPurple,
                                          size: 20,
                                        ),
                                        SizedBox(
                                            width: 6),
                                        Text(
                                          "Add Money",
                                          style: TextStyle(
                                            color: Colors
                                                .deepPurple,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// PAY OPTIONS
                  Wrap(
                    spacing: 25,
                    runSpacing: 25,
                    children: [
                      _actionButton(
                        icon:
                            Icons.account_balance_wallet,
                        label: "Pay to UPI ID",
                        onTap: () {
                          _comingSoon(context,
                              "Pay to UPI ID");
                        },
                      ),
                      _actionButton(
                        icon:
                            Icons.account_balance,
                        label: "Send to Bank",
                        onTap: () {
                          _comingSoon(context,
                              "Send to Bank");
                        },
                      ),
                      _actionButton(
                        icon:
                            Icons.qr_code_scanner,
                        label: "Scan",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const ScanQrScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// BILL PAYMENTS
                  const Text(
                    "Bill Payments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Wrap(
                    spacing: 25,
                    runSpacing: 25,
                    children: [
                      _actionButton(
                        icon: Icons.phone_android,
                        label: "Mobile",
                        onTap: () {
                          _comingSoon(context,
                              "Mobile Recharge");
                        },
                      ),
                      _actionButton(
                        icon:
                            Icons.electric_bolt,
                        label: "Electricity",
                        onTap: () {
                          _comingSoon(context,
                              "Electric Bill");
                        },
                      ),
                      _actionButton(
                        icon: Icons.credit_card,
                        label: "Credit Card",
                        onTap: () {
                          _comingSoon(context,
                              "Credit Card Bill");
                        },
                      ),
                      _actionButton(
                        icon: Icons.more_horiz,
                        label: "More",
                        onTap: () {
                          _comingSoon(context,
                              "More Services");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Colors.white12,
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _comingSoon(
      BuildContext context, String title) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
          content: Text("$title Coming Soon")),
    );
  }
}
