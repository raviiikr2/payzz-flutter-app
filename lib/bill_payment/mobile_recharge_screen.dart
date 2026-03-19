import 'package:flutter/material.dart';
import 'package:payzz/bill_payment/bill_status_screen.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  State<MobileRechargeScreen> createState() =>
      _MobileRechargeScreenState();
}

class _MobileRechargeScreenState
    extends State<MobileRechargeScreen> {
  final phoneController = TextEditingController();
  final amountController = TextEditingController();

  String selectedOperator = "Jio";

  final List<String> operators = [
    "Jio",
    "Airtel",
    "Vi",
    "BSNL"
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor:
          theme.scaffoldBackgroundColor,

     
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Mobile Recharge",
          style: TextStyle(color: Colors.white),
        ),
        leading: const BackButton(
          color: Colors.white,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            /// Phone Number
            Text(
              "Mobile Number",
              style: theme.textTheme.labelLarge!
                  .copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
              decoration: _inputDecoration(
                context: context,
                hint: "Enter 10-digit number",
              ),
            ),

            const SizedBox(height: 20),

            /// Operator
            Text(
              "Operator",
              style: theme.textTheme.labelLarge!
                  .copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: selectedOperator,
              dropdownColor:
                  colorScheme.surface,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
              decoration:
                  _inputDecoration(context: context),
              items: operators
                  .map(
                    (operator) =>
                        DropdownMenuItem(
                      value: operator,
                      child: Text(operator),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedOperator =
                      value!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// Amount
            Text(
              "Recharge Amount",
              style: theme.textTheme.labelLarge!
                  .copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: amountController,
              keyboardType:
                  TextInputType.number,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
              decoration: _inputDecoration(
                context: context,
                hint: "Enter amount",
              ),
            ),

            const SizedBox(height: 25),

            /// Quick Recharge
            Text(
              "Quick Recharge",
              style: theme.textTheme.labelLarge!
                  .copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 15),

            Wrap(
              spacing: 15,
              runSpacing: 15,
              children: [
                _quickAmount(context, 199),
                _quickAmount(context, 299),
                _quickAmount(context, 399),
                _quickAmount(context, 499),
              ],
            ),

            const SizedBox(height: 40),

            /// Recharge Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple,
                  padding:
                      const EdgeInsets
                          .symmetric(
                              vertical: 16),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            12),
                  ),
                ),
                onPressed: () {
                  final phone =
                      phoneController.text
                          .trim();
                  final amount =
                      double.tryParse(
                          amountController
                              .text
                              .trim());

                  if (phone.length != 10 ||
                      amount == null ||
                      amount <= 0) {
                    ScaffoldMessenger.of(
                            context)
                        .showSnackBar(
                      const SnackBar(
                          content: Text(
                              "Enter valid details")),
                    );
                    return;
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          BillStatusScreen(
                        amount: amount,
                        type:
                            "Mobile Recharge",
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Proceed to Recharge",
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _quickAmount(
      BuildContext context, int amount) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () {
        amountController.text =
            amount.toString();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 12),
        decoration: BoxDecoration(
          color: colorScheme
              .surfaceContainerHighest,
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Text(
          "₹ $amount",
          style: TextStyle(
            color:
                colorScheme.onSurface,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    String? hint,
  }) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color:
            colorScheme.onSurfaceVariant,
      ),
      filled: true,
      fillColor:
          colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
