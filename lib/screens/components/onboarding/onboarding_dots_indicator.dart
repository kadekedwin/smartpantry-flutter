import 'package:flutter/material.dart';

class OnboardingDotsIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Color activeColor;

  const OnboardingDotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: isActive ? 69 : 16,
          decoration: BoxDecoration(
            color: isActive ? activeColor : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(50),
          ),
        );
      }),
    );
  }
}
