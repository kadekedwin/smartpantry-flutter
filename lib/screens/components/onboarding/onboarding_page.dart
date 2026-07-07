import 'package:flutter/material.dart';
import 'onboarding_data.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingData data;

  const OnboardingPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              data.image,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
              height: 1.65,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
