class AdminMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String senderEmail;
  final String content;
  final DateTime timestamp;
  bool isRead;

  AdminMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderEmail,
    required this.content,
    required this.timestamp,
    this.isRead = false,
  });
}
