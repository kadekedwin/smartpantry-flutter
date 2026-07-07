import 'package:flutter/material.dart';
import '../components/onboarding/onboarding_data.dart';
import '../components/onboarding/onboarding_dots_indicator.dart';
import '../components/onboarding/onboarding_page.dart';
import '../components/onboarding/onboarding_top_bar.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _primaryColor = Color(0xFF059669);

  static const List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/images/onboarding_1.png',
      title: 'Kelola Dapur Anda',
      description:
          'Pantau bahan makanan, resep, dan stok dapur dalam satu aplikasi yang mudah digunakan.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_2.png',
      title: 'Pantau Kadaluarsa',
      description:
          'Dapatkan notifikasi sebelum bahan makanan Anda kadaluarsa dan kurangi pemborosan makanan.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_3.png',
      title: 'Rencanakan Menu Mingguan',
      description:
          'Buat rencana masak untuk seminggu dan belanja lebih efisien bersama keluarga.',
    ),
  ];

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            OnboardingTopBar(
              currentPage: _currentPage,
              isLastPage: isLastPage,
              onBack: _goToPreviousPage,
              onSkip: _finishOnboarding,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) =>
                    OnboardingPage(data: _pages[index]),
              ),
            ),
            const SizedBox(height: 32),
            OnboardingDotsIndicator(
              count: _pages.length,
              currentIndex: _currentPage,
              activeColor: _primaryColor,
            ),
            const SizedBox(height: 36),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _goToNextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text(
                    isLastPage ? 'Mulai Sekarang' : 'Selanjutnya',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
