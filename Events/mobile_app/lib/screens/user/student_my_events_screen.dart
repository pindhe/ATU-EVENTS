import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../common/event_list_item.dart';
import '../common/event_detail_screen.dart';

class StudentMyEventsScreen extends StatelessWidget {
  const StudentMyEventsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final registeredEvents = eventProvider.registeredEvents;

    final upcoming = registeredEvents.where((e) => e.startTime.isAfter(DateTime.now())).toList();
    final past = registeredEvents.where((e) => e.startTime.isBefore(DateTime.now())).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Events'),
          backgroundColor: Colors.indigo,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Attended'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventList(context, upcoming, 'You haven\'t registered for any upcoming events.'),
            _buildEventList(context, past, 'No past events found.'),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(BuildContext context, List events, String emptyMsg) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(emptyMsg, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (ctx, index) {
        return EventListItem(
          event: events[index],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EventDetailScreen(event: events[index])),
          ),
        );
      },
    );
  }
}
