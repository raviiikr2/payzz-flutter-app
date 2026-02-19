import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,

      /// ✅ Back Button AppBar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Menu"),
      ),

      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .get(),
        builder: (context, snapshot) {
          double balance = 0;

          if (snapshot.hasData && snapshot.data!.exists) {
            balance = (snapshot.data!.get('balance') ?? 0).toDouble();
          }

          return Column(
            children: [
              /// Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      /// 👤 Profile Section
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 35,
                            backgroundColor: colorScheme.primaryContainer,
                            child: const Text(
                              "😊",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.displayName ?? "Ravi Kumar",
                                  style: theme.textTheme.titleLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user?.email ?? "",
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// 💰 Wallet Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Wallet Balance",
                              style: theme.textTheme.labelLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "₹${balance.toStringAsFixed(2)}",
                              style: theme.textTheme.headlineMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/addMoney');
                                },
                                child: const Text("Add Money"),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 35),

                      /// Manage Section
                      Text(
                        "Manage",
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text("Edit Profile"),
                        onTap: () {},
                      ),

                      const SizedBox(height: 30),

                      /// Support Section
                      Text(
                        "Support & Settings",
                        style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      ListTile(
                        leading: const Icon(Icons.help_outline),
                        title: const Text("Help"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.privacy_tip_outlined),
                        title: const Text("Privacy Policy"),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.info_outline),
                        title: const Text("About"),
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔴 Sign Out Button (Fixed at Bottom)
              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("Sign Out"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.error,
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).popUntil((route) => route.isFirst);
                      }
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
