import 'package:flutter/material.dart';

class BillPaymentScreen extends StatelessWidget {
  const BillPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Bill Payments",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [

            _billCard(
              icon: Icons.phone_android,
              title: "Mobile Recharge",
              onTap: () {
                _comingSoon(context, "Mobile Recharge");
              },
            ),

            _billCard(
              icon: Icons.electric_bolt,
              title: "Electricity Bill",
              onTap: () {
                _comingSoon(context, "Electricity Bill");
              },
            ),

            _billCard(
              icon: Icons.credit_card,
              title: "Credit Card Bill",
              onTap: () {
                _comingSoon(context, "Credit Card Payment");
              },
            ),

            _billCard(
              icon: Icons.water_drop,
              title: "Water Bill",
              onTap: () {
                _comingSoon(context, "Water Bill");
              },
            ),

            _billCard(
              icon: Icons.wifi,
              title: "Broadband",
              onTap: () {
                _comingSoon(context, "Broadband Payment");
              },
            ),

            _billCard(
              icon: Icons.more_horiz,
              title: "More Services",
              onTap: () {
                _comingSoon(context, "More Services");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _billCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 40,
                color: Colors.deepPurple),
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$title Coming Soon")),
    );
  }
}
