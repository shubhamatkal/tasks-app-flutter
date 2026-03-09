import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app/theme.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _animCtrl;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final error = await context.read<AuthService>().signIn(
          email: _usernameCtrl.text.trim(),
          password: _passwordCtrl.text,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
    }
    // GoRouter redirect fires automatically on auth state change
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBgColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Center(child: _DayTaskLogo()),
                  const SizedBox(height: 56),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: kTextWhite,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _FieldLabel('Username'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _usernameCtrl,
                    autocorrect: false,
                    style: const TextStyle(color: kTextWhite, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'your username',
                      prefixIcon: Icon(Icons.person_outline,
                          color: kTextMuted, size: 22),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Enter your username'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  const _FieldLabel('Password'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: kTextWhite, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: kTextMuted, size: 22),
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: kTextMuted,
                          size: 22,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Enter your password' : null,
                  ),
                  const SizedBox(height: 36),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: kPrimaryColor))
                      : ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Log In'),
                        ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go('/signup'),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              color: kTextMuted,
                              fontSize: 16,
                              fontFamily: 'Inter'),
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            color: kTextMuted, fontSize: 16, fontWeight: FontWeight.w500),
      );
}

class _DayTaskLogo extends StatelessWidget {
  const _DayTaskLogo();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Icon(Icons.task_alt, color: kPrimaryColor, size: 48),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Inter'),
              children: [
                TextSpan(
                    text: 'Day', style: TextStyle(color: kTextWhite)),
                TextSpan(
                    text: 'Task', style: TextStyle(color: kPrimaryColor)),
              ],
            ),
          ),
        ],
      );
}
