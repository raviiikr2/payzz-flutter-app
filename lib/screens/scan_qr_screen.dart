import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:payzz/payment/pay_to_upi_screen.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isFlashOn = false;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [

          /// Camera Preview
          MobileScanner(
            controller: controller,
            onDetect: (barcodeCapture) async {
              if (isProcessing) return;

              final List<Barcode> barcodes = barcodeCapture.barcodes;

              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;

                if (code != null) {
                  isProcessing = true;
                  controller.stop();

                  String? upiId;

                  // Case 1: Full UPI URL
                  if (code.startsWith("upi://")) {
                    try {
                      final uri = Uri.parse(code);
                      upiId = uri.queryParameters['pa'];
                    } catch (_) {}
                  }

                  // Case 2: Direct UPI ID
                  else if (RegExp(r'^[\w.-]+@[\w.-]+$')
                      .hasMatch(code)) {
                    upiId = code;
                  }

                  if (upiId != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PayToUpiScreen(initialUpi: upiId),
                      ),
                    );
                  } else {
                    Navigator.pop(context);
                  }

                  break;
                }
              }
            },
          ),

          // Top Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [

                  // Back Button
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),

                  // Flash Toggle
                  IconButton(
                    onPressed: () async {
                      await controller.toggleTorch();
                      setState(() {
                        isFlashOn = !isFlashOn;
                      });
                    },
                    icon: Icon(
                      isFlashOn
                          ? Icons.flash_on
                          : Icons.flash_off,
                      color: isFlashOn
                          ? theme.colorScheme.primary
                          : Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Scanner Frame
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
