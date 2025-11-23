class AppSettings {
  final String key;
  final String value;

  AppSettings({
    required this.key,
    required this.value,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'value': value,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      key: map['key'],
      value: map['value'],
    );
  }
}
