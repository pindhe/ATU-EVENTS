class SecurityLog {
  final String id;
  final String event;
  final String user;
  final String status;
  final String ip;
  final DateTime time;
  final String severity;

  SecurityLog({
    required this.id,
    required this.event,
    required this.user,
    required this.status,
    required this.ip,
    required this.time,
    required this.severity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'event': event,
      'user': user,
      'status': status,
      'ip': ip,
      'time': time.toIso8601String(),
      'severity': severity,
    };
  }

  factory SecurityLog.fromJson(Map<String, dynamic> json) {
    return SecurityLog(
      id: json['id'],
      event: json['event'],
      user: json['user'],
      status: json['status'],
      ip: json['ip'],
      time: DateTime.parse(json['time']),
      severity: json['severity'],
    );
  }
}
