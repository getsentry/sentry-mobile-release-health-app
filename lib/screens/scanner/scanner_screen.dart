import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../utils/sentry_colors.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  QRViewController _controller;
  final GlobalKey _scannerKey = GlobalKey(debugLabel: 'QR');
  var _popped = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller.pauseCamera();
    }
    _controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Token'),
      ),
      body: Stack(
        children: [
          _buildQrView(context),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FutureBuilder(
                  future: _controller?.getCameraInfo(),
                  builder: (context, snapshot) {
                    return IconButton(
                        icon: Icon(
                          snapshot.data == CameraFacing.back ? Icons.switch_camera_outlined : Icons.switch_camera,
                          color: Colors.white,
                          size: 24.0,
                        ),
                        onPressed: () async {
                          await _controller?.flipCamera();
                          setState(() {});
                        }
                    );
                  }
                )
              ],
            ),
          )
        ]
      )
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildQrView(BuildContext context) {
    final minWidthHeight = min(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height
    );
    return QRView(
      key: _scannerKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: SentryColors.buttercup,
          borderRadius: 12,
          borderLength: 32,
          borderWidth: 12,
          cutOutSize: minWidthHeight  * 2 / 3
      ),
    );
  }

  // Helper

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData?.code != null) {
        _popIfPossible(scanData?.code);
      }
    });
  }

  void _popIfPossible(String result) {
    if (mounted && !_popped) {
      _popped = true; // Don't dismiss multiple times.
      Navigator.pop(context, result);
    }
  }
}