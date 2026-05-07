import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';
import '../common/event_detail_screen.dart';
import '../common/event_list_item.dart';

class StudentSearchScreen extends StatefulWidget {
  const StudentSearchScreen({Key? key}) : super(key: key);

  @override
  _StudentSearchScreenState createState() => _StudentSearchScreenState();
}

class _StudentSearchScreenState extends State<StudentSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Color apexPrimary = const Color(0xFF5A67D8);

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final theme = Theme.of(context);
    
    // In a real app, you'd get the student's class ID from AuthProvider
    final allEvents = eventProvider.getVisibleEvents('c1');
    
    final filteredEvents = allEvents.where((event) {
      final query = _searchQuery.toLowerCase();
      return event.title.toLowerCase().contains(query) ||
             event.location.toLowerCase().contains(query) ||
             (event.categoryName?.toLowerCase().contains(query) ?? false);
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: apexPrimary.withOpacity(0.1)),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            autofocus: true,
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            decoration: InputDecoration(
              hintText: 'Search events...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded, color: apexPrimary, size: 20),
              suffixIcon: _searchQuery.isNotEmpty 
                ? IconButton(
                    icon: Icon(Icons.clear_rounded, color: Colors.grey[400], size: 18),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ),
      body: _searchQuery.isEmpty 
        ? _buildRecentSearches(theme)
        : _buildSearchResults(context, theme, filteredEvents),
    );
  }

  Widget _buildRecentSearches(ThemeData theme) {
    final List<String> popularCategories = ['Workshops', 'Seminars', 'Hackathons', 'Social', 'Sports'];
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Popular Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: popularCategories.map((cat) => ActionChip(
              label: Text(cat),
              backgroundColor: theme.cardColor,
              labelStyle: TextStyle(color: apexPrimary, fontWeight: FontWeight.w600, fontSize: 13),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: apexPrimary.withOpacity(0.1))),
              onPressed: () => setState(() {
                _searchQuery = cat;
                _searchController.text = cat;
              }),
            )).toList(),
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Icon(Icons.manage_search_rounded, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'Search for your next big event',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context, ThemeData theme, List<Event> results) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No events found for "$_searchQuery"',
              style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: results.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: EventListItem(
            event: results[index],
            onTap: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => EventDetailScreen(event: results[index]))
            ),
          ),
        );
      },
    );
  }
}
