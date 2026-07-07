import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AuthSocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final bool hasBorder;
  final bool isSvg;
  final VoidCallback onTap;

  const AuthSocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.hasBorder,
    required this.onTap,
    this.isSvg = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: hasBorder
              ? Border.all(color: const Color(0xFF9CA3AF), width: 1)
              : null,
          boxShadow: hasBorder
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSvg
                ? SvgPicture.asset(
                    icon,
                    width: 24,
                    height: 24,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  )
                : Image.asset(icon, width: 24, height: 24),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
