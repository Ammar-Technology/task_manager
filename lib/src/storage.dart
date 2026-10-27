import 'dart:convert';
import 'dart:io';
import 'task.dart';

class Storage {
  final String filePath;

  Storage({
    this.filePath = 'tasks.json',
  });

  List<Task> load() {
    final file = File(filePath);
    if (!file.existsSync()) {
      return [];
    }
    String jsonString = file.readAsStringSync();
    if (jsonString.trim().isEmpty) {
      return [];
    }
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((item) {
      Map<String, dynamic> map = item as Map<String, dynamic>;
      return Task(
        id: map['id'],
        title: map['title'],
        createdAt: DateTime.parse(map['createdAt']),
        description: map['description'] ?? '',
        dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
        isDone: map['isDone'] ?? false,
        category: map['category'] ?? '',
        tags: Set<String>.from(map['tags'] ?? []),
      );
    }).toList();
  }

  void save(List<Task> tasks) {
    List<Map<String, dynamic>> tasksList = tasks.map((task) {
      return {
        'id': task.id,
        'title': task.title,
        'createdAt': task.createdAt.toIso8601String(),
        'description': task.description,
        'dueDate': task.dueDate?.toIso8601String(),
        'isDone': task.isDone,
        'category': task.category,
        'tags': task.tags.toList(),
      };
    }).toList();

    File(filePath).writeAsStringSync(jsonEncode(tasksList));
  }
}
