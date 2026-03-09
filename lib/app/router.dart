import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/auth_service.dart';
import '../auth/login_screen.dart';
import '../auth/signup_screen.dart';
import '../create_task/create_task_screen.dart';
import '../main_shell/main_shell.dart';
import '../splash/splash_screen.dart';

GoRouter buildRouter(AuthService authService) {
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: authService,
    redirect: (context, state) {
      final isLoggedIn = authService.isLoggedIn;
      final location = state.matchedLocation;

      const publicPaths = ['/splash', '/login', '/signup'];
      final isPublic = publicPaths.contains(location);

      if (!isLoggedIn && !isPublic) return '/login';
      if (isLoggedIn && (location == '/login' || location == '/signup')) {
        return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, _) => const SignupScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (_, _) => const MainShell(),
      ),
      GoRoute(
        path: '/create-task',
        pageBuilder: (_, _) => CustomTransitionPage(
          child: const CreateTaskScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (_, animation, _, child) => SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          ),
        ),
      ),
    ],
  );
}
