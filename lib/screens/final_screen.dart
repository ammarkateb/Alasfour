import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../widgets/shared_nav.dart';
import '../controllers/final_screen_controller.dart';
import '../widgets/favorite_heart_button.dart';
import '../models/product.dart';
import '../utils/circle_arc_painter.dart';

class AlasfourFinalScreen extends StatelessWidget {
  const AlasfourFinalScreen({super.key});

  static const brandRed = Color(0xFFD30000);
  static const creamColor = Color(0xFFEBE3CD);
  static const goldColor = Color(0xFFD3AF37);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FinalScreenController(),
      child: Consumer<FinalScreenController>(
        builder: (context, controller, _) {
          final size = MediaQuery.of(context).size;
          final topPadding = MediaQuery.of(context).padding.top;

          return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // SCROLLABLE CONTENT (scrolls under fixed header)
          Positioned.fill(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: 390,
              ), // Space for fixed header (adjusted on mobile for notch)
              child: Container(
                child: Column(
                  children: [
                    // SEARCH BAR
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: _buildSearchBar(),
                    ),
                    // PRODUCT CARDS (Vertical stack)
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(22.5, 11, 22.5, 16),
                      child: _buildProductCards(size),
                    ),
                    const SizedBox(height: 8),
                    // CREAM SECTION - أحدث المنتجات (fills down behind bottom nav)
                    _buildLatestProductsSection(size, context, controller),
                  ],
                ),
              ),
            ),
          ),
          // FIXED HEADER with flowy curve
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildFixedHeader(size, topPadding),
          ),
          // BOTTOM NAV (Fixed)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buildSharedBottomNav(context),
          ),
          // Floating gold home button (drawn last so it overlaps the nav)
          buildFloatingHomeButton(context),
        ],
      ),
          );
        },
      ),
    );
  }

  // Fixed header with flowy curved design
  Widget _buildFixedHeader(Size size, double topPadding) {
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
                        _buildProfileAvatar(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 4 Story circles
                  _buildStoryCircles(),
                  const SizedBox(height: 13),
                  // Gold promo card
                  _buildPromoCard(),
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
  Widget _buildProfileAvatar() {
    return Padding(
      padding: const EdgeInsets.only(top: 52),
      child: AnimatedButton(
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

  // Bottom navigation bar
  Widget _buildBottomNav(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Red curved background
          ClipPath(
            clipper: BottomNavClipper(),
            child: Container(
              height: 100,
              width: double.infinity,
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
          // Gold home button in center
          Positioned(
            top: 0,
            child: Container(
              width: 65,
              height: 65,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFD3AF37),
                    Color(0xFFF0E3A2),
                    Color(0xFFD3AF37),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
              ),
              child: SvgPicture.asset('Design materials/Icons/home.5 1.svg', width: 6, height: 6),
            ),
          ),
          // Nav icons
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedButton(
                    onTap: () => Navigator.pushNamed(context, '/profile'),
                    child: SvgPicture.asset('Design materials/Icons/Frame-2.svg', width: 20, height: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: AnimatedButton(
                      onTap: () => Navigator.pushNamed(context, '/winners'),
                      child: SvgPicture.asset('Design materials/Icons/Frame-3.svg', width: 20, height: 20),
                    ),
                  ),
                  const SizedBox(width: 65),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: AnimatedButton(
                      onTap: () => Navigator.pushNamed(context, '/products'),
                      child: SvgPicture.asset('Design materials/Icons/Frame-5.svg', width: 20, height: 20),
                    ),
                  ),
                  AnimatedButton(
                    onTap: () => Navigator.pushNamed(context, '/qr-scanner'),
                    child: SvgPicture.asset('Design materials/Icons/Frame-4.svg', width: 20, height: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4 Story circles with actual images
  Widget _buildStoryCircles() {
    final items = [
      ('طعم غني', 'assets/images/487958174_1121384120001469_697759111300351151_n.jpg'), // Far left (hidden initially)
      ('الرابحين معنا', 'assets/images/571255383_1295563619250184_8170010829550986480_n.jpg'),
      ('جمعة مباركة', 'assets/images/613650639_1353947356745143_298329249331386211_n.jpg'),
      ('منتج جديد', 'assets/images/598860259_1334461122027100_5329054173698521768_n.jpg'),
      ('دعوة عامة', 'assets/images/547432464_1255000023306544_5398140175460720862_n.jpg'), // Far right
    ];
    return Transform.translate(
      offset: const Offset(-10, 0), // Move 10 pixels left
      child: Padding(
        padding: const EdgeInsets.only(top: 3, left: 0, right: 8.5),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: ScrollController(initialScrollOffset: 200), // Start scrolled right
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Column(
              children: [
                Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFFFDD85D), width: 1.8),
                ),
                child: Container(
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFFFF0000), width: 0.2),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      item.$2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.$1,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            ),
          );
        }).toList(),
        ),
      ),
      ),
    );
  }

  // Gold promo card
  Widget _buildPromoCard() {
    return Container(
      height: 150,
      width: 321,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEBC43A),  // Left (bright)
            Color(0xFFE3B92E),  // Left-center-left-1 (slightly darker)
            Color(0xFFEBC43A),  // Left-center-left-2 (bright again)
            Color(0xFFB8860B),  // Left-center (only dark spot)
            Color(0xFFF6D34A),  // Left-center-right-1 (brighter)
            Color(0xFFF6D34A),  // Left-center-right-2 (brighter)
            Color(0xFFF6D34A),  // Right-center (brightest)
            Color(0xFFF6D34A),  // Right (brightest)
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          // Left third as image holder
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: 150 / 1.195, // One third of the bar width
            child: ClipPath(
                clipper: RightCurvedClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: ClipPath(
                      clipper: RightCurvedClipper(),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..scale(-0.9, 0.9, 1.0),
                        child: Image.asset(
                          'assets/images/Subject 2.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ),
          // Text and icon on the right
          Positioned(
            right: 24,
            top: -16,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(top: 0), // ← Adjust this to raise/lower text (increase = lower, decrease = higher)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                Text(
                  'اختاروا الجودة... واختاروا\n!حبّة بتحكو عنها',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.5,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Tajawal',
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 13),  // ← Control vertical spacing between texts
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'عرض تفاصيل المنتج',
                      style: TextStyle(
                        color: Color(0xFFD62828),
                        fontSize: 13.5,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/images/shopping-cart-plus.svg',
                      width: 22,
                      height: 22,
                    ),
                  ],
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }

  // Search bar with filter
  Widget _buildSearchBar() {
    return Row(
      children: [
        // Filter button with Group 5 icon (gold gradient like search bar)
        Container(
          width: 49,
          height: 49,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(17)),
            gradient: const LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [
                Color(0xFFEFCB45), // brighter gold at sides
                Color(0xFFC9941A), // darkest gold band
                Color(0xFFEFCB45), // brighter gold at sides
              ],
              stops: [0.0, 0.3, 1.0], // dark band shifted a bit toward the right
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33000000), // soft shadow under button
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              'Design materials/Icons/Group 5.svg',
              width: 17,
              height: 17,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Search field with gold gradient border (darker center, lighter sides)
        Expanded(
          child: Container(
            height: 45,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFFE5B52F), // darker gold at sides
                  Color(0xFFC9941A), // darkest gold in center
                  Color(0xFFE5B52F), // darker gold at sides
                ],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000), // soft shadow under bar
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(1), // thickness of the gold border
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.right,
                      decoration: InputDecoration(
                        hintText: 'ابحث عن منتج',
                        hintStyle: TextStyle(fontFamily: 'Tajawal', color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w300),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                        suffixIcon: Transform.scale(
                          scale: 0.47,
                          child: SvgPicture.asset(
                            'Design materials/Icons/Search_Magnifying_Glass.svg',
                            width: 12,
                            height: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 2 Product cards stacked vertically matching design
  Widget _buildProductCards(Size size) {
    return Column(
      children: [
        // Card 1 - جمعة مباركة
        _buildProductCard(
          imagePath: 'assets/images/613650639_1353947356745143_298329249331386211_n.jpg',
          title: 'جمعة مباركة',
          subtitle: '(إن أفضل أيامكم يوم الجمعة، فأكثروا عليّ من الصلاة فيه، فإن صلاتكم معروضة عليّ)',
          rating: '4.5',
          cardHeight: size.width * 0.725,
        ),
        const SizedBox(height: 23),
        // Card 2 - مع بداية عام 2026
        _buildProductCard(
          imagePath: 'assets/images/608704034_1347267394079806_2776020819630047541_n.jpg',
          title: 'مع بداية عام 2026',
          subtitle: 'نتقدم أسرة العصفور بأصدق التهاني والتمنيات لكم سائلين الله أن يكون عاماً مليئاً بالخير والتعاون.',
          rating: '4.5',
          cardHeight: size.width * 0.725,
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required String imagePath,
    required String title,
    required String subtitle,
    required String rating,
    required double cardHeight,
  }) {
    return Container(
      height: cardHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Image section (75%)
            Expanded(
              flex: 67,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ],
              ),
            ),
            // Red bottom section (25%)
            Expanded(
              flex: 33,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFFE10600), // Left (brightest red)
                      Color(0xFFE30600), // Middle (almost same, slightly smoother)
                      Color(0xFFC80000), // Right (slightly darker but still bright)
                    ],
                  ),
                ),
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // TOP ROW: star + rating + title
                    Row(
                      children: [
                        // Star rating on left
                        Transform.translate(
                          offset: const Offset(0, 4), // Lower a bit
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15), // Move star+rating right
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Transform.translate(
                                  offset: const Offset(0, -3), // Raise star to match rating height
                                  child: SvgPicture.asset(
                                    'Design materials/Icons/Star.svg',
                                    width: 18,
                                    height: 18,
                                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  rating,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Tajawal',
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Title on the right
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // BOTTOM ROW: subtitle with constrained width
                    Container(
                      constraints: const BoxConstraints(maxWidth: 280), // Change this to control wrap point
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Cream section with latest products
  Widget _buildLatestProductsSection(Size size, BuildContext context, FinalScreenController controller) {
    final dynamicProducts = controller.products.take(4).toList();
    final items = dynamicProducts.isNotEmpty
        ? dynamicProducts
            .map((product) => _LatestProductCardData(
                  title: product.title.isNotEmpty ? product.title : product.name,
                  imagePath: product.imagePath,
                  product: product,
                ))
            .toList()
        : _fallbackLatestProducts;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFF6E7C3), // flat cream color, slightly less red than before
      ),
      padding: const EdgeInsets.fromLTRB(0, 8, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/products'),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset('Design materials/Icons/Frame-1.svg', width: 12, height: 12),
                      const SizedBox(width: 4),
                      const Text(
                        'عرض الكل',
                        style: TextStyle(
                          color: brandRed,
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'أحدث المنتجات',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Tajawal',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 67),
          // Horizontal product list
          SizedBox(
            height: 215, // more room for photo + caption
            child: Transform.translate(
              offset: const Offset(0, -60), // raise, but keep caption visible
              child: ListView.separated(
              scrollDirection: Axis.horizontal,
              reverse: true,
              padding: const EdgeInsets.only(left: 16, right: 5),
              clipBehavior: Clip.none,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final cardData = items[index];

                return Stack(
                  clipBehavior: Clip.none, // Allow children to extend outside Stack bounds
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 142,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.asset(
                              cardData.imagePath,
                              height: 175,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          cardData.title,
                          style: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                    // Favorite button floating above everything, centered on top-left card corner
                    Positioned(
                      top: -7, // Only 1/4 of circle (7px) shows above top edge
                      left: 0, // Left edge of circle aligned with left edge of card
                      child: FavoriteHeartButton(
                        isFavorite: cardData.product?.isFavorite ?? false,
                        onPressed: cardData.product == null
                            ? null
                            : () async => controller.toggleFavorite(cardData.product!.id),
                      ),
                    ),
                  ],
                );
              },
            ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestProductCardData {
  final String title;
  final String imagePath;
  final Product? product;

  const _LatestProductCardData({
    required this.title,
    required this.imagePath,
    this.product,
  });
}

const List<_LatestProductCardData> _fallbackLatestProducts = [
  _LatestProductCardData(
    title: 'رز إسباني',
    imagePath: 'assets/images/514348169_1192444092895471_42307.png',
  ),
  _LatestProductCardData(
    title: 'بقلاوة بالفستق',
    imagePath: 'assets/images/605327917_1339959141477298_3665058675691574909_n.jpg',
  ),
  _LatestProductCardData(
    title: 'بقوليات',
    imagePath: 'assets/images/598860259_1334461122027100_5329054173698521768_n.jpg',
  ),
  _LatestProductCardData(
    title: 'عروض',
    imagePath: 'assets/images/547432464_1255000023306544_5398140175460720862_n.jpg',
  ),
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
      onTapUp: (_) async {
        await Future.delayed(const Duration(milliseconds: 80));
        _controller.reverse();
        await Future.delayed(const Duration(milliseconds: 50));
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

class RightCurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.68, 0);  // Start curve
    path.quadraticBezierTo(
      size.width * 1.23, size.height * 0.5,  // Control point higher up (deeper curve)
      size.width * 0.54, size.height,  // End curve
    );
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> old) => false;
}
