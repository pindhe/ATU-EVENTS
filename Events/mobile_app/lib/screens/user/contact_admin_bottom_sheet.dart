import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/message_provider.dart';
import '../../models/admin_message.dart';

class ContactAdminBottomSheet extends StatefulWidget {
  const ContactAdminBottomSheet({Key? key}) : super(key: key);

  @override
  _ContactAdminBottomSheetState createState() => _ContactAdminBottomSheetState();
}

class _ContactAdminBottomSheetState extends State<ContactAdminBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final messageProvider = Provider.of<MessageProvider>(context, listen: false);
      final user = authProvider.currentUser;

      final newMessage = AdminMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: user?.id ?? 'unknown',
        senderName: '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
        senderEmail: user?.email ?? '',
        content: _messageController.text,
        timestamp: DateTime.now(),
      );

      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      messageProvider.sendMessage(newMessage);

      if (mounted) {
        Navigator.pop(context);
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 10),
            Text('Success'),
          ],
        ),
        content: const Text('Thank you! Your message has been sent successfully.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message sent to Admin'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contact Admin', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              initialValue: '${user?.firstName ?? ''} ${user?.lastName ?? ''}',
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: user?.email ?? '',
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                hintText: 'Describe your issue or question...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 4,
              validator: (val) => val!.isEmpty ? 'Please write a message' : null,
              onChanged: (val) => setState(() {}),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _messageController.text.isEmpty || _isSending ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSending 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Send Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
