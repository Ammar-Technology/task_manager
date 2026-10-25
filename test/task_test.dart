import 'package:test/test.dart';
import '../lib/src/task.dart';

void main() {
  group('Task Model Tests', () {
    setUp(() {
      Task.resetCounter();
    });

    test('Defult Values For New Task', () {
      final task = Task(title: 'Purchasing supplies');

      expect(task.category, equals('general'));
      expect(task.isDone, isFalse);
      expect(task.description, equals(''));
      expect(task.tags, isEmpty);
    });

    test('Sequential numbering', () {
      final task1 = Task(title: 'Study Dart');
      final task2 = Task(title: 'Study Flutter');

      expect(task1.id, 1);
      expect(task2.id, 2);
    });

    test('Increment the ID counter', () {
      final task1 = Task(title: 'Study Dart', id: 100);
      final task2 = Task(title: 'Study Flutter');

      expect(task1.id, 100);
      expect(task2.id, 101);
    });

    test('Standalone Tags', () {
      final task1 = Task(title: 'Study Dart', tags: {"Programming", "Basics"});
      final task2 = Task(title: 'Study Flutter', tags: {"ios", "Android"});

      expect(task1.tags, {"Programming", "Basics"});
      expect(task2.tags, {"ios", "Android"});
    });

    test('Task toString', () {
      final task1 = Task(
          title: 'Study Dart', tags: {"Programming", "Basics"}, isDone: true);
      final task2 = Task(title: 'Study Flutter', tags: {"ios", "Android"});

      expect(task1.toString(), '[1] [✓] Study Dart #Programming #Basics');
      expect(task2.toString(), '[2] [x] Study Flutter #ios #Android');
    });

    test('Round trip (toJson and fromJson) matches all fields', () {
      final originalTask = Task(
        id: 1,
        title: 'Complete Project',
        description: 'Finish the architecture reference tests',
        dueDate: DateTime(2026, 12, 31),
        isDone: true,
        category: 'work',
        tags: {'dart', 'flutter'},
      );

      final json = originalTask.toJson();
      final reconstructedTask = Task.fromJson(json);

      expect(reconstructedTask.id, equals(originalTask.id));
      expect(reconstructedTask.title, equals(originalTask.title));
      expect(reconstructedTask.description, equals(originalTask.description));
      expect(reconstructedTask.dueDate, equals(originalTask.dueDate));
      expect(reconstructedTask.isDone, equals(originalTask.isDone));
      expect(reconstructedTask.category, equals(originalTask.category));
      expect(reconstructedTask.tags, equals(originalTask.tags));
    });

    test('fromJson with missing fields fills defaults without exception', () {
      final incompleteJson = {
        'id': 10,
        'title:': 'Simple Task',
        'title': 'Simple Task',
        'createdAt': DateTime.now().toIso8601String(),
      };

      final task = Task.fromJson(incompleteJson);

      expect(task.id, equals(10));
      expect(task.title, equals('Simple Task'));
      expect(task.description, equals(''));
      expect(task.dueDate, isNull);
      expect(task.isDone, isFalse);
      expect(
          task.category, equals('general')); 
      expect(task.tags, isEmpty); 
    });
  });
}
