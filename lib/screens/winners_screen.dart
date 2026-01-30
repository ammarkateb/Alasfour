import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../widgets/shared_nav.dart';

class WinnersScreen extends StatelessWidget {
  const WinnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 160, bottom: 200),
            child: _buildScrollableContent(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(context, topPadding),
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
  }

  Widget _buildTopBar(BuildContext context, double topPadding) {
    return Builder(
      builder: (context) => SizedBox(
        height: 250,
        child: Stack(
          children: [
            // Red background with curve
            ClipPath(
              clipper: HeaderCurveClipper(),
              child: Container(
                height: 475,
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
            // Header content (fixed)
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableContent() {
    return Column(
      children: [
        // Header text that scrolls with content
        Container(
          padding: const EdgeInsets.only(left: 120, right: 0,bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'الفائزون',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8E0000),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'أشخاص حقيقيون يفوزون بجوائز حقيقية',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Color(0xFF933023),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Tajawal',
                ),
              ),
            ],
          ),
        ),
        // Winner cards
        _buildWinnersList(),
      ],
    );
  }

  Widget _buildWinnersHeader(BuildContext context, double topPadding) {
    return Builder(
      builder: (context) => SizedBox(
        height: 250,
        child: Stack(
          children: [
            // Red background with curve
            ClipPath(
              clipper: HeaderCurveClipper(),
              child: Container(
                height: 475,
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
                ],
              ),
            ),
            // Header text - positioned on the right side, much lower
            Positioned(
              top: 160,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'الفائزون',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'أشخاص حقيقيون يفوزون بجوائز حقيقية',
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

  Widget _buildWinnersList() {
    final winners = [
      ('معتصم الخولي', 'فاز بجهاز أيفون 15', 'فاز في 15 مارس'),
      ('علاء ياسر', 'فاز بجهاز أيفون 15', 'فاز في 15 مارس'),
      ('صفا طعان', 'فاز بجهاز أيفون 15', 'فاز في 15 مارس'),
      ('محمد اليوسف', 'فاز بجهاز أيفون 15', 'فاز في 15 مارس'),
      ('أحمد علي', 'فاز بجهاز أيفون 15', 'فاز في 15 مارس'),
      ('خالد السعيد', 'فاز بجهاز أيفون 15', 'فاز في 15 مارس'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            // Row 1
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWinnerWithPhoto(winners[0].$1, winners[0].$2, winners[0].$3, imagePath: 'assets/images/4.png'),
                const SizedBox(width: 16),
                _buildWinnerWithPhoto(winners[1].$1, winners[1].$2, winners[1].$3, imagePath: 'assets/images/6.png'),
              ],
            ),
            const SizedBox(height: 143),
            // Row 2
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWinnerWithPhoto(winners[2].$1, winners[2].$2, winners[2].$3, imagePath: 'assets/images/1.png'),
                const SizedBox(width: 16),
                _buildWinnerWithPhoto(winners[3].$1, winners[3].$2, winners[3].$3, imagePath: 'assets/images/2.png'),
              ],
            ),
            const SizedBox(height: 143),
            // Row 3
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWinnerWithPhoto(winners[4].$1, winners[4].$2, winners[4].$3, imagePath: 'assets/images/5.png'),
                const SizedBox(width: 16),
                _buildWinnerWithPhoto(winners[5].$1, winners[5].$2, winners[5].$3, imagePath: 'assets/images/3.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerWithPhoto(String name, String prize, String date, {String? imagePath}) {
    return AnimatedButton(
      child: SizedBox(
        width: 160,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Card below, with space reserved for the avatar overlap
            Positioned(
              top: 40, // card a bit lower so avatar floats more clearly above
              child: Container(
                width: 160,
                padding: const EdgeInsets.fromLTRB(12, 55, 12, 40),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      prize,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 12,
                        color: Color(0xFF8E0000),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      date,
                      style: const TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Avatar + trophy, hovering and overlapping the card
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF8E0000), width: 3),
                  ),
                  child: ClipOval(
                    child: imagePath != null
                        ? Image.asset(
                            imagePath!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.person, size: 50, color: Colors.grey),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: goldColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'Design materials/Icons/Frame-3.svg',
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinnerCard(String name, String prize, String date) {
    return AnimatedButton(
      child: Container(
        width: 160,
        height: 140, // Fixed shorter height
        decoration: BoxDecoration(
          color: const Color(0xFFFFF0F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Space for hovering photo
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12), // Increased spacing
            Text(
              prize,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                color: brandRed,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8), // Increased spacing
            Text(
              date,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 10,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}
