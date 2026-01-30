import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

enum ScannerState { idle, scanning, success, error }

class QRScanResult {
  final String code;
  final DateTime timestamp;
  final String type;

  QRScanResult({
    required this.code,
    required this.timestamp,
    required this.type,
  });
}

class QRScannerController extends ChangeNotifier {
  MobileScannerController? _cameraController;
  ScannerState _scannerState = ScannerState.idle;
  bool _isFlashOn = false;
  bool _isCameraInitialized = false;
  String? _lastScannedCode;
  QRScanResult? _lastScanResult;
  String? _errorMessage;
  bool _isLoading = false;

  // Public getters
  MobileScannerController? get cameraController => _cameraController;
  ScannerState get scannerState => _scannerState;
  bool get isFlashOn => _isFlashOn;
  bool get isCameraInitialized => _isCameraInitialized;
  String? get lastScannedCode => _lastScannedCode;
  QRScanResult? get lastScanResult => _lastScanResult;
  String? get error => _errorMessage;
  bool get isLoading => _isLoading;

  QRScannerController() {
    _initializeCamera();
  }

  // Initialize camera
  Future<void> _initializeCamera() async {
    try {
      _scannerState = ScannerState.scanning;
      notifyListeners();

      _cameraController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: _isFlashOn,
      );

      // Listen for scan results
      _cameraController!.start();
      
      _cameraController!.barcodes.listen((capture) {
        if (capture.barcodes.isNotEmpty && _scannerState == ScannerState.scanning) {
          final barcode = capture.barcodes.first;
          if (barcode.rawValue != null) {
            _onBarcodeDetected(barcode.rawValue!);
          }
        }
      });

      _isCameraInitialized = true;
      _scannerState = ScannerState.idle;
    } catch (e) {
      _errorMessage = 'فشل في تهيئة الكاميرا: ${e.toString()}';
      _scannerState = ScannerState.error;
    }
    notifyListeners();
  }

  // Handle barcode detection
  void _onBarcodeDetected(String code) {
    _lastScannedCode = code;
    _lastScanResult = QRScanResult(
      code: code,
      timestamp: DateTime.now(),
      type: _getQRCodeType(code),
    );
    _scannerState = ScannerState.success;
    notifyListeners();

    // Auto-reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (_scannerState == ScannerState.success) {
        _resetScanner();
      }
    });
  }

  // Determine QR code type
  String _getQRCodeType(String code) {
    if (code.startsWith('http') || code.startsWith('www')) {
      return 'url';
    } else if (code.contains('@')) {
      return 'email';
    } else if (RegExp(r'^\d+$').hasMatch(code)) {
      return 'number';
    } else {
      return 'text';
    }
  }

  // Start scanning
  void startScanning() {
    if (_cameraController != null) {
      _scannerState = ScannerState.scanning;
      notifyListeners();
    }
  }

  // Stop scanning
  void stopScanning() {
    _scannerState = ScannerState.idle;
    notifyListeners();
  }

  // Reset scanner
  void _resetScanner() {
    _lastScannedCode = null;
    _scannerState = ScannerState.scanning;
    notifyListeners();
  }

  // Toggle flash
  Future<void> toggleFlash() async {
    if (_cameraController != null) {
      try {
        _isFlashOn = !_isFlashOn;
        await _cameraController!.toggleTorch();
        notifyListeners();
      } catch (e) {
        _errorMessage = 'فشل في تشغيل/إيقاف الفلاش: ${e.toString()}';
        notifyListeners();
      }
    }
  }

  // Switch camera
  Future<void> switchCamera() async {
    if (_cameraController != null) {
      try {
        await _cameraController!.switchCamera();
        notifyListeners();
      } catch (e) {
        _errorMessage = 'فشل في تبديل الكاميرا: ${e.toString()}';
        notifyListeners();
      }
    }
  }

  // Process scanned code
  Future<bool> processScannedCode(String code) async {
    try {
      // Simulate processing/validating the QR code
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In real app, this would:
      // - Validate the QR code format
      // - Check if it's a valid promotion code
      // - Save to backend
      // - Navigate to appropriate screen
      
      return true;
    } catch (e) {
      _errorMessage = 'فشل في معالجة الرمز: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  // Save scan result
  void saveScanResult() {
    if (_lastScanResult != null) {
      // In real app, save to database or API
      debugPrint('Saved scan result: ${_lastScanResult!.code}');
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear last scan
  void clearLastScan() {
    _lastScannedCode = null;
    _lastScanResult = null;
    notifyListeners();
  }

  // Dispose camera
  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }
}
