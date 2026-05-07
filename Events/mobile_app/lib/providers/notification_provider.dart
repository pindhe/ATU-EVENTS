import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationProvider with ChangeNotifier {
  final List<AppNotification> _notifications = [
    AppNotification(
      id: 'n1',
      title: 'Global Tech Summit 2024',
      content: 'Your primary session \'The Future of AI\' begins at 10:00 AM in Hall A. Don\'t forget your digital badge.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
      type: NotificationType.reminder,
      relatedId: 'e1',
    ),
    AppNotification(
      id: 'n2',
      title: 'Networking Request',
      content: '"I\'d love to connect and discuss your recent presentation on sustainable logistics."',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: NotificationType.networking,
      senderName: 'David Chen',
      senderImage: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?auto=format&fit=crop&w=150&q=80',
    ),
    AppNotification(
      id: 'n3',
      title: 'Apex Events v2.4 Now Available',
      content: 'We\'ve introduced real-time floor mapping and enhanced messaging for seamless event navigation.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.update,
    ),
    AppNotification(
      id: 'n4',
      title: 'New Announcement',
      content: 'The campus library will be closed this weekend for maintenance. Please plan accordingly.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: NotificationType.announcement,
    ),
  ];

  List<AppNotification> get notifications => [..._notifications]..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  
  List<AppNotification> get unreadNotifications => _notifications.where((n) => !n.isRead).toList();
  
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void addNotification(AppNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index >= 0) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
