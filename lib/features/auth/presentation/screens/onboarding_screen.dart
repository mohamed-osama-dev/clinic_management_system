import 'package:clinic_management_system/config/routes/app_routes.dart';
import 'package:clinic_management_system/core/constants/app_colors.dart';
import 'package:clinic_management_system/core/constants/app_images.dart';
import 'package:clinic_management_system/core/constants/app_text_styles.dart';
import 'package:clinic_management_system/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _skipOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (mounted) context.go(AppRoutes.roleSelection);
  }

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (mounted) context.go(AppRoutes.roleSelection);
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: (page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _buildSlide(
            AppImages.onboarding1,
            'احجز موعدك بكل سهولة',
            'اعثر على أفضل الأطباء واحجز موعدك في توان من خلال تطبيق واحد.',
          ),
          _buildSlide(
            AppImages.onboarding2,
            'استشارات عن بُعد',
            'تواصل مع طبيبك بمكالمة فيديو من منزلك دون الحاجة للذهاب للعيادة.',
          ),
          _buildSlide(
            AppImages.onboarding3,
            'ملفك الطبي بين يديك',
            'احفظ كل وصفاتك وتحاليلك وتقاريرك في مكان آمن واحد.',
          ),
        ],
      ),
      bottomSheet: _currentPage < 2
          ? _buildBottomButton('التالي ←', _nextPage)
          : _buildBottomButton('ابدأ الآن', _finishOnboarding),
    );
  }

  Widget _buildSlide(String imagePath, String title, String subtitle) {
    return Column(
      children: [
        // Skip button at top right
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 40, 16, 0),
          child: Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: _skipOnboarding,
              child: Text(
                'تخطى',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ),
        ),
        // Spacer to push content to center
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated onboarding image
              _animatedOnboardingImage(imagePath: imagePath),
              const SizedBox(height: 24),
              // Dots indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    width: _currentPage == index ? 12 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(4),
                      color:
                          _currentPage == index ? AppColors.primary : AppColors.border,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                title,
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: AppButton.fullWidth(
        onTap: onPressed,
        label: label,
      ),
    );
  }

  /// Animated onboarding image with premium UI effects
  Widget _animatedOnboardingImage({required String imagePath}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      builder: (context, value, child) => Transform.scale(
        scale: 0.8 + (value * 0.2), // Using raw value for scale to keep bounce effect
        child: Opacity(
          opacity: value.clamp(0.0, 1.0), // Clamped for opacity to avoid assertion error
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Image.asset(
                imagePath,
                width: 280,
                height: 200,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}