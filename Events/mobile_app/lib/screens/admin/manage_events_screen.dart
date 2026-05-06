import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';
import '../common/event_detail_screen.dart';
import '../teacher/event_form_screen.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class ManageEventsScreen extends StatefulWidget {
  const ManageEventsScreen({Key? key}) : super(key: key);

  @override
  _ManageEventsScreenState createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  String _searchQuery = '';
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    List<Event> filteredEvents = eventProvider.allEvents.where((e) {
      final matchesSearch = e.title.toLowerCase().contains(_searchQuery.toLowerCase());
      if (_filter == 'Upcoming') return matchesSearch && e.startTime.isAfter(DateTime.now());
      if (_filter == 'Past') return matchesSearch && e.startTime.isBefore(DateTime.now());
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: apexBg,
      appBar: AppBar(
        title: const Text('Event Management', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: apexPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            color: apexPrimary,
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search events...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['All', 'Upcoming', 'Past'].map((f) {
                      final isSelected = _filter == f;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(f),
                          selected: isSelected,
                          onSelected: (selected) => setState(() => _filter = f),
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          labelStyle: TextStyle(color: isSelected ? apexPrimary : Colors.white, fontWeight: FontWeight.bold),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredEvents.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No events found', style: TextStyle(color: Colors.grey[600], fontSize: 18)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredEvents.length,
                    itemBuilder: (ctx, index) {
                      final event = filteredEvents[index];
                      return AdminEventCard(event: event);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: apexPrimary,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventFormScreen())),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Create Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class AdminEventCard extends StatelessWidget {
  final Event event;
  const AdminEventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final isUpcoming = event.startTime.isAfter(DateTime.now());

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: (isUpcoming ? Colors.green : Colors.blue).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(isUpcoming ? Icons.upcoming : Icons.history, color: isUpcoming ? Colors.green : Colors.blue),
            ),
            title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${DateFormat('MMM dd, yyyy • hh:mm a').format(event.startTime)}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildBadge(event.categoryName ?? 'General', Colors.purple),
                    const SizedBox(width: 8),
                    _buildBadge(event.isPublished ? 'Published' : 'Draft', event.isPublished ? Colors.green : Colors.orange),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _IconButton(
                  icon: Icons.visibility_outlined,
                  label: 'View',
                  color: Colors.blue,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
                ),
                _IconButton(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  color: Colors.teal,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventFormScreen(event: event))),
                ),
                _IconButton(
                  icon: Icons.delete_outline,
                  label: 'Delete',
                  color: Colors.red,
                  onTap: () => _showDeleteDialog(context, eventProvider),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  void _showDeleteDialog(BuildContext context, EventProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Event?'),
        content: Text('Are you sure you want to delete "${event.title}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              provider.deleteEvent(event.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event deleted successfully')));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}
