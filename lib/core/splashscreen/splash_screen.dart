import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zyboexpensetracker/features/auth/presentation/screens/login_screen.dart';
import 'package:zyboexpensetracker/features/home/presentation/screens/home_screen.dart';
import 'package:zyboexpensetracker/features/onboarding_screens/on_boarding_screenone.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeAnimation;

  late Animation<double> _scaleAnimation;

  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.6,
          end: 1.08,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.08,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
          ),
        );

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _controller.forward();
    });

    Future.delayed(const Duration(milliseconds: 2500), () {
      _handleAppRouting();
    });
   
  }

  Future<void> _handleAppRouting() async {
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('auth_token');
    final bool isLoggedIn = token != null && token.isNotEmpty;

    final bool hasSeenWalkthrough =
        prefs.getBool('has_seen_walkthrough') ?? false;

    Widget destinationScreen;

    if (isLoggedIn) {
      destinationScreen = const HomeScreen();
    } else if (hasSeenWalkthrough) {
      destinationScreen = const LoginScreen();
    } else {
      destinationScreen = const WalkthroughScreen();
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => destinationScreen,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset('assets/Zyboexpenselogo.png'),
            ),
          ),
        ),
      ),
    );
  }
}
