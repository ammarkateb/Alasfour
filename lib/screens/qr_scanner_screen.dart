import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../widgets/shared_nav.dart';
import '../controllers/qr_scanner_controller.dart';
import '../utils/scanner_overlay_painter.dart';

class QRScannerScreen extends StatelessWidget {
  QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QRScannerController(),
      child: Consumer<QRScannerController>(
        builder: (context, controller, _) {
          final topPadding = MediaQuery.of(context).padding.top;

          if (controller.scannerState == ScannerState.scanning && controller.isCameraInitialized) {
            return _buildCameraView(controller);
          }

          return Scaffold(
            backgroundColor: Colors.white,
            extendBody: true,
            body: Stack(
              children: [
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (controller.error != null)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'خطأ في الكاميرا',
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.error!,
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.startScanning(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  )
                else
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(top: 295, bottom: 120),
                      child: _buildContent(controller),
                    ),
                  ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildCustomHeader(context, topPadding, controller),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: buildSharedBottomNav(context),
                ),
                // Floating gold home button
                buildFloatingHomeButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context, double topPadding, QRScannerController controller) {
    return Builder(
      builder: (context) => SizedBox(
        height: 320, // Adjusted to 320
        child: Stack(
          children: [
            // Red background with curve - increased height
            ClipPath(
              clipper: HeaderCurveClipper(),
              child: Container(
                height: 255, // Increased to match 320 header height
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFC81419),  // Upper-middle
                      Color(0xFFD41419),  // Middle
                      Color(0xFFDF1619),  // Lower-middle
                      Color(0xFFE31719),  // Bottom
                      Color(0xFFE91A19),  // Bottom-most
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            // Header content - top row stays in place
          Padding(
            padding: EdgeInsets.only(top: kIsWeb ? topPadding + 8 : 8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNotificationBell(context),
                  _buildCenterLogo(),
                  _buildProfileAvatar(context),
                ],
              ),
            ),
          ),
          // Header text - positioned correctly on the right side
          Positioned(
            top: 180,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'السحب الكبير',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  'فرصة دخول حصرية',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView(QRScannerController controller) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera view
          Positioned.fill(
            child: MobileScanner(
              controller: controller.cameraController,
              onDetect: (capture) {
                // Controller already handles detection via barcodes stream
              },
              errorBuilder: (context, error, child) {
                return Center(
                  child: Text(
                    'خطأ في الكاميرا: ${error.errorCode}',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
          
          // Scanner overlay
          Positioned.fill(
            child: CustomPaint(
              painter: ScannerOverlayPainter(),
            ),
          ),
          
          // Success overlay
          if (controller.scannerState == ScannerState.success && controller.lastScannedCode != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'تم المسح بنجاح!',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.lastScannedCode!,
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => controller.clearLastScan(),
                          child: const Text('مسح رمز آخر'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          
          // Top controls
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Close button
                GestureDetector(
                  onTap: () => controller.stopScanning(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                
                // Flash toggle
                GestureDetector(
                  onTap: () => controller.toggleFlash(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      controller.isFlashOn ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(QRScannerController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8), // Reduced from 32 to 8
      child: Column(
        children: [
          Text(
            'وجّه كاميرا هاتفك نحو أي رمز للمسابقة لتكشف عن جائزتك الفورية.',
            style: GoogleFonts.tajawal(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 15), // Reduced from 25 to raise button 10 more
          // QR Icon
          Container(
            width: double.infinity,
            height: 220, // Reduced height
            margin: const EdgeInsets.symmetric(horizontal: 20), // Same margin as red button
            decoration: BoxDecoration(
              color: Color(0xFFFFFEFA), // Changed to #FFFEFA
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
            ),
            child: Center(
              child: SvgPicture.asset(
                'Design materials/Icons/qr 1.svg',
                width: 140,
                height: 140,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 50),
          // Open camera button
          AnimatedButton(
            onTap: () => controller.startScanning(),
            child: Container(
              width: double.infinity,
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 20), // 10% margin from edges
              decoration: BoxDecoration(
                color: brandRed,
                borderRadius: BorderRadius.circular(8), // Much sharper corners
                boxShadow: [BoxShadow(color: brandRed.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: const Center(
                child: Text(
                  'افتح الكاميرا',
                  style: TextStyle(color: Colors.white, fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods for custom header
  Widget _buildNotificationBell(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: AnimatedButton(
        onTap: () => Navigator.pushNamed(context, '/notifications'),
        child: Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset('Design materials/Icons/Frame.svg', fit: BoxFit.contain),
        ),
      ),
    );
  }

  Widget _buildCenterLogo() {
    return SizedBox(
      height: 87,
      width: 104,
      child: Image.asset('assets/images/high ress logo.png', fit: BoxFit.contain),
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 52),
      child: AnimatedButton(
        onTap: () => Navigator.pushNamed(context, '/profile'),
        child: Container(
          width: 37,
          height: 37,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/close-headshot-portrait-happy-middle-600nw-2423464835.jpg.webp',
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
