import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Winner {
  final String id;
  final String name;
  final String prize;
  final String date;
  final String imagePath;
  final String location;

  Winner({
    required this.id,
    required this.name,
    required this.prize,
    required this.date,
    required this.imagePath,
    required this.location,
  });
}

class WinnersController extends ChangeNotifier {
  List<Winner> _winners = [];
  bool _isLoading = false;
  String? _error;
  String _selectedPeriod = 'all';

  // Public getters
  List<Winner> get winners => _filteredWinners;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedPeriod => _selectedPeriod;

  // Get filtered winners based on selected period
  List<Winner> get _filteredWinners {
    if (_selectedPeriod == 'all') return _winners;
    
    final now = DateTime.now();
    return _winners.where((winner) {
      final winnerDate = DateTime.parse(winner.date);
      switch (_selectedPeriod) {
        case 'month':
          return winnerDate.month == now.month && winnerDate.year == now.year;
        case 'week':
          final weekAgo = now.subtract(const Duration(days: 7));
          return winnerDate.isAfter(weekAgo);
        default:
          return true;
      }
    }).toList();
  }

  WinnersController() {
    _loadWinners();
  }

  // Load winners data
  Future<void> _loadWinners() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      _winners = [
        Winner(
          id: '1',
          name: 'محمد أحمد',
          prize: 'سلة غذائية كاملة',
          date: '2024-01-15',
          imagePath: 'assets/images/close-headshot-portrait-happy-middle-600nw-2423464835.jpg.webp',
          location: 'الكويت',
        ),
        Winner(
          id: '2',
          name: 'فاطمة علي',
          prize: 'جهاز تلفزيون',
          date: '2024-01-10',
          imagePath: 'assets/images/close-headshot-portrait-happy-middle-600nw-2423464835.jpg.webp',
          location: 'الجهراء',
        ),
        Winner(
          id: '3',
          name: 'عبدالله سالم',
          prize: 'قسيمة شرائية',
          date: '2024-01-05',
          imagePath: 'assets/images/close-headshot-portrait-happy-middle-600nw-2423464835.jpg.webp',
          location: 'الأحمدي',
        ),
        Winner(
          id: '4',
          name: 'نورة خالد',
          prize: 'هاتف ذكي',
          date: '2023-12-28',
          imagePath: 'assets/images/close-headshot-portrait-happy-middle-600nw-2423464835.jpg.webp',
          location: 'الفروانية',
        ),
        Winner(
          id: '5',
          name: 'خالد محمد',
          prize: 'ساعة ذكية',
          date: '2023-12-20',
          imagePath: 'assets/images/close-headshot-portrait-happy-middle-600nw-2423464835.jpg.webp',
          location: 'حولي',
        ),
      ];
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter winners by period
  void filterByPeriod(String period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  // Get winner by ID
  Winner? getWinnerById(String id) {
    try {
      return _winners.firstWhere((winner) => winner.id == id);
    } catch (e) {
      return null;
    }
  }

  // Refresh winners
  Future<void> refreshWinners() async {
    await _loadWinners();
  }

  // Get winners count
  int get winnersCount => _winners.length;

  // Get winners by location
  List<Winner> getWinnersByLocation(String location) {
    return _winners.where((winner) => winner.location == location).toList();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Get recent winners (last 30 days)
  List<Winner> get recentWinners {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return _winners.where((winner) {
      final winnerDate = DateTime.parse(winner.date);
      return winnerDate.isAfter(thirtyDaysAgo);
    }).toList();
  }
}
