import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../common/event_list_item.dart';
import '../common/event_detail_screen.dart';

class StudentMyEventsScreen extends StatelessWidget {
  const StudentMyEventsScreen({Key? key}) : super(key: key);

  final Color apexPrimary = const Color(0xFF5A67D8);

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    final registeredEvents = eventProvider.registeredEvents;
    final upcoming = registeredEvents.where((e) => e.startTime.isAfter(DateTime.now())).toList();
    final past = registeredEvents.where((e) => e.startTime.isBefore(DateTime.now())).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'My Events',
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          bottom: TabBar(
            labelColor: apexPrimary,
            unselectedLabelColor: Colors.grey[500],
            indicatorColor: apexPrimary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildEventList(context, theme, upcoming, 'You haven\'t registered for any upcoming events.', Icons.event_available_rounded),
            _buildEventList(context, theme, past, 'No past events found.', Icons.history_rounded),
          ],
        ),
      ),
    );
  }

  Widget _buildEventList(BuildContext context, ThemeData theme, List events, String emptyMsg, IconData emptyIcon) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: apexPrimary.withOpacity(0.05), shape: BoxShape.circle),
                child: Icon(emptyIcon, color: apexPrimary.withOpacity(0.3), size: 64),
              ),
              const SizedBox(height: 24),
              Text(
                'No Events Found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
              ),
              const SizedBox(height: 8),
              Text(
                emptyMsg,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      itemCount: events.length,
      itemBuilder: (ctx, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: EventListItem(
            event: events[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventDetailScreen(event: events[index])),
            ),
          ),
        );
      },
    );
  }
}
