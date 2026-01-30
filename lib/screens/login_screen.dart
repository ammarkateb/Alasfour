import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/login_controller.dart';
import '../utils/circle_arc_painter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: Consumer<LoginController>(
        builder: (context, controller, _) {
          final size = MediaQuery.of(context).size;

          // 4-STOP VIBRANT RED (SAMPLED FROM PHOTO)
          const List<Color> finalRed = [
            Color(0xFFFF1F1F), // Bright center
            Color(0xFFE60000),
            Color(0xFFD30000),
            Color(0xFFB00000), // Deep edge
          ];

          // 4-STOP VIBRANT YELLOW (SAMPLED FROM PHOTO)
          const List<Color> finalYellow = [
            Color(0xFFFFD700),
            Color(0xFFFFC400),
            Color(0xFFFFB000),
            Color(0xFFFF9100),
          ];

          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                // 1. BASE YELLOW GRADIENT
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: finalYellow,
                    ),
                  ),
                ),

                // 2. TOP LEFT CIRCLE (Lifted 150px)
                Positioned(
                  top: -size.height * 0.30, 
                  left: -size.width * 0.35,
                  child: Container(
                    width: size.width * 1.15,
                    height: size.width * 1.15,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: finalRed),
                    ),
                  ),
                ),

                // 3. TOP RIGHT CIRCLE (Lifted 100px)
                Positioned(
                  top: -size.height * 0.20, 
                  right: -size.width * 0.14,
                  child: Container(
                    width: size.width * 0.8,
                    height: size.width * 0.8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          finalRed[0].withOpacity(0.3),
                          finalRed[1].withOpacity(0.2),
                          finalRed[2].withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),

                // 4. BOTTOM RIGHT CIRCLE (Lowered 50px)
                Positioned(
                  bottom: -size.height * 0.15, 
                  left: -size.width * 0.21,
                  right: -size.width * 0.14,
                  child: Container(
                    width: size.width * 1.50,
                    height: size.width * 1.50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: bottomRed,
                      ),
                    ),
                  ),
                ),

                // 5. WHITE CIRCULAR LINES (TOP & BOTTOM)
                Positioned.fill(
                  child: CustomPaint(
                    painter: CircleArcPainter(),
                  ),
                ),

                // 7. LOGIN FORM (Instead of product tabs)
                _buildLoginForm(size),

                // 8. TEXT & ACTION OVERLAY (Without login button)
                _buildLoginOverlay(size, context),

                // 9. FLOATING LOGIN BUTTON
                _buildLoginButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginForm(Size size) {
    return Positioned(
      top: size.height * 0.35,
      left: size.width * 0.1,
      right: size.width * 0.1,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/high ress logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            const Text(
              'تسجيل الدخول',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD30000),
              ),
            ),
            const SizedBox(height: 30),
            
            // Username field
            TextField(
              controller: _usernameController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'اسم المستخدم',
                hintStyle: const TextStyle(fontFamily: 'Tajawal'),
                prefixIcon: const Icon(Icons.person, color: Color(0xFFD30000)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD30000)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD30000), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Password field
            TextField(
              controller: _passwordController,
              textAlign: TextAlign.right,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                hintText: 'كلمة المرور',
                hintStyle: const TextStyle(fontFamily: 'Tajawal'),
                prefixIcon: const Icon(Icons.lock, color: Color(0xFFD30000)),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0xFFD30000),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD30000)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFD30000), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Remember me checkbox
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  activeColor: const Color(0xFFD30000),
                ),
                const Text(
                  'تذكرني',
                  style: TextStyle(fontFamily: 'Tajawal'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Login button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Handle login logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD30000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'دخول',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            
            // Forgot password
            TextButton(
              onPressed: () {
                // Handle forgot password
              },
              child: const Text(
                'نسيت كلمة المرور؟',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: Color(0xFFD30000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginOverlay(Size size, BuildContext context) {
    return Positioned(
      top: size.height * 0.15,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'مرحبا بك في العصفور',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'استمتع بتجربة العصفور للحصول على جوائز رائعة',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.9),
                fontFamily: 'Tajawal',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/products'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Container(
                width: 200,
                height: 55,
                decoration: BoxDecoration(
                  color: const Color(0xFFD30000),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD30000).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Text(
                  'تسجل الدخول',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Positioned(
      bottom: size.height * 0.08,
      left: (size.width - 200) / 2,
      child: AnimatedButton(
        onTap: () => Navigator.pushNamed(context, '/products'),
        child: Container(
          width: 200,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFD30000),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD30000).withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: const Text(
            'تسجل الدخول',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// Missing constants that were in the original
const List<Color> bottomRed = [
  Color(0xFFD30000),
  Color(0xFFB00000),
  Color(0xFF800000),
  Color(0xFF600000),
];

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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: widget.child,
        ),
      ),
    );
  }
}
