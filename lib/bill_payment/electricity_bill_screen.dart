import 'package:flutter/material.dart';
import 'package:payzz/bill_payment/bill_status_screen.dart';

class ElectricityBillScreen extends StatefulWidget {
  const ElectricityBillScreen({super.key});

  @override
  State<ElectricityBillScreen> createState() =>
      _ElectricityBillScreenState();
}

class _ElectricityBillScreenState
    extends State<ElectricityBillScreen> {

  final consumerController = TextEditingController();
  final amountController = TextEditingController();

  String selectedProvider = "State Electricity Board";

  final List<String> providers = [
    "State Electricity Board",
    "Tata Power",
    "Adani Electricity",
    "BSES",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// Keep AppBar Color Same
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Electricity Bill",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            Text(
              "Consumer Number",
              style: theme.textTheme.labelLarge!
                  .copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            _inputField(
              controller: consumerController,
              hint: "Enter consumer number",
              context: context,
            ),

            const SizedBox(height: 20),

            Text(
              "Provider",
              style: theme.textTheme.labelLarge!
                  .copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedProvider,
              dropdownColor: colorScheme.surface,
              style: TextStyle(
                color: colorScheme.onSurface,
              ),
              decoration: _inputDecoration(
                  context: context),
              items: providers
                  .map((provider) =>
                      DropdownMenuItem(
                        value: provider,
                        child: Text(provider),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedProvider = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            Text(
              "Bill Amount",
              style: theme.textTheme.labelLarge!
                  .copyWith(
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            _inputField(
              controller: amountController,
              hint: "Enter amount",
              context: context,
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.deepPurple,
                  padding:
                      const EdgeInsets.symmetric(
                          vertical: 16),
                ),
                onPressed: () {
                  final amount = double.tryParse(
                      amountController.text);

                  if (consumerController
                          .text.isEmpty ||
                      amount == null ||
                      amount <= 0) {
                    ScaffoldMessenger.of(context)
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
                            "Electricity Bill",
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Pay Bill",
                  style: TextStyle(
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

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required BuildContext context,
  }) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: colorScheme.onSurface,
      ),
      decoration: _inputDecoration(
        context: context,
        hint: hint,
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
        color: colorScheme.onSurfaceVariant,
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
