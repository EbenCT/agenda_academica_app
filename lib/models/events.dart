class Event {
  final String title;
  final DateTime start;
  final DateTime end;
  final String eventType;
  final String priority;
  final String state;
  final String description;

  Event({
    required this.title,
    required this.start,
    required this.end,
    required this.eventType,
    required this.priority,
    required this.state,
    required this.description,
  });

  @override
  String toString() => title;
}
