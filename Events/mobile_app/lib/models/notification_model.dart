import 'package:flutter/material.dart';

enum NotificationType { announcement, reminder, networking, update }

class AppNotification {
  final String id;
  final String title;
  final String content;
  final DateTime timestamp;
  final NotificationType type;
  bool isRead;
  final String? relatedId; // Event ID or User ID
  final String? senderName;
  final String? senderImage;

  AppNotification({
    required this.id,
    required this.title,
    required this.content,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.relatedId,
    this.senderName,
    this.senderImage,
  });
}
