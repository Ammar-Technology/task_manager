import 'dart:convert';
import 'dart:io';
import 'task.dart';

class Storage {
  final String filePath;

  Storage({this.filePath = 'tasks.json'});

  List<Task> load() {
    final file = File(filePath);

    if (!file.existsSync()) return [];

    final text = file.readAsStringSync();
    if (text.trim().isEmpty) return [];

    try {
      final data = jsonDecode(text);
      if (data is! List) {
        throw const FormatException('Root must be a list');
      }
      return data.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
    } on FormatException catch (_) {
      return _recover(file);
    } on TypeError catch (_) {
      return _recover(file);
    }
  }

  List<Task> _recover(File file) {
    stderr.writeln(
        'Warning: $filePath is corrupted. Moved to $filePath.bak, starting empty.');
    file.renameSync('$filePath.bak');
    return [];
  }

  void save(List<Task> tasks) {
    final list = tasks.map((t) => t.toJson()).toList();
    const encoder = JsonEncoder.withIndent('  ');
    File(filePath).writeAsStringSync(encoder.convert(list));
  }
}
