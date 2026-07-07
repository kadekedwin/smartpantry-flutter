import 'package:flutter/material.dart';

class InventoryCategoryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final String categoryKey;
  final String activeCategory;
  final ValueChanged<String> onTap;

  const InventoryCategoryPill({
    super.key,
    required this.icon,
    required this.label,
    required this.categoryKey,
    required this.activeCategory,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = activeCategory == categoryKey;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(categoryKey),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF0F9F68) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? const Color(0xFF0F9F68)
                  : const Color(0xFFE5E7EB),
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: const Color(0xFF0F9F68).withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF6B7280),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
