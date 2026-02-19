import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payzz/bill_payment/credit_card_bill_screen.dart';
import 'package:payzz/bill_payment/electricity_bill_screen.dart';
import 'package:payzz/payment/pay_to_upi_screen.dart';
import 'package:payzz/payment/send_to_bank_screen.dart';
import 'add_money_screen.dart';
import 'scan_qr_screen.dart';
import 'wallet_details_screen.dart';
import 'package:payzz/bill_payment/mobile_recharge_screen.dart';
import 'package:payzz/app_router.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Wallet"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Menu Coming Soon")),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.colorScheme.onSurface,
                    ),
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

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Wallet Balance",
                              style: TextStyle(
                                color: Colors.white
                                    ,
                              ),
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
                                color:
                                    Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              isBalanceVisible
                                  ? "₹ $balance"
                                  : "₹ ******",
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight:
                                    FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            ElevatedButton.icon(
                              style:
                                  ElevatedButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme
                                        .surface,
                                foregroundColor:
                                    theme.colorScheme
                                        .primary,
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                shape:
                                    RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius
                                          .circular(25),
                                ),
                              ),
                              icon: const Icon(
                                  Icons.add,
                                  size: 18),
                              label:
                                  const Text("Add"),
                              onPressed: () {
                                Navigator.of(context)
                                    .push(_createRoute());
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  /// PAY OPTIONS (4 Equal Buttons)
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      _actionButton(
                        context,
                        icon:
                            Icons.account_balance_wallet,
                        label: "Wallet",
                        onTap: () {
                          Navigator.of(context).push(
                            AppRouter.scale(
                              const WalletDetailsScreen(),
                            ),
                          );
                        },
                      ),
                      _actionButton(
                        context,
                        icon: Icons
                            .account_balance_wallet_outlined,
                        label: "Pay UPI",
                        onTap: () {
                           Navigator.of(context).push(
                            AppRouter.scale(
                              const PayToUpiScreen(),
                            ),
                          );
                          
                        },
                      ),
                      _actionButton(
                        context,
                        icon:
                            Icons.account_balance,
                        label: "Bank",
                        onTap: () {
                           Navigator.of(context).push(
                            AppRouter.scale(
                              const SendToBankScreen(),
                            ),
                          );
                        },
                      ),
                      _actionButton(
                        context,
                        icon:
                            Icons.qr_code_scanner,
                        label: "Scan",
                        onTap: () {
                          Navigator.of(context).push(
                            AppRouter.scale(
                              const ScanQrScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// BILL PAYMENTS
                  Text(
                    "Bill Payments",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          theme.colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      _actionButton(
                        context,
                        icon: Icons.phone_android,
                        label: "Mobile",
                        onTap: () {
                          Navigator.push(
                            context,
                            AppRouter.fade(
                              const MobileRechargeScreen(),
                            ),
                          );
                        },
                      ),
                      _actionButton(
                        context,
                        icon:
                            Icons.electric_bolt,
                        label: "Electricity",
                        onTap: () {
                          Navigator.push(
                            context,
                            AppRouter.fade(
                              const ElectricityBillScreen(),
                            ),
                          );
                        },
                      ),
                      _actionButton(
                        context,
                        icon: Icons.credit_card,
                        label: "Credit Card",
                        onTap: () {
                          Navigator.push(
                            context,
                            AppRouter.fade(
                              const CreditCardBillScreen(),
                            ),
                          );
                        },
                      ),
                      _actionButton(
                        context,
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

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 75,
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color:
                    theme.colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.colorScheme
                  .onSurface
                  ,
              fontSize: 11,
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
      SnackBar(content: Text("$title Coming Soon")),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration:
          const Duration(milliseconds: 350),
      pageBuilder:
          (_, animation, _) =>
              const AddMoneyScreen(),
      transitionsBuilder:
          (_, animation, _, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child:
              FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
