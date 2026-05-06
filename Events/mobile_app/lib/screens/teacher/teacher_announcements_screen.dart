import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/event_provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    
    final teacherId = authProvider.currentUser?.email ?? '';
    final myClasses = classProvider.getClassesForTeacher(teacherId);
    final myEvents = eventProvider.getEventsByTeacher(authProvider.currentUser?.username ?? '');

    return Scaffold(
      appBar: AppBar(title: const Text('Send Announcement'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Target Audience', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                decoration: const InputDecoration(labelText: 'Select Class', border: OutlineInputBorder()),
                items: [
                  const DropdownMenuItem(value: null, child: Text('No Class Selected')),
                  ...myClasses.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
                ],
                onChanged: (val) => setState(() {
                  _targetClassId = val;
                  if (val != null) _targetEventId = null;
                }),
              ),
              const SizedBox(height: 16),
              const Center(child: Text('OR')),
              const SizedBox(height: 16),
              DropdownButtonFormField<String?>(
                decoration: const InputDecoration(labelText: 'Select Event', border: OutlineInputBorder()),
                items: [
                  const DropdownMenuItem(value: null, child: Text('No Event Selected')),
                  ...myEvents.map((e) => DropdownMenuItem(value: e.id, child: Text(e.title))),
                ],
                onChanged: (val) => setState(() {
                  _targetEventId = val;
                  if (val != null) _targetClassId = null;
                }),
              ),
              const SizedBox(height: 24),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Announcement Message',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (val) => val!.isEmpty ? 'Please enter a message' : null,
                onSaved: (val) => _message = val!,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.teal,
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Announcement sent successfully!')),
                    );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.send),
                label: const Text('Send to Students', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
