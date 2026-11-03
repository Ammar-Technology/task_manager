import 'package:task_manager/src/cli.dart';
import 'package:task_manager/src/storage.dart';
import 'package:task_manager/src/task_manager.dart';

void main(List<String> arguments) {
  Storage storage = Storage();
  TaskManager manager = TaskManager(storage.load());
  Cli cli = Cli(manager, storage);
  cli.run(arguments);
}
