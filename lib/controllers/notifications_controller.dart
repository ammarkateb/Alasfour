import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Notification {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final String svgPath;
  final Color iconBg;

  Notification({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.svgPath,
    required this.iconBg,
  });
}

class NotificationsController extends ChangeNotifier {
  List<Notification> _notifications = [];
  bool _isLoading = false;
  String? _error;

  // Public getters - UI reads from these
  List<Notification> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  NotificationsController() {
    loadNotifications();
  }

  // Business logic methods - UI calls these
  Future<void> loadNotifications() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      _notifications = [
        Notification(
          id: '1',
          title: 'إعلان فائز جديد',
          subtitle: 'تم الإعلان عن الفائز في السحب الشهري الأخير يمكنك الاطلاع على التفاصيل في صفحة الرابحين',
          time: 'منذ دقيقتين',
          svgPath: 'Design materials/Icons/Frame-3.svg',
          iconBg: const Color(0xFFFFF3E0),
        ),
        Notification(
          id: '2',
          title: 'حملة QR جديدة',
          subtitle: 'حملة مسح جديدة انطلقت. امسح الرمز وادخل السحب القادم.',
          time: 'منذ 5 دقائق',
          svgPath: 'Design materials/Icons/Frame-6.svg',
          iconBg: const Color(0xFFE8F5E9),
        ),
        Notification(
          id: '3',
          title: 'نتائج هذا الشهر',
          subtitle: 'قائمة الفائزين لهذا الشهر أصبحت متاحة بكل شفافية',
          time: 'منذ 30 دقيقة',
          svgPath: 'Design materials/Icons/Frame-7.svg',
          iconBg: const Color(0xFFE3F2FD),
        ),
        Notification(
          id: '4',
          title: 'منتج جديد',
          subtitle: 'تمت إضافة منتج جديد من مواد العصفور. اكتشفه الآن.',
          time: 'أمس',
          svgPath: 'Design materials/Icons/Frame-8.svg',
          iconBg: const Color(0xFFF3E5F5),
        ),
        Notification(
          id: '5',
          title: 'تحديث مهم',
          subtitle: 'تم تحديث محتوى بمواد وحملات جديدة. تجربة أفضل بانتظارك',
          time: 'أمس',
          svgPath: 'Design materials/Icons/Frame-9.svg',
          iconBg: const Color(0xFFFFEBEE),
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshNotifications() async {
    await loadNotifications();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  Notification? getNotificationById(String id) {
    try {
      return _notifications.firstWhere((n) => n.id == id);
    } catch (e) {
      return null;
    }
  }
}
