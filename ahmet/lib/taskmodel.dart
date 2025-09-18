class Task {
  String title;
  bool isChecked;
  int priority;
  DateTime deadline;

  Task({
    required this.title,
    required this.isChecked,
    required this.priority,
    required this.deadline,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "isChecked": isChecked,
        "priority": priority,
        "deadline": deadline.toIso8601String(),
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json["title"] ?? "",
        isChecked: json["isChecked"] ?? false,
        priority: json["priority"] ?? 0,
        deadline: DateTime.parse(json["deadline"]),
      );
}
