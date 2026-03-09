import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_app/dashboard/task_model.dart';

void main() {
  group('Task model serialization', () {
    const sampleJson = {
      'id': 'abc-123',
      'user_id': 'user-456',
      'title': 'Write unit tests',
      'is_completed': false,
      'date': '2026-03-09',
    };

    test('fromJson parses all fields correctly', () {
      final task = Task.fromJson(sampleJson);

      expect(task.id, 'abc-123');
      expect(task.userId, 'user-456');
      expect(task.title, 'Write unit tests');
      expect(task.isCompleted, false);
      expect(task.date, DateTime(2026, 3, 9));
    });

    test('toJson round-trips correctly', () {
      final task = Task.fromJson(sampleJson);
      final json = task.toJson();

      expect(json['id'], task.id);
      expect(json['user_id'], task.userId);
      expect(json['title'], task.title);
      expect(json['is_completed'], task.isCompleted);
      expect(json['date'], '2026-03-09');
    });

    test('copyWith updates only specified fields', () {
      final task = Task.fromJson(sampleJson);
      final updated = task.copyWith(title: 'Updated title', isCompleted: true);

      expect(updated.id, task.id);
      expect(updated.userId, task.userId);
      expect(updated.title, 'Updated title');
      expect(updated.isCompleted, true);
      expect(updated.date, task.date);
    });

    test('equality is based on id', () {
      final t1 = Task.fromJson(sampleJson);
      final t2 = Task.fromJson({...sampleJson, 'title': 'Different title'});
      final t3 = Task.fromJson({...sampleJson, 'id': 'other-id'});

      expect(t1, equals(t2)); // same id
      expect(t1, isNot(equals(t3))); // different id
    });

    test('fromJson defaults is_completed to false when absent', () {
      final json = Map<String, dynamic>.from(sampleJson)
        ..remove('is_completed');
      final task = Task.fromJson(json);
      expect(task.isCompleted, false);
    });
  });
}
