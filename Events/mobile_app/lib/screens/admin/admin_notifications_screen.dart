import 'package:flutter/material.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class AdminNotificationsScreen extends StatefulWidget {
  const AdminNotificationsScreen({Key? key}) : super(key: key);

  @override
  _AdminNotificationsScreenState createState() => _AdminNotificationsScreenState();
}

class _AdminNotificationsScreenState extends State<AdminNotificationsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _message = '';
  String _targetAudience = 'All Users';

  final List<String> _audiences = ['All Users', 'Teachers Only', 'Normal Users Only'];
  final List<Map<String, String>> _history = [
    {'title': 'Welcome Back!', 'message': 'Welcome to the new semester.', 'audience': 'All Users', 'date': '2 days ago'},
    {'title': 'Maintenance', 'message': 'System will be down for 2 hours tonight.', 'audience': 'All Users', 'date': '1 week ago'},
  ];

  void _sendNotification() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _history.insert(0, {
          'title': _title,
          'message': _message,
          'audience': _targetAudience,
          'date': 'Just now',
        });
      });
      _formKey.currentState!.reset();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification broadcasted successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: apexBg,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 24),
            _buildBroadcastForm(),
            const SizedBox(height: 32),
            _buildHistorySection(),
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
            Text("BROADCAST CENTER", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
          ],
        ),
        const SizedBox(height: 16),
        const Text("Announcements", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: apexText)),
      ],
    );
  }

  Widget _buildBroadcastForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildTextField('Notification Title', Icons.title, (val) => _title = val!),
            const SizedBox(height: 16),
            _buildTextField('Message Body', Icons.message_outlined, (val) => _message = val!, maxLines: 3),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _targetAudience,
              decoration: _inputDecoration('Target Audience', Icons.people_outline),
              items: _audiences.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
              onChanged: (val) { setState(() { _targetAudience = val!; }); },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: apexPrimary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                onPressed: _sendNotification,
                icon: const Icon(Icons.send),
                label: const Text('Send Broadcast', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText.withOpacity(0.8))),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (ctx, index) {
                final notif = _history[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey[100]!),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: apexPrimary.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.campaign_outlined, color: apexPrimary),
                    ),
                    title: Text(notif['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(notif['message']!, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.group_outlined, size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(notif['audience']!, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                            const SizedBox(width: 12),
                            Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Text(notif['date']!, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, FormFieldSetter<String> onSaved, {int maxLines = 1}) {
    return TextFormField(
      decoration: _inputDecoration(label, icon),
      maxLines: maxLines,
      validator: (val) => val!.isEmpty ? 'Required field' : null,
      onSaved: onSaved,
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: apexPrimary, size: 20),
      labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
      filled: true,
      fillColor: apexBg,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: apexPrimary, width: 1.5)),
    );
  }
}
