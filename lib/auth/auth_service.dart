import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/supabase_service.dart';
import 'user_model.dart';

const _kUserId = 'user_id';
const _kFullName = 'full_name';
const _kEmail = 'email';

class AuthService extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;

  /// Restore session saved from a previous app run.
  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(_kUserId);
    final fullName = prefs.getString(_kFullName);
    final email = prefs.getString(_kEmail);
    if (id != null && fullName != null && email != null) {
      _user = UserModel(id: id, fullName: fullName, email: email);
      notifyListeners();
    }
  }

  Future<String?> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final exists = await SupabaseService.instance.emailExists(email);
      if (exists) return 'An account with this email already exists.';

      final newUser = await SupabaseService.instance.createUser(
        fullName: fullName,
        email: email,
        password: password,
      );
      await _saveSession(newUser);
      return null;
    } catch (e) {
      return 'Sign up failed: $e';
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final found = await SupabaseService.instance.loginUser(
        email: email,
        password: password,
      );
      if (found == null) return 'Invalid email or password.';
      await _saveSession(found);
      return null;
    } catch (e) {
      return 'Login failed: $e';
    }
  }

  Future<String?> updateFullName(String newName) async {
    if (_user == null) return 'Not logged in.';
    try {
      await SupabaseService.instance.updateFullName(_user!.id, newName);
      final updated = UserModel(id: _user!.id, fullName: newName, email: _user!.email);
      await _saveSession(updated);
      return null;
    } catch (e) {
      return 'Update failed: $e';
    }
  }

  Future<void> signOut() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUserId);
    await prefs.remove(_kFullName);
    await prefs.remove(_kEmail);
    notifyListeners();
  }

  Future<void> _saveSession(UserModel user) async {
    _user = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUserId, user.id);
    await prefs.setString(_kFullName, user.fullName);
    await prefs.setString(_kEmail, user.email);
    notifyListeners();
  }
}
