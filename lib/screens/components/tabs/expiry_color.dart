import 'package:flutter/material.dart';

Color getExpiryColor(DateTime expiredAt) {
  final today = DateTime.now();
  final t = DateTime(today.year, today.month, today.day);
  final e = DateTime(expiredAt.year, expiredAt.month, expiredAt.day);
  final days = e.difference(t).inDays;
  if (days <= 2) return const Color(0xFFEF4444);
  if (days <= 5) return const Color(0xFFF59E0B);
  return const Color(0xFF0F9F68);
}
