import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qrcodeapp/QrcodeGenerator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:image_picker/image_picker.dart';

class Qrcodescanner extends StatefulWidget {
  const Qrcodescanner({super.key});

  @override
  State<Qrcodescanner> createState() => _QrcodescannerState();
}

class _QrcodescannerState extends State<Qrcodescanner> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _scanImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final MobileScannerController controller = MobileScannerController();
      final BarcodeCapture? capture = await controller.analyzeImage(image.path);
      if (capture != null) {
        final List<Barcode> barcodes = capture.barcodes;
        for (final barcode in barcodes) {
          if (barcode.rawValue != null) {
            _showBarcodeDialog(barcode.rawValue!);
          }
        }
      }
    }
  }

  void _showBarcodeDialog(String url) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: GestureDetector(
            onTap: () async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Text(
              url,
              style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Qrcodegenerator(),
                ),
              );
            },
            icon: Icon(Icons.qr_code),
          ),
          IconButton(
            onPressed: _scanImage,
            icon: Icon(Icons.photo),
          ),
        ],
      ),
      body: MobileScanner(
        controller: MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates),
        onDetect: (capture) {
          List<Barcode> list = capture.barcodes;
          final image = capture.image;
          for (final barcode in list) {
            _showBarcodeDialog(barcode.rawValue!);
          }
        },
      ),
    );
  }
}