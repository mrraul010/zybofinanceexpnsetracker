import 'package:flutter/material.dart';
import 'package:zyboexpensetracker/features/onboarding_screens/on_boarding_screenone.dart';
import 'package:zyboexpensetracker/features/onboarding_screens/widgets/common_onboarding_button.dart';

class BottomPanel extends StatelessWidget {
  const BottomPanel({
    required this.pages,
    required this.currentPage,
    required this.onNext,
    required this.onBack,
  });

  final List<WalkthroughPage> pages;
  final int currentPage;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(28, 32, 28, bottomPad + 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF050A1A).withOpacity(0.85),
            const Color(0xFF050A1A),
          ],
          stops: const [0.0, 0.25, 0.5],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(pages.length, (i) {
              final isActive = i == currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(right: 6),
                width: isActive ? 28 : 8,
                height: 4,
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Text(
              pages[currentPage].title,
              key: ValueKey(currentPage),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w700,
                height: 1.25,
                letterSpacing: -0.3,
              ),
            ),
          ),

          const SizedBox(height: 10),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            child: Text(
              pages[currentPage].subtitle,
              key: ValueKey('sub_$currentPage'),
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 15,
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 28),

          CommonOnboardingButton(
            onNext: onNext,
            onBack: onBack,
            currentPage: currentPage,
            pages: pages,
          ),
        ],
      ),
    );
  }
}
