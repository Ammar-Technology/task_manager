# Changelog

## 1.0.0 - 2026-11-04

First stable release.

### Added

- Commands: `add`, `list`, `done`, `delete`, `search`, `filter`, `categories`, `help`.
- Task options on `add`: due date (`--due`), category (`--cat`), tags (`--tag`).
- Two run modes: one-shot command and interactive prompt.
- Automatic saving to `tasks.json`, restored on the next run.
- Safe handling of corrupted data files (moved to `tasks.json.bak`).
- Unit tests for the model, business logic and storage.

### Known limitations

- A task's description cannot be set from the CLI.
- No command to edit or reopen a task.
- Deleting the highest ID and restarting may reuse that ID.