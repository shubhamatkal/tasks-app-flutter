import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../app/theme.dart';
import '../utils/validators.dart';
import 'auth_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
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
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final error = await context.read<AuthService>().signUp(
          fullName: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
    // GoRouter redirect fires automatically when isLoggedIn becomes true
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
                    'Create your account',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: kTextWhite,
                    ),
                  ),
                  const SizedBox(height: 28),
                  const _FieldLabel('Full Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameCtrl,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                    style: const TextStyle(color: kTextWhite, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Shubham Atkal',
                      prefixIcon: Icon(Icons.person_outline,
                          color: kTextMuted, size: 22),
                    ),
                    validator: Validators.fullName,
                  ),
                  const SizedBox(height: 20),
                  const _FieldLabel('Email Address'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    style: const TextStyle(color: kTextWhite, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'your@email.com',
                      prefixIcon: Icon(Icons.email_outlined,
                          color: kTextMuted, size: 22),
                    ),
                    validator: Validators.email,
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
                    validator: Validators.password,
                  ),
                  const SizedBox(height: 36),
                  _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: kPrimaryColor))
                      : ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Sign Up'),
                        ),
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: () => context.go('/login'),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                              color: kTextMuted,
                              fontSize: 16,
                              fontFamily: 'Inter'),
                          children: [
                            TextSpan(text: 'Already have an account? '),
                            TextSpan(
                              text: 'Log In',
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
