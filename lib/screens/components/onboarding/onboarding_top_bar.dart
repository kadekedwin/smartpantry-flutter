import 'package:flutter/material.dart';

class OnboardingTopBar extends StatelessWidget {
  final int currentPage;
  final bool isLastPage;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const OnboardingTopBar({
    super.key,
    required this.currentPage,
    required this.isLastPage,
    required this.onBack,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          currentPage > 0
              ? IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.chevron_left, size: 28),
                  color: const Color(0xFF059669),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                )
              : const SizedBox(width: 48, height: 48),
          if (!isLastPage)
            GestureDetector(
              onTap: onSkip,
              child: const Text(
                'Lewati',
                style: TextStyle(
                  color: Color(0xFF059669),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
