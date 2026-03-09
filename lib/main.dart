import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'auth/auth_service.dart';

const _supabaseUrl = 'https://lhxywjymxczrfwhkoitf.supabase.co';
const _supabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxoeHl3anlteGN6cmZ3aGtvaXRmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMwMTA1ODYsImV4cCI6MjA4ODU4NjU4Nn0.nxeKhPTiQhOgLin30cOUBbUtPCyXspWnEypb5brQ-hs';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: _supabaseUrl,
    anonKey: _supabaseAnonKey,
  );

  final authService = AuthService();
  await authService.restoreSession();

  runApp(DayTaskApp(authService: authService));
}

class DayTaskApp extends StatelessWidget {
  final AuthService authService;
  const DayTaskApp({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: authService,
      child: Builder(
        builder: (context) {
          final auth = context.watch<AuthService>();
          final router = buildRouter(auth);
          return MaterialApp.router(
            title: 'DayTask',
            theme: buildAppTheme(),
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
