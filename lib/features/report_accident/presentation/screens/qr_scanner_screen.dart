import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../providers/report_provider.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isProcessing = false;

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      final scannedCode = barcodes.first.rawValue!;
      setState(() {
        _isProcessing = true;
      });

      final provider = context.read<ReportProvider>();
      await provider.joinSession(scannedCode);

      if (mounted) {
        context.pushReplacement('/report/capture-evidence');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          MobileScanner(onDetect: _onDetect),
          if (_isProcessing) const Center(child: CircularProgressIndicator()),

          // Basic overlay to guide user
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: const Text(
              'Position the QR code within the view.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
