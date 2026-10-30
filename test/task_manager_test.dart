import 'package:test/test.dart';
import 'package:task_manager/src/task.dart';
import 'package:task_manager/src/task_manager.dart';

void main() {
  group('TaskManager', () {
    late TaskManager manager;

    setUp(() {
      Task.resetCounter();
      manager = TaskManager();
    });

    test('add increases length and returns the task', () {
      Task task = manager.add('Study Dart');
      expect(manager.getAll().length, 1);
      expect(task.title, 'Study Dart');
    });

    test('add trims the title', () {
      Task task = manager.add("  Study Dart  ");
      expect(task.title, 'Study Dart');
    });

    test('add throws ArgumentError for empty or whitespace title', () {
      expect(() => manager.add(""), throwsA(isA<ArgumentError>()));
      expect(() => manager.add("   "), throwsA(isA<ArgumentError>()));
    });

    test('remove returns true and deletes an existing task', () {
      manager.add('Study Dart');
      expect(manager.remove(1), true);
      expect(manager.getAll().length, 0);
    });

    test('remove returns false for a missing id', () {
      manager.add('Study Dart');
      expect(manager.remove(99), false);
      expect(manager.getAll().length, 1);
    });

    test('markDone marks an existing task as done', () {
      Task task = manager.add('Study Dart');
      expect(manager.markDone(1), true);
      expect(task.isDone, true);
    });

    test('markDone returns false for a missing id', () {
      Task task = manager.add('Study Dart');
      expect(manager.markDone(99), false);
      expect(task.isDone, false);
    });

    test('findById returns the task when it exists', () {
      Task task = manager.add('Study Dart');
      expect(manager.findById(1), same(task));
    });
    test('findById returns null for a missing id', () {
      manager.add('Study Dart');
      expect(manager.findById(99), isNull);
    });

    test('getAll returns an unmodifiable list', () {
      expect(() => manager.getAll().add(Task(title: 'Study Dart')),
          throwsUnsupportedError);
    });
  });
}
