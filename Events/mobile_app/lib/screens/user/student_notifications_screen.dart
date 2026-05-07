import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/notification_provider.dart';
import '../../models/notification_model.dart';
import 'package:intl/intl.dart';

class StudentNotificationsScreen extends StatelessWidget {
  const StudentNotificationsScreen({Key? key}) : super(key: key);

  final Color apexPrimary = const Color(0xFF5A67D8);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationProvider = Provider.of<NotificationProvider>(context);
    final notifications = notificationProvider.notifications;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: theme.textTheme.bodyLarge?.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () => notificationProvider.markAllAsRead(),
              child: Text(
                'Mark all read',
                style: TextStyle(color: apexPrimary, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 40),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationItem(context, theme, notification, notificationProvider);
              },
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no new notifications.',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, ThemeData theme, AppNotification notification, NotificationProvider provider) {
    return Dismissible(
      key: Key(notification.id),
      onDismissed: (_) => provider.deleteNotification(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
      ),
      child: InkWell(
        onTap: () => provider.markAsRead(notification.id),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.transparent : apexPrimary.withOpacity(0.03),
            border: Border(bottom: BorderSide(color: theme.dividerColor.withOpacity(0.05))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeIcon(notification),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.bold,
                              fontSize: 15,
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                        ),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.content,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                    if (notification.type == NotificationType.networking)
                      _buildNetworkingActions(theme),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(AppNotification notification) {
    IconData icon;
    Color color;

    switch (notification.type) {
      case NotificationType.reminder:
        icon = Icons.event_rounded;
        color = Colors.orange;
        break;
      case NotificationType.networking:
        icon = Icons.people_rounded;
        color = apexPrimary;
        break;
      case NotificationType.update:
        icon = Icons.rocket_launch_rounded;
        color = Colors.green;
        break;
      case NotificationType.announcement:
        icon = Icons.campaign_rounded;
        color = Colors.blue;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildNetworkingActions(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: apexPrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(100, 36),
            ),
            child: const Text('Accept', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.textTheme.bodyLarge?.color,
              side: BorderSide(color: theme.dividerColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(100, 36),
            ),
            child: const Text('Decline', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d').format(timestamp);
    }
  }
}
