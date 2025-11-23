import 'package:flutter/foundation.dart';
import '../models/prayer_topic.dart';
import '../services/database_service.dart';

class TopicsProvider with ChangeNotifier {
  List<PrayerTopic> _topics = [];
  final DatabaseService _db = DatabaseService();

  List<PrayerTopic> get topics => _topics;

  TopicsProvider() {
    loadTopics();
  }

  Future<void> loadTopics() async {
    _topics = await _db.getTopics();
    notifyListeners();
  }

  Future<void> addTopic(PrayerTopic topic) async {
    await _db.insertTopic(topic);
    await loadTopics();
  }

  Future<void> deleteTopic(int id) async {
    await _db.deleteTopic(id);
    await loadTopics();
  }

  Future<void> updateTopic(PrayerTopic topic) async {
    await _db.updateTopic(topic);
    await loadTopics();
  }
}
