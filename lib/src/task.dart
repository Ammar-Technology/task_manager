class Task {
  static int _counter = 0;

  final int id;
  final String title;
  final DateTime createdAt;

  String description;
  DateTime? dueDate;
  bool isDone;
  String category;
  Set<String> tags;

  Task(
      {int? id,
      DateTime? createdAt,
      Set<String>? tags,
      required this.title,
      this.description = '',
      this.dueDate,
      this.isDone = false,
      this.category = 'general'})
      : id = _resolveId(id),
        createdAt = createdAt ?? DateTime.now(),
        tags = tags ?? {};

  static int _resolveId(int? given) {
    if (given == null) return ++_counter;
    if (given > _counter) _counter = given;
    return given;
  }

  static void resetCounter() {
    _counter = 0;
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    final int id = json['id'] as int;
    final String title = json['title'] as String;
    final DateTime createdAt = DateTime.parse(json['createdAt'] as String);
    final String description = json['description'] as String? ?? '';
    final DateTime? dueDate = json['dueDate'] != null
        ? DateTime.parse(json['dueDate'] as String)
        : null;
    final bool isDone = json['isDone'] as bool? ?? false;
    final String category = json['category'] as String? ?? 'general';
    final Set<String> tags = {};

    List<dynamic>? rawTags = json['tags'] as List<dynamic>?;
    if (rawTags != null) {
      for (var element in rawTags) {
        tags.add(element);
      }
    }

    return Task(
      id: id,
      title: title,
      createdAt: createdAt,
      description: description,
      dueDate: dueDate,
      isDone: isDone,
      category: category,
      tags: tags,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "createdAt": createdAt.toIso8601String(),
      "description": description,
      "dueDate": dueDate?.toIso8601String(),
      "isDone": isDone,
      "category": category,
      "tags": tags.toList(),
    };
  }

  @override
  String toString() {
    final status = isDone ? '✓' : 'x';
    final tagsText = tags.map((t) => '#$t').join(' ');
    return '[$id] [$status] $title $tagsText'.trim();
  }
}
