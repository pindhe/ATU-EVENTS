import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/message_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class AdminMessagesScreen extends StatelessWidget {
  const AdminMessagesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final messageProvider = Provider.of<MessageProvider>(context);
    final messages = messageProvider.messages;

    return Scaffold(
      backgroundColor: apexBg,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 24),
            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (ctx, index) {
                        final msg = messages[index];
                        return _buildMessageTile(context, messageProvider, msg);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: apexText),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Container(width: 4, height: 16, decoration: BoxDecoration(color: apexPrimary, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text("COMMUNICATION HUB", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
          ],
        ),
        const SizedBox(height: 16),
        const Text("Student Messages", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: apexText)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mail_outline, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No messages yet", style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildMessageTile(BuildContext context, MessageProvider provider, dynamic msg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: msg.isRead ? Colors.transparent : apexPrimary.withOpacity(0.1)),
      ),
      child: ListTile(
        onTap: () {
          provider.markAsRead(msg.id);
          _showMessageDialog(context, msg);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: msg.isRead ? apexBg : apexPrimary.withOpacity(0.1),
          child: Icon(msg.isRead ? Icons.done_all : Icons.mail_outline, color: msg.isRead ? Colors.grey : apexPrimary, size: 20),
        ),
        title: Row(
          children: [
            Text(msg.senderName, style: TextStyle(fontWeight: msg.isRead ? FontWeight.w500 : FontWeight.bold, color: apexText)),
            if (!msg.isRead) ...[
              const SizedBox(width: 8),
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
            ],
          ],
        ),
        subtitle: Text(msg.content, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        trailing: Text(DateFormat('h:mm a').format(msg.timestamp), style: TextStyle(fontSize: 11, color: Colors.grey[500])),
      ),
    );
  }

  void _showMessageDialog(BuildContext context, dynamic msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.person_outline, color: apexPrimary),
            const SizedBox(width: 12),
            Expanded(child: Text(msg.senderName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg.senderEmail, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: apexBg, borderRadius: BorderRadius.circular(12)),
              child: Text(msg.content, style: const TextStyle(fontSize: 14, height: 1.5, color: apexText)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: apexPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            child: const Text('Send Reply', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
