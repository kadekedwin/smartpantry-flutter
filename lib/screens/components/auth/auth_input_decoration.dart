import 'package:flutter/material.dart';

const _muted = Color(0xFF9CA3AF);

InputDecoration authInputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffix,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      color: _muted,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    prefixIcon: Icon(icon, color: _muted, size: 20),
    suffixIcon: suffix,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _muted, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _muted, width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: _muted, width: 2),
    ),
  );
}
