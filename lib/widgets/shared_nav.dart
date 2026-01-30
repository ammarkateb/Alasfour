import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Shared constants
const brandRed = Color(0xFFD30000);
const creamColor = Color(0xFFEBE3CD);
const goldColor = Color(0xFFD3AF37);

// Red gradient for header and bottom nav
const redGradient = LinearGradient(
  colors: [
    Color(0xFFC81419),
    Color(0xFFD41419),
    Color(0xFFDF1619),
    Color(0xFFE31719),
    Color(0xFFE91A19),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// Gold gradient for home button
const goldGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFF5D76E),  // Top (very bright)
    Color(0xFFDDB032),  // Upper-middle
    Color(0xFFC89A1F),  // Middle (darker)
    Color(0xFFDDB032),  // Lower-middle
    Color(0xFFF5D76E),  // Bottom (very bright)
  ],
  stops: [0.0, 0.3, 0.5, 0.7, 1.0],  // Natural smooth gradient
);

// Shared bottom navigation bar
Widget buildSharedBottomNav(BuildContext context) {
  final String currentRoute = ModalRoute.of(context)?.settings.name ?? '/home';
  
  return SizedBox(
    height: 80,
    child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Red curved background with gradient (curved using BottomNavClipper)
        ClipPath(
          clipper: BottomNavClipper(),
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(gradient: redGradient),
          ),
        ),
        // Nav icons - kept outside the ClipPath so they remain fully tappable
        Positioned(
          bottom: 15,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // PROFILE ICON (left) - ADJUSTABLE
                Transform.translate(
                  offset: const Offset(14.7, -1), // ⬆️⬇️⬅️➡️ ADJUST HERE (x, y) - positive y = UP, negative y = DOWN
                  child: AnimatedButton(
                    onTap: () {
                      print('Profile button tapped');
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'Design materials/Icons/Frame-2.svg', 
                        width: 20, 
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          currentRoute == '/profile' ? Color(0xFFFFE066) : Colors.white, 
                          BlendMode.srcIn
                        ),
                      ),
                    ),
                  ),
                ),
                // WINNERS ICON (left-center) - ADJUSTABLE
                Transform.translate(
                  offset: const Offset(14.3, -12), // ⬆️⬇️⬅️➡️ ADJUST HERE (x, y) - positive y = UP, negative y = DOWN
                  child: AnimatedButton(
                    onTap: () {
                      print('Winners button tapped');
                      Navigator.pushNamed(context, '/winners');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'Design materials/Icons/Frame-3.svg', 
                        width: 20, 
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          currentRoute == '/winners' ? Color(0xFFFFE066) : Colors.white, 
                          BlendMode.srcIn
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 67), // Space for gold button
                // PRODUCTS ICON (right-center) - ADJUSTABLE
                Transform.translate(
                  offset: const Offset(-10, -12), // ⬆️⬇️⬅️➡️ ADJUST HERE (x, y) - positive y = UP, negative y = DOWN
                  child: AnimatedButton(
                    onTap: () {
                      print('Products button tapped');
                      Navigator.pushNamed(context, '/products');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'Design materials/Icons/Frame-5.svg', 
                        width: 20, 
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          currentRoute == '/products' ? Color(0xFFFFE066) : Colors.white, 
                          BlendMode.srcIn
                        ),
                      ),
                    ),
                  ),
                ),
                // QR SCANNER ICON (right) - ADJUSTABLE
                Transform.translate(
                  offset: const Offset(-12.2, 0), // ⬆️⬇️⬅️➡️ ADJUST HERE (x, y) - positive y = UP, negative y = DOWN
                  child: AnimatedButton(
                    onTap: () {
                      print('QR Scanner button tapped');
                      Navigator.pushNamed(context, '/qr-scanner');
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        'Design materials/Icons/Frame-4.svg', 
                        width: 20, 
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          currentRoute == '/qr-scanner' ? Color(0xFFFFE066) : Colors.white, 
                          BlendMode.srcIn
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }

// Shared simple header (for pages that don't need the full home header)
Widget buildSharedHeader(BuildContext context, double topPadding, String title, String subtitle) {
  return Builder(
    builder: (context) => SizedBox(
      height: 400,
      child: Stack(
        children: [
          // Red background with curve
          ClipPath(
            clipper: HeaderCurveClipper(),
            child: Container(
              height: 335,
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
          // Header content
          Padding(
            padding: EdgeInsets.only(top: kIsWeb ? topPadding + 8 : 8),
            child: Column(
              children: [
                // Top row: notification, logo, avatar
                Padding(
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
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
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

// Notification bell widget
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

// Center logo widget
Widget _buildCenterLogo() {
  return SizedBox(
    height: 87,
    width: 104,
    child: Image.asset('assets/images/high ress logo.png', fit: BoxFit.contain),
  );
}

// Profile avatar widget
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

// Animated button widget
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  const AnimatedButton({super.key, required this.child, this.onTap});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: widget.child),
      ),
    );
  }
}

// Floating gold home button (to be added separately in screens)
Widget buildFloatingHomeButton(BuildContext context) {
  return Positioned(
    bottom: 22,  // Hover above the nav bar
    left: 0,
    right: 0,
    child: Center(
      child: AnimatedButton(
        onTap: () => Navigator.pushNamed(context, '/home'),
        child: Container(
          width: 73,
          height: 73,
          decoration: const BoxDecoration(
            gradient: goldGradient,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
          ),
          child: Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: SvgPicture.asset('Design materials/Icons/home.5 1.svg', fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    ),
  );
}

// Header curve clipper
class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height + 0);
    path.quadraticBezierTo(
      size.width * 0.23, size.height - 108,   // Control point 1
      size.width * 0.6, size.height - 108,    // Middle point
    );
    path.quadraticBezierTo(
      size.width * 0.89, size.height - 107,   // Control point 2
      size.width, size.height - 145,        // End point
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}

// Bottom nav clipper
class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 40);
    path.quadraticBezierTo(size.width / 2, -38, size.width, 40);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}
