import 'package:task_manager/src/task.dart';

class TaskManager {
  final List<Task> _tasks;
  TaskManager([List<Task>? initial]) : _tasks = [...?initial];

  Task add(String title,
      {DateTime? due, String category = 'general', Set<String>? tags}) {
    final cleanTitle = title.trim();
    if (cleanTitle.isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    final newTask =
        Task(title: cleanTitle, category: category, dueDate: due, tags: tags);
    _tasks.add(newTask);
    return newTask;
  }

  bool remove(int id) {
    final before = _tasks.length;
    _tasks.removeWhere((task) => task.id == id);
    return _tasks.length < before;
  }

  Task? findById(int id) {
    return _tasks.where((task) => task.id == id).firstOrNull;
  }

  bool markDone(int id) {
    Task? targetTask = findById(id);
    if (targetTask != null) {
      targetTask.isDone = true;
      return true;
    } else {
      return false;
    }
  }

  List<Task> getAll() {
    return List.unmodifiable(_tasks);
  }
}
