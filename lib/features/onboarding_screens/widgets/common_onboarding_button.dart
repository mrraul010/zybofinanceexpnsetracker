import 'package:flutter/material.dart';
import 'package:zyboexpensetracker/features/onboarding_screens/on_boarding_screenone.dart';

class CommonOnboardingButton extends StatelessWidget {
  const CommonOnboardingButton({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.currentPage,
    required this.pages,
  });

  final VoidCallback onNext;
  final VoidCallback onBack;
  final int currentPage;
  final List<WalkthroughPage> pages;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (currentPage > 0) ...[
          SizedBox(
            width: 56,
            height: 56,
            child: OutlinedButton(
              onPressed: onBack,
              style: OutlinedButton.styleFrom(
                shape: const CircleBorder(),
                side: const BorderSide(color: Colors.white, width: 1.5),
                padding: EdgeInsets.zero,
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF312ECB),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                shadowColor: const Color(0xFF4B3FE4).withOpacity(0.5),
              ),
              child: Text(
                currentPage < pages.length - 1 ? 'Next' : 'Get Started',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
