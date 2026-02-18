import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool isFlashOn = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black, // keep camera background black
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        child: Stack(
          children: [

            /// Camera Preview
            MobileScanner(
              controller: controller,
              onDetect: (barcodeCapture) {
                final List<Barcode> barcodes = barcodeCapture.barcodes;

                for (final barcode in barcodes) {
                  final String? code = barcode.rawValue;

                  if (code != null) {
                    Navigator.pop(context, code);
                  }
                }
              },
            ),

            /// Top Bar
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15, vertical: 10),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [

                    /// Back Button
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: theme.colorScheme.onPrimary,
                        size: 28,
                      ),
                    ),

                    /// Flash Toggle
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
                            : theme.colorScheme.onPrimary,
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
      ),
    );
  }
}
