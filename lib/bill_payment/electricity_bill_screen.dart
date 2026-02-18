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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Electricity Bill",
            style: TextStyle(color: Colors.white)),
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

            const Text("Consumer Number",
                style: TextStyle(
                    color: Colors.white70)),
            const SizedBox(height: 8),

            _inputField(consumerController,
                "Enter consumer number"),

            const SizedBox(height: 20),

            const Text("Provider",
                style: TextStyle(
                    color: Colors.white70)),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedProvider,
              dropdownColor: Colors.grey[900],
              style:
                  const TextStyle(color: Colors.white),
              decoration: _inputDecoration(),
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

            const Text("Bill Amount",
                style: TextStyle(
                    color: Colors.white70)),
            const SizedBox(height: 8),

            _inputField(amountController,
                "Enter amount"),

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

  Widget _inputField(
      TextEditingController controller,
      String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style:
          const TextStyle(color: Colors.white),
      decoration: _inputDecoration(hint),
    );
  }

  InputDecoration _inputDecoration(
      [String? hint]) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: Colors.white12,
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
