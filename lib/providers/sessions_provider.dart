import 'package:flutter/foundation.dart';
import '../models/session.dart';
import '../services/database_service.dart';

class SessionsProvider with ChangeNotifier {
  // ignore: unused_field
  final DatabaseService _db = DatabaseService();
  List<Session> _sessions = [];

  List<Session> get sessions => _sessions;

  SessionsProvider() {
    loadSessions();
  }

  Future<void> loadSessions() async {
    _sessions = await _db.getSessions();
    notifyListeners();
  }
  
  Future<void> saveSession(Session session) async {
    await _db.insertSession(session);
    await loadSessions();
  }
}
