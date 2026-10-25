# Task Manager CLI Application

A robust, clean, and fully tested Dart command-line interface (CLI) task management system built using Clean Architecture, Object-Oriented Programming (OOP), defensive Null-Safety, and Test-Driven Development (TDD) practices.

---

## Key Features

* **Task Model Architecture:**
  * **Auto-Incrementing IDs:** Manages unique task identifiers sequentially, with support for explicit ID assignment that updates the global counter[cite: 10].
  * **Null-Safe Data Handling:** Defensive type-casting and parsing for optional task attributes including categories, descriptions, due dates, and tags[cite: 10].
  * **Independent Tags:** Uses Dart Set collection to ensure tag uniqueness and isolation per task[cite: 10].
  * **Formatted String Output (toString):** Visual status indicators (checkmark for completed, x for pending) with formatted tag labels[cite: 10].

* **JSON Serialization & Round-Trip Integrity:**
  * Custom toJson() and Task.fromJson() serialization[cite: 10].
  * Safe handling of missing JSON fields with seamless fallback to default values[cite: 10].

* **Comprehensive Unit Testing Suite:**
  * 100% test coverage for the Task model using package:test.
  * Isolated test execution with state reset hooks (setUp & Task.resetCounter()).

---

## Project Structure

```text
task_manager/
├── bin/
│   └── task_manager.dart      # Application entry point only
├── lib/
│   └── src/
│       ├── task.dart          # Core Task model & logic
│       ├── task_manager.dart  # Business logic (add, remove, search, filter)
│       ├── storage.dart       # JSON storage & file I/O operations
│       └── cli.dart           # Command parsing & CLI interaction
└── test/
    ├── task_test.dart         # Task model unit tests
    ├── task_manager_test.dart # Manager logic unit tests
    └── storage_test.dart      # Storage unit tests
