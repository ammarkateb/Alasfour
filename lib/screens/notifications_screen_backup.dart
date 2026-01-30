import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/shared_nav.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 158, bottom: 120),
            child: _buildNotificationsList(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildCustomHeightHeader(context, topPadding),
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

  Widget _buildNotificationsList() {
    return Column(
      children: [
        // Header text in scrollable area
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(right: 16, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'الإشعارات',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'ابقَ على اطلاع دائم بأهم المستجدات',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        // Notification cards
        _buildNotificationCards(),
      ],
    );
  }

  Widget _buildNotificationCards() {
    final notifications = [
      ('إعلان فائز جديد', 'تم الإعلان عن الفائز في السحب الشهري الأخير يمكنك الاطلاع على التفاصيل في صفحة الرابحين', 'منذ دقيقتين', 'Design materials/Icons/Frame-3.svg', const Color(0xFFFFF3E0)),
      ('حملة QR جديدة', 'حملة مسح جديدة انطلقت. امسح الرمز وادخل السحب القادم.', 'منذ 5 دقائق', 'Design materials/Icons/Frame-6.svg', const Color(0xFFE8F5E9)),
      ('نتائج هذا الشهر', 'قائمة الفائزين لهذا الشهر أصبحت متاحة بكل شفافية', 'منذ 30 دقيقة', 'Design materials/Icons/Frame-7.svg', const Color(0xFFE3F2FD)),
      ('منتج جديد', 'تمت إضافة منتج جديد من مواد العصفور. اكتشفه الآن.', 'أمس', 'Design materials/Icons/Frame-8.svg', const Color(0xFFF3E5F5)),
      ('تحديث مهم', 'تم تحديث محتوى بمواد وحملات جديدة. تجربة أفضل بانتظارك', 'أمس', 'Design materials/Icons/Frame-9.svg', const Color(0xFFFFEBEE)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: notifications.map((n) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildNotificationCard(n.$1, n.$2, n.$3, n.$4, n.$5),
        )).toList(),
      ),
    );
  }

  Widget _buildNotificationCard(String title, String subtitle, String time, String svgPath, Color iconBg) {
    return AnimatedButton(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFFDF8F8),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: Offset(0, 3))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(time, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 10, color: Colors.grey)),
                      Text(title, style: const TextStyle(fontFamily: 'Tajawal', fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontFamily: 'Tajawal', fontSize: 11, color: Colors.grey),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 50,
              height: 70,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconBg == const Color(0xFFFFF3E0) ? const Color(0xFFFAF0DC) :
                         iconBg == const Color(0xFFE8F5E9) ? const Color(0xFFF3E5F5) :
                         iconBg == const Color(0xFFE3F2FD) ? const Color(0xFFE3F2FD) :
                         iconBg == const Color(0xFFF3E5F5) ? const Color(0xFFE8F5E9) :
                         const Color(0xFFFFEBEE),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SvgPicture.asset(
                      svgPath,
                      width: 20,
                      height: 20,
                      colorFilter: svgPath == 'Design materials/Icons/Frame-3.svg' 
                        ? ColorFilter.mode(const Color(0xFFFFD700), BlendMode.srcIn)
                        : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomHeightHeader(BuildContext context, double topPadding) {
    return Builder(
      builder: (context) => SizedBox(
        height: 240, // Custom height - adjust this to make header taller/shorter
        child: buildSharedHeader(context, topPadding, '', ''),
      ),
    );
  }
}

class HeaderCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5, size.height - 20);
    path.quadraticBezierTo(size.width * 0.75, size.height - 40, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}
