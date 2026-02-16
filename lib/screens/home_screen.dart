import 'package:flutter/material.dart';
import 'wallet_screen.dart';
import 'transaction_screen.dart';
import 'scan_qr_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    WalletScreen(),
    TransactionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        elevation: 8,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ScanQrScreen(),
            ),
          );
        },
        child: const Icon(Icons.qr_code_scanner, size: 28),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF1E1E1E),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.account_balance_wallet,
                  color: selectedIndex == 0
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),

              const SizedBox(width: 40),

              IconButton(
                icon: Icon(
                  Icons.history,
                  color: selectedIndex == 1
                      ? Colors.deepPurple
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
