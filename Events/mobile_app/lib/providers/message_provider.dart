import 'package:flutter/material.dart';
import '../models/admin_message.dart';

class MessageProvider with ChangeNotifier {
  final List<AdminMessage> _messages = [
    AdminMessage(
      id: 'm1',
      senderId: 's1',
      senderName: 'Alice Johnson',
      senderEmail: 'alice@atu.edu',
      content: 'I have a question about the Tech Symposium registration.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  List<AdminMessage> get messages => [..._messages].reversed.toList();
  int get unreadCount => _messages.where((m) => !m.isRead).length;

  void sendMessage(AdminMessage message) {
    _messages.add(message);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _messages.indexWhere((m) => m.id == id);
    if (index >= 0) {
      _messages[index].isRead = true;
      notifyListeners();
    }
  }

  void deleteMessage(String id) {
    _messages.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}
