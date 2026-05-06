import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF8F9FB);
  static const surface = Colors.white;
  static const primary = Color(0xFF6C63FF);
  static const primaryLight = Color(0xFFEEEDFF);
  static const text = Color(0xFF1A1A2E);
  static const textLight = Color(0xFF9E9E9E);
  static const divider = Color(0xFFF0F0F0);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFF9800);
  static const danger = Color(0xFFE53935);
}

class AppCategories {
  static const List<Map<String, dynamic>> all = [
    {'name': 'Food',        'icon': Icons.restaurant,      'color': Color(0xFFFF6B6B)},
    {'name': 'Transport',   'icon': Icons.directions_car,  'color': Color(0xFF4ECDC4)},
    {'name': 'Shopping',    'icon': Icons.shopping_bag,    'color': Color(0xFFFFBE0B)},
    {'name': 'Health',      'icon': Icons.favorite,        'color': Color(0xFFFF006E)},
    {'name': 'Bills',       'icon': Icons.receipt_long,    'color': Color(0xFF8338EC)},
    {'name': 'Entertainment','icon': Icons.movie,          'color': Color(0xFF3A86FF)},
    {'name': 'Education',   'icon': Icons.school,          'color': Color(0xFF06D6A0)},
    {'name': 'Other',       'icon': Icons.more_horiz,      'color': Color(0xFF9E9E9E)},
  ];

  static Color colorFor(String name) {
    final match = all.firstWhere(
      (c) => c['name'] == name,
      orElse: () => all.last,
    );
    return match['color'] as Color;
  }

  static IconData iconFor(String name) {
    final match = all.firstWhere(
      (c) => c['name'] == name,
      orElse: () => all.last,
    );
    return match['icon'] as IconData;
  }
}