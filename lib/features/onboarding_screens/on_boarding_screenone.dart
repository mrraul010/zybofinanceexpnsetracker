import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyboexpensetracker/features/auth/presentation/screens/login_screen.dart';
import 'package:zyboexpensetracker/features/home/presentation/screens/home_screen.dart';
import 'package:zyboexpensetracker/features/onboarding_screens/widgets/bottompanel.dart';
import 'package:zyboexpensetracker/features/onboarding_screens/widgets/common_onboarding_button.dart';
import 'package:zyboexpensetracker/features/onboarding_screens/widgets/page_content.dart';

class WalkthroughPage {
  final String title;
  final String subtitle;
  final IconData icon;

  const WalkthroughPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class WalkthroughScreen extends StatefulWidget {
  const WalkthroughScreen({super.key});

  @override
  State<WalkthroughScreen> createState() => _WalkthroughScreenState();
}

class _WalkthroughScreenState extends State<WalkthroughScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<WalkthroughPage> _pages = const [
    WalkthroughPage(
      title: 'Privacy by Default, With Zero Ads or Hidden Tracking',
      subtitle: 'No ads. No trackers. No third-party analytics.',
      icon: Icons.lock_rounded,
    ),
    WalkthroughPage(
      title: 'Insights That Help You Spend Better Without Complexity',
      subtitle: 'See category-wise spending, recent activity.',
      icon: Icons.vpn_key_rounded,
    ),
    WalkthroughPage(
      title: 'Local-First Tracking That Stays Fully On Your Device',
      subtitle: 'Your finances stay on your phone.',
      icon: Icons.bolt_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() async {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('has_seen_walkthrough', true);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF050A1A),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/walkthroughbackgroundimage.png',
              fit: BoxFit.cover,
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, index) => PageContent(page: _pages[index]),
          ),

          skiptext(
            context,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomPanel(
              pages: _pages,
              currentPage: _currentPage,
              onNext: _nextPage,
              onBack: _previousPage,
            ),
          ),
        ],
      ),
    );
  }

  Widget skiptext(BuildContext context, {required VoidCallback onTap}) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      right: 24,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF00D4FF),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        child: const Text('SKIP', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
