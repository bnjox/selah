class Session {
  final int? id;
  final String name;
  final int totalDurationSeconds;
  final DateTime? completedAt;
  final DateTime createdAt;

  Session({
    this.id,
    required this.name,
    required this.totalDurationSeconds,
    this.completedAt,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'totalDurationSeconds': totalDurationSeconds,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      name: map['name'],
      totalDurationSeconds: map['totalDurationSeconds'],
      completedAt: map['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completedAt'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
