import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/event_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);

class TeacherAnnouncementsScreen extends StatefulWidget {
  const TeacherAnnouncementsScreen({Key? key}) : super(key: key);

  @override
  _TeacherAnnouncementsScreenState createState() => _TeacherAnnouncementsScreenState();
}

class _TeacherAnnouncementsScreenState extends State<TeacherAnnouncementsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _message = '';
  String? _targetClassId;
  String? _targetEventId;
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    
    final teacherId = authProvider.currentUser?.email ?? '';
    final myClasses = classProvider.getClassesForTeacher(teacherId);
    final myEvents = eventProvider.getEventsByTeacher(authProvider.currentUser?.username ?? '');

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Audience Selection"),
                    const SizedBox(height: 16),
                    _buildAudienceSelectors(myClasses, myEvents),
                    const SizedBox(height: 32),
                    _buildSectionHeader("Broadcast Message"),
                    const SizedBox(height: 16),
                    _buildMessageInput(),
                    const SizedBox(height: 32),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("Broadcast Center", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87, fontWeight: FontWeight.bold, fontSize: 24)),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87));
  }

  Widget _buildAudienceSelectors(List<dynamic> classes, List<dynamic> events) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _buildDropdown(
            "Target Class",
            Icons.school_outlined,
            _targetClassId,
            classes.map((c) => DropdownMenuItem<String?>(value: c.id.toString(), child: Text(c.name.toString()))).toList(),
            (val) => setState(() {
              _targetClassId = val;
              if (val != null) _targetEventId = null;
            }),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("OR", style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))),
                Expanded(child: Divider()),
              ],
            ),
          ),
          _buildDropdown(
            "Target Event",
            Icons.event_outlined,
            _targetEventId,
            events.map((e) => DropdownMenuItem<String?>(value: e.id.toString(), child: Text(e.title.toString()))).toList(),
            (val) => setState(() {
              _targetEventId = val;
              if (val != null) _targetClassId = null;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, IconData icon, String? value, List<DropdownMenuItem<String?>> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String?>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: apexPrimary, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: [
        DropdownMenuItem<String?>(value: null, child: Text("Select $label...")),
        ...items,
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TextFormField(
        maxLines: 6,
        onSaved: (val) => _message = val!,
        validator: (val) => val == null || val.isEmpty ? "Please write a message" : null,
        decoration: InputDecoration(
          hintText: "Type your announcement here...",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _isSending ? null : _handleSend,
        style: ElevatedButton.styleFrom(
          backgroundColor: apexPrimary,
          foregroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        icon: _isSending 
          ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Theme.of(context).cardColor, strokeWidth: 2))
          : const Icon(Icons.send_rounded),
        label: Text(
          _isSending ? "Sending..." : "Broadcast Announcement",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _handleSend() async {
    if (_formKey.currentState!.validate()) {
      if (_targetClassId == null && _targetEventId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a target class or event"), backgroundColor: Colors.orange),
        );
        return;
      }

      _formKey.currentState!.save();
      setState(() => _isSending = true);
      
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Announcement broadcasted successfully!"), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    }
  }
}

