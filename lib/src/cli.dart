import 'dart:io';

import 'package:task_manager/src/storage.dart';
import 'package:task_manager/src/task.dart';
import 'package:task_manager/src/task_manager.dart';

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
    final name = parts.first;
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
        case 'search':
          _handleSearch(args);
        case 'filter':
          _handleFilter(args);
        case 'categories':
          _handleCategories();
        case 'help':
          _printHelp();
        case 'exit':
          return;
        default:
          stderr.writeln('Unknown command: $name');
          _printHelp();
          exitCode = 1;
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
    DateTime? due;
    String category = 'general';
    final tags = <String>{};
    final titleWords = <String>[];

    for (var i = 0; i < args.length; i++) {
      final word = args[i];
      switch (word) {
        case '--due':
          final value = i + 1 < args.length ? args[++i] : '';
          due = DateTime.tryParse(value);
          if (due == null) {
            stderr.writeln('Invalid date: $value');
            exitCode = 1;
            return;
          }
        case '--cat':
          if (i + 1 >= args.length) {
            stderr.writeln('Usage: add <title> [--cat <name>]');
            exitCode = 1;
            return;
          }
          category = args[++i];
        case '--tag':
          if (i + 1 >= args.length) {
            stderr.writeln('Usage: add <title> [--tag <name>]');
            exitCode = 1;
            return;
          }
          tags.add(args[++i]);
        default:
          titleWords.add(word);
      }
    }

    var title = titleWords.join(' ');
    if (title.length >= 2 &&
        ((title.startsWith('"') && title.endsWith('"')) ||
            (title.startsWith("'") && title.endsWith("'")))) {
      title = title.substring(1, title.length - 1);
    }

    final task = manager.add(
      title,
      due: due,
      category: category,
      tags: tags,
    );
    storage.save(manager.getAll());
    stdout.writeln('Added: $task');
  }

  void _handleList() {
    _printTasks(manager.getAll(), 'No tasks.');
  }

  void _handleDone(List<String> args) {
    final id = _parseId(args);
    if (id == null) return;
    if (manager.markDone(id)) {
      storage.save(manager.getAll());
      stdout.writeln('Task $id marked as done.');
    } else {
      stderr.writeln('Task $id not found.');
      exitCode = 1;
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
      exitCode = 1;
    }
  }

  void _handleSearch(List<String> args) {
    final text = args.join(' ').trim();
    if (text.isEmpty) {
      stderr.writeln('Usage: search <text>');
      exitCode = 1;
      return;
    }
    _printTasks(manager.search(text), 'No matches.');
  }

  void _handleFilter(List<String> args) {
    const usage = 'Usage: filter --done | --pending | --tag <name>';

    if (args.length == 1 && args[0] == '--done') {
      _printTasks(manager.filter(done: true), 'No matches.');
    } else if (args.length == 1 && args[0] == '--pending') {
      _printTasks(manager.filter(done: false), 'No matches.');
    } else if (args.length == 2 && args[0] == '--tag') {
      _printTasks(manager.filter(tag: args[1]), 'No matches.');
    } else {
      stderr.writeln(usage);
      exitCode = 1;
    }
  }

  void _handleCategories() {
    final groups = manager.groupByCategory();
    if (groups.isEmpty) {
      stdout.writeln('No tasks.');
      return;
    }
    groups.forEach((category, tasks) {
      stdout.writeln('$category:');
      for (final task in tasks) {
        stdout.writeln('  $task');
      }
    });
  }

  void _printTasks(List<Task> tasks, String emptyMessage) {
    if (tasks.isEmpty) {
      stdout.writeln(emptyMessage);
      return;
    }
    for (final task in tasks) {
      stdout.writeln(task);
    }
  }

  int? _parseId(List<String> args) {
    if (args.isEmpty) {
      stderr.writeln('Usage: <command> <id>');
      exitCode = 1;
      return null;
    }

    final id = int.tryParse(args[0]);
    if (id == null) {
      stderr.writeln('Invalid id: ${args[0]}');
      exitCode = 1;
      return null;
    }

    return id;
  }

  void _printHelp() {
    stdout.writeln('Commands:');
    stdout.writeln(
        '  add <title> [--due YYYY-MM-DD] [--cat name] [--tag name]...');
    stdout.writeln('                         Add a new task');
    stdout.writeln('  list                   Show all tasks');
    stdout.writeln('  done <id>              Mark a task as done');
    stdout.writeln('  delete <id>            Delete a task');
    stdout.writeln('  search <text>          Search titles and descriptions');
    stdout.writeln('  filter --done | --pending | --tag <name>');
    stdout.writeln('                         Filter tasks');
    stdout.writeln('  categories             Show tasks grouped by category');
    stdout.writeln('  help                   Show this help');
    stdout.writeln('  exit                   Quit (interactive mode only)');
  }

}