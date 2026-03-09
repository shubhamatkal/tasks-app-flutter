import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../app/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Logo
              _DayTaskLogo(),
              const SizedBox(height: 24),
              // Illustration card
              FadeTransition(
                opacity: _fadeIn,
                child: SizedBox(
                  width: double.infinity,
                  height: 330,
                  child: Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const Spacer(),
              // Headline
              SlideTransition(
                position: _slideUp,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        color: kTextWhite,
                        fontFamily: 'Inter',
                      ),
                      children: const [
                        TextSpan(text: 'Manage\nyour\nTask with\n'),
                        TextSpan(
                          text: 'DayTask',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // CTA button
              FadeTransition(
                opacity: _fadeIn,
                child: ElevatedButton(
                  onPressed: () => context.go('/login'),
                  child: const Text("Let's Start"),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _DayTaskLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontFamily: 'Inter',
        ),
        children: [
          TextSpan(text: 'Day', style: TextStyle(color: kTextWhite)),
          TextSpan(text: 'Task', style: TextStyle(color: kPrimaryColor)),
        ],
      ),
    );
  }
}
