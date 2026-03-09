import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/user_model.dart';
import '../dashboard/task_model.dart';

class SupabaseService {
  SupabaseService._();
  static final SupabaseService instance = SupabaseService._();

  SupabaseClient get _client => Supabase.instance.client;

  // ── Users ─────────────────────────────────────────────────────────────────

  Future<UserModel> createUser({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final data = await _client
        .from('users')
        .insert({'full_name': fullName, 'email': email, 'password': password})
        .select()
        .single();
    return UserModel.fromJson(data);
  }

  /// Returns null if email/password don't match.
  Future<UserModel?> loginUser({
    required String email,
    required String password,
  }) async {
    final data = await _client
        .from('users')
        .select()
        .eq('email', email)
        .eq('password', password)
        .maybeSingle();
    if (data == null) return null;
    return UserModel.fromJson(data);
  }

  Future<void> updateFullName(String userId, String fullName) async {
    await _client
        .from('users')
        .update({'full_name': fullName})
        .eq('id', userId);
  }

  Future<bool> emailExists(String email) async {
    final data = await _client
        .from('users')
        .select('id')
        .eq('email', email)
        .maybeSingle();
    return data != null;
  }

  // ── Tasks ─────────────────────────────────────────────────────────────────

  Future<List<Task>> fetchTasks(String userId) async {
    final data = await _client
        .from('tasks')
        .select()
        .eq('user_id', userId)
        .order('date', ascending: false);
    return (data as List).map((e) => Task.fromJson(e)).toList();
  }

  Future<Task> createTask({
    required String title,
    required String userId,
    required DateTime date,
  }) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final data = await _client
        .from('tasks')
        .insert({'user_id': userId, 'title': title, 'date': dateStr})
        .select()
        .single();
    return Task.fromJson(data);
  }

  Future<Task> toggleTask(Task task) async {
    final data = await _client
        .from('tasks')
        .update({'is_completed': !task.isCompleted})
        .eq('id', task.id)
        .select()
        .single();
    return Task.fromJson(data);
  }

  Future<void> deleteTask(String taskId) async {
    await _client.from('tasks').delete().eq('id', taskId);
  }
}
