import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qrcodeapp/QrcodeScanner.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'dart:typed_data';

class Qrcodegenerator extends StatefulWidget {
  const Qrcodegenerator({super.key});

  @override
  State<Qrcodegenerator> createState() => _QrcodegeneratorState();
}

class _QrcodegeneratorState extends State<Qrcodegenerator> {
  String? qrData;
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> _saveQrCode() async {
    if (qrData != null) {
      // Wait for a short period to ensure the widget is fully rendered
      await Future.delayed(Duration(milliseconds: 100));
      final Uint8List? image = await screenshotController.capture();
      if (image != null) {
        final result = await ImageGallerySaverPlus.saveImage(image);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['isSuccess'] ? 'QR Code saved!' : 'Failed to save QR Code')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Qrcodescanner(),
                ),
              );
            },
            icon: Icon(Icons.qr_code_scanner_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onSubmitted: (event) {
                setState(() {
                  qrData = event;
                });
              },
            ),
            SizedBox(height: 20),
            if (qrData != null)
              Screenshot(
                controller: screenshotController,
                child: Container(
                  color: Colors.white, // Thêm màu nền
                  child: PrettyQr(
                    data: qrData!,
                    size: 200,
                    roundEdges: true,
                  ),
                ),
              ),

            SizedBox(height: 20),
            if (qrData != null)
              ElevatedButton(
                onPressed: _saveQrCode,
                child: Text('Save QR Code'),
              ),
          ],
        ),
      ),
    );
  }
}