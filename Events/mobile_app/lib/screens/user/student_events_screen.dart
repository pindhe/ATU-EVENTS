import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/event.dart';
import '../common/event_detail_screen.dart';
import 'student_notifications_screen.dart';

class StudentEventsScreen extends StatefulWidget {
  const StudentEventsScreen({Key? key}) : super(key: key);

  @override
  _StudentEventsScreenState createState() => _StudentEventsScreenState();
}

class _StudentEventsScreenState extends State<StudentEventsScreen> {
  String _selectedCategory = 'All Events';
  final List<String> _categories = ['All Events', 'Tech', 'Finance', 'Arts', 'Sports', 'Music'];
  final Color apexPrimary = const Color(0xFF5A67D8);

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final user = authProvider.currentUser;
    final List<Event> visibleEvents = eventProvider.getVisibleEvents(user?.classId);
    
    // Filter by category
    final List<Event> filteredEvents = _selectedCategory == 'All Events' 
        ? visibleEvents 
        : visibleEvents.where((e) => e.categoryName == _selectedCategory).toList();

    final List<Event> featuredEvents = filteredEvents.isNotEmpty ? [filteredEvents.first] : [];
    final List<Event> upcomingEvents = filteredEvents.length > 1 ? filteredEvents.sublist(1) : [];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, theme),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(theme),
                _buildCategories(theme),
                _buildFeaturedSection(context, theme, featuredEvents),
                _buildUpcomingSection(context, theme, upcomingEvents),
                const SizedBox(height: 100), // Bottom padding for navigation
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ThemeData theme) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Events',
            style: TextStyle(
              color: theme.textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            'Discover what\'s happening at Apex',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none_rounded, color: theme.textTheme.bodyLarge?.color, size: 28),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentNotificationsScreen()));
                },
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))
          ],
        ),
        child: TextField(
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: 'Search for events...',
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: apexPrimary, size: 22),
            suffixIcon: Icon(Icons.tune_rounded, color: Colors.grey[400], size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: _categories.map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? apexPrimary : theme.cardColor,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isSelected 
                    ? [BoxShadow(color: apexPrimary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
                    : null,
                ),
                child: Text(
                  cat,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[500],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context, ThemeData theme, List<Event> featured) {
    if (featured.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Featured Events',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: featured.length,
            itemBuilder: (context, index) {
              final event = featured[index];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    image: DecorationImage(
                      image: NetworkImage(event.imageUrl ?? 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                              child: const Text('TRENDING', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                              child: Icon(Icons.bookmark_border_rounded, color: apexPrimary, size: 18),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          event.title,
                          style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.1),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded, color: Colors.white70, size: 16),
                            const SizedBox(width: 6),
                            Text(event.location, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSection(BuildContext context, ThemeData theme, List<Event> upcoming) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 32, 20, 16),
          child: Text(
            'Upcoming Near You',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: upcoming.length,
          itemBuilder: (context, index) {
            final event = upcoming[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            event.imageUrl ?? 'https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=800&q=80',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.categoryName?.toUpperCase() ?? 'GENERAL',
                                style: TextStyle(color: apexPrimary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event.title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.calendar_month_rounded, size: 14, color: Colors.grey[500]),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Sep 30 • 06:00 PM',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on_rounded, size: 14, color: Colors.grey[500]),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      event.location,
                                      style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
