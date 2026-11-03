import 'package:task_manager/src/storage.dart';
import 'package:task_manager/src/task.dart';
import 'package:task_manager/src/task_manager.dart';
import 'dart:io';

class Cli {
  final TaskManager manager;
  final Storage storage;

  Cli(this.manager, this.storage);

  void run(List<String> args) {
    if (args.isNotEmpty) {
      execute(args);
    } else {
      _interactiveLoop();
    }
  }

  void execute(List<String> parts) {
    final name = parts[0];
    final args = parts.sublist(1);
    try {
      switch (name) {
        case 'add':
          _handleAdd(args);
        case 'list':
          _handleList();
        case 'done':
          _handleDone(args);
        case 'delete':
          _handleDelete(args);
        case 'help':
          _printHelp();
        case 'exit':
          return;
        default:
          stderr.writeln('Unknown command: $name');
          _printHelp();
      }
    } catch (e) {
      stderr.writeln('Error: $e');
      exitCode = 1;
    }
  }

  void _interactiveLoop() {
    stdout.writeln('Task Manager. Type "help" for commands, "exit" to quit.');
    while (true) {
      stdout.write('> ');
      final line = stdin.readLineSync();

      if (line == null || line.trim() == 'exit') break;
      if (line.trim().isEmpty) continue;

      execute(line.trim().split(RegExp(r'\s+')));
    }
  }

  void _handleAdd(List<String> args) {
    final title = args.join(' ');
    Task task = manager.add(title);
    storage.save(manager.getAll());
    stdout.writeln('Added: $task');
  }

  void _handleList() {
    final List<Task> tasks = manager.getAll();
    if (tasks.isEmpty) {
      stdout.writeln('No Tasks.');
    } else {
      tasks.forEach((task) => stdout.writeln(task));
    }
  }

  void _handleDone(List<String> args) {
    final id = _parseId(args);
    if (id == null) return;
    if (manager.markDone(id)) {
      storage.save(manager.getAll());
      stdout.writeln('Task $id marked as done.');
    } else {
      stderr.writeln('Task $id not found.');
    }
  }

  void _handleDelete(List<String> args) {
    final id = _parseId(args);
    if (id == null) return;
    if (manager.remove(id)) {
      storage.save(manager.getAll());
      stdout.writeln('Task $id deleted.');
    } else {
      stderr.writeln('Task $id not found.');
    }
  }

  int? _parseId(List<String> args) {
    if (args.isEmpty) {
      stderr.writeln('Usage: <command> <id>');
      return null;
    }

    final id = int.tryParse(args[0]);
    if (id == null) {
      stderr.writeln('Invalid id: ${args[0]}');
      return null;
    }

    return id;
  }

  void _printHelp() {
    stdout.writeln('Commands:');
    stdout.writeln('  add <title>   Add a new task');
    stdout.writeln('  list          Show all tasks');
    stdout.writeln('  done <id>     Mark a task as done');
    stdout.writeln('  delete <id>   Delete a task');
    stdout.writeln('  help          Show this help');
    stdout.writeln('  exit          Quit (interactive mode only)');
  }

}