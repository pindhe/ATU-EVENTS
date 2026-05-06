import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/event_provider.dart';
import '../../models/event.dart';
import '../common/event_detail_screen.dart';
import 'student_notifications_screen.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class StudentEventsScreen extends StatefulWidget {
  const StudentEventsScreen({Key? key}) : super(key: key);

  @override
  _StudentEventsScreenState createState() => _StudentEventsScreenState();
}

class _StudentEventsScreenState extends State<StudentEventsScreen> {
  String _selectedCategory = 'All Events';
  final List<String> _categories = ['All Events', 'Tech', 'Finance', 'Arts'];

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final visibleEvents = eventProvider.getVisibleEvents('c1');
    
    // Separate into featured and upcoming (mocking this behavior)
    final featuredEvents = visibleEvents.isNotEmpty ? [visibleEvents.first] : [];
    final upcomingEvents = visibleEvents.length > 1 ? visibleEvents.sublist(1) : [];

    return Scaffold(
      backgroundColor: apexBg,
      appBar: AppBar(
        backgroundColor: apexBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: apexText),
          onPressed: () {},
        ),
        title: const Text(
          'Apex Events',
          style: TextStyle(color: apexText, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: apexText),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const StudentNotificationsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search events, venues, or hosts...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            
            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? apexPrimary : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? apexPrimary : Colors.grey[300]!),
                        ),
                        child: Text(
                          cat,
                          style: TextStyle(
                            color: isSelected ? Colors.white : apexText,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Featured Events Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Featured Events', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: apexText)),
                  Text('View All', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: apexPrimary)),
                ],
              ),
            ),
            
            // Featured Card
            if (featuredEvents.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: featuredEvents.first))),
                  child: Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: apexText,
                      image: const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(color: apexPrimary, borderRadius: BorderRadius.circular(20)),
                              child: const Text('TRENDING', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const Spacer(),
                          const Row(
                            children: [
                              Icon(Icons.calendar_today, color: Colors.white70, size: 14),
                              SizedBox(width: 6),
                              Text('OCT 24, 2024', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            featuredEvents.first.title,
                            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_on_outlined, color: Colors.white70, size: 16),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  featuredEvents.first.location,
                                  style: const TextStyle(color: Colors.white70, fontSize: 13),
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
                ),
              ),

            // Upcoming Near You Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Expanded(
                    child: Text('Upcoming Near\nYou', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: apexText, height: 1.2)),
                  ),
                  Row(
                    children: [
                      Text('Filter by City', style: TextStyle(fontSize: 13, color: apexPrimary, fontWeight: FontWeight.w500)),
                      const Icon(Icons.keyboard_arrow_down, color: apexPrimary, size: 16),
                    ],
                  ),
                ],
              ),
            ),

            // Upcoming List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: upcomingEvents.length,
              itemBuilder: (context, index) {
                final event = upcomingEvents[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Image Placeholder
                        Container(
                          height: 140,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            image: DecorationImage(
                              image: NetworkImage('https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      event.title,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(8)),
                                    child: const Text('LIMITED SEATS', style: TextStyle(color: apexPrimary, fontSize: 9, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                event.description,
                                style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                                  const SizedBox(width: 4),
                                  Text('Sep 30', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                  const SizedBox(width: 16),
                                  Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[500]),
                                  const SizedBox(width: 4),
                                  Text(event.location, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  const Icon(Icons.person_outline, size: 14, color: apexText),
                                  const SizedBox(width: 4),
                                  const Text('200+ Attending', style: TextStyle(fontSize: 12, color: apexText, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
