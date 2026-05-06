import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/security_log.dart';

class LogProvider with ChangeNotifier {
  List<SecurityLog> _logs = [];

  LogProvider() {
    _loadLogs();
  }

  List<SecurityLog> get logs => [..._logs];

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? logList = prefs.getStringList('security_logs');
    if (logList != null) {
      _logs = logList.map((l) => SecurityLog.fromJson(jsonDecode(l))).toList();
      _logs.sort((a, b) => b.time.compareTo(a.time)); // Latest first
      notifyListeners();
    }
  }

  Future<void> _saveLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> logList = _logs.map((l) => jsonEncode(l.toJson())).toList();
    await prefs.setStringList('security_logs', logList);
  }

  void addLog({
    required String event,
    required String user,
    required String status,
    required String severity,
    String ip = '127.0.0.1',
  }) {
    final newLog = SecurityLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      event: event,
      user: user,
      status: status,
      ip: ip,
      time: DateTime.now(),
      severity: severity,
    );
    _logs.insert(0, newLog);
    _saveLogs();
    notifyListeners();
  }

  void clearLogs() {
    _logs.clear();
    _saveLogs();
    notifyListeners();
  }
}
