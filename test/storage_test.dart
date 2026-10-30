import 'dart:io';
import 'package:test/test.dart';
import 'package:task_manager/src/task.dart';
import 'package:task_manager/src/storage.dart';

void main() {
  group('Storage Model Tests', () {
    setUp(() {
      Task.resetCounter();
    });

    test('File Doses Not Exist', () {
      final storage = Storage();
      expect(storage.load(), []);
    });

    test('save and load roundtrip successfully', () {
      final tempDir = Directory.systemTemp.createTempSync();
      final filePath = '${tempDir.path}/tasks.json';
      final storage = Storage(filePath: filePath);

      final task1 = Task(title: 'Task 1');
      final task2 = Task(
          title: 'Task 2', description: 'Test description', category: 'work');

      storage.save([task1, task2]);
      final loadedTasks = storage.load();

      expect(loadedTasks.length, equals(2));
      expect(loadedTasks[0].title, equals('Task 1'));
      expect(loadedTasks[1].description, equals('Test description'));
      expect(loadedTasks[1].category, equals('work'));

      tempDir.deleteSync(recursive: true);
    });

    test('File Is Empty', () {
      final tempDir = Directory.systemTemp.createTempSync();
      final filePath = '${tempDir.path}/tasks.json';
      final storage = Storage(filePath: filePath);
      expect(storage.load(), []);
      tempDir.deleteSync(recursive: true);
    });

    test('Corrupt JSON', () {
      final tempDir = Directory.systemTemp.createTempSync();
      final filePath = '${tempDir.path}/tasks.json';
      File(filePath).writeAsStringSync('{ this is not valid json [');

      final storage = Storage(filePath: filePath);
      final loadedTasks = storage.load();
      expect(loadedTasks, isEmpty);
      expect(File('$filePath.bak').existsSync(), isTrue);
      expect(File(filePath).existsSync(), isFalse);

      tempDir.deleteSync(recursive: true);
    });

    test('Field With An Incorrect Type', () {
      final tempDir = Directory.systemTemp.createTempSync();
      final filePath = '${tempDir.path}/tasks.json';
      File(filePath).writeAsStringSync('''
[
  {
    "id": "abc",
    "title": "Bad task",
    "createdAt": "2026-10-19T14:32:05.123456"
  }
]
''');

      final storage = Storage(filePath: filePath);
      final loadedTasks = storage.load();

      expect(loadedTasks, isEmpty);
      expect(File('$filePath.bak').existsSync(), isTrue);
      expect(File(filePath).existsSync(), isFalse);

      tempDir.deleteSync(recursive: true);
    });
  });
}
