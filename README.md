## Project Structure

task_manager/
├── bin/task_manager.dart         ← Entry point only
├── lib/src/
│   ├── task.dart                 ← Task model
│   ├── task_manager.dart         ← Core logic: add, remove, search, filter
│   ├── storage.dart              ← Reading and writing JSON
│   └── cli.dart                  ← Command parsing and execution
├── test/task_manager_test.dart   ← Unit tests
└── tasks.json                    ← Created automatically on first save

