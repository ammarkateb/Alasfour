import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/shared_nav.dart';
import '../controllers/profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileController(),
      child: Consumer<ProfileController>(
        builder: (context, controller, _) {
          final topPadding = MediaQuery.of(context).padding.top;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 220, bottom: 120),
                    child: _buildProfileContent(controller),
                  ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: buildSharedHeader(context, topPadding, 'الملف الشخصي', 'إدارة معلوماتك الشخصية'),
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

  Widget _buildProfileContent(ProfileController controller) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // Profile photo section
              GestureDetector(
                onTap: () => _pickImage(context, controller),
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: goldColor, width: 4),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20),
                        ],
                      ),
                      child: ClipOval(
                        child: controller.profile.profileImagePath != null
                            ? Image.asset(controller.profile.profileImagePath!, fit: BoxFit.cover)
                            : const Icon(Icons.person, size: 60, color: Colors.grey),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: brandRed,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'اضغط لتحميل صورة',
                style: TextStyle(fontFamily: 'Tajawal', fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              // Profile info cards
              _buildInfoCard('الاسم', controller.profile.name, Icons.person_outline),
              const SizedBox(height: 12),
              _buildInfoCard('رقم الهاتف', controller.profile.phone, Icons.phone_outlined),
              const SizedBox(height: 12),
              _buildInfoCard('البريد الإلكتروني', controller.profile.email, Icons.email_outlined),
              const SizedBox(height: 12),
              _buildInfoCard('المنطقة', controller.profile.region, Icons.location_on_outlined),
              const SizedBox(height: 32),
              // Edit profile button
              AnimatedButton(
                onTap: () => controller.saveProfile(),
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: brandRed,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: brandRed.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
                  ),
                  child: Center(
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'تعديل الملف الشخصي',
                            style: TextStyle(color: Colors.white, fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Logout button
              AnimatedButton(
                onTap: () async {
                  final success = await controller.logout();
                  if (success && context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/intro', (route) => false);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 55,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: brandRed, width: 2),
                  ),
                  child: Center(
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: brandRed)
                        : const Text(
                            'تسجيل الخروج',
                            style: TextStyle(color: brandRed, fontFamily: 'Tajawal', fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: creamColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: brandRed, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(label, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage(BuildContext context, ProfileController controller) {
    // Simulate image picker - in real app use image_picker package
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر صورة', style: TextStyle(fontFamily: 'Tajawal', fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPickerOption(Icons.camera_alt, 'الكاميرا', () {
                  Navigator.pop(context);
                  controller.updateProfileImage('Design materials/images/high ress logo.png');
                }),
                _buildPickerOption(Icons.photo_library, 'المعرض', () {
                  Navigator.pop(context);
                  controller.updateProfileImage('Design materials/images/high ress logo.png');
                }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPickerOption(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(color: creamColor, borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: brandRed, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontFamily: 'Tajawal', fontSize: 14)),
        ],
      ),
    );
  }

}
