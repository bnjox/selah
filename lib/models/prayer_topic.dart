class PrayerTopic {
  final int? id;
  final String title;
  final String? description;
  final String? category;
  final bool isDefault;
  final DateTime createdAt;

  PrayerTopic({
    this.id,
    required this.title,
    this.description,
    this.category,
    this.isDefault = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'isDefault': isDefault ? 1 : 0,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory PrayerTopic.fromMap(Map<String, dynamic> map) {
    return PrayerTopic(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      isDefault: map['isDefault'] == 1,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
