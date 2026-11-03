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

    test('constructor with initial list exposes tasks in getAll', () {
      final custom = TaskManager([Task(title: 'A'), Task(title: 'B')]);
      expect(custom.getAll().length, 2);
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

    test('search is case-insensitive', () {
      Task task = manager.add('Buy milk');
      expect(manager.search("MILK"), [task]);
    });

    test('search finds a task by title', () {
      Task task = manager.add('Buy Milk');
      expect(manager.search("milk"), [task]);
    });

    test('search finds a task by description', () {
      Task task = manager.add('Study');
      task.description = 'learn about milk';
      expect(manager.search("milk"), [task]);
    });

    test('filter by done and tag together', () {
      final m = TaskManager();
      m.add('a', tags: {'x'});
      m.add('b', tags: {'x'});
      m.add('c');
      m.markDone(m.getAll()[0].id);

      expect(m.filter(done: true, tag: 'x').length, 1);
      expect(m.filter(tag: 'x').length, 2);
      expect(m.filter().length, 3);
    });
  });
}
