import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/event.dart';
import '../user/checkout_screen.dart';
import 'payment_screen.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: apexBg,
      appBar: AppBar(
        backgroundColor: apexBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: apexText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Apex Events',
          style: TextStyle(color: apexText, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.bookmark_border, color: apexText), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none, color: apexText), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Image with Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: event.imageUrl != null && event.imageUrl!.startsWith('http')
                        ? NetworkImage(event.imageUrl!)
                        : const NetworkImage('https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80'),
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: event.isPublished ? Colors.green : Colors.orange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              event.isPublished ? 'PUBLISHED' : 'DRAFT',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              DateFormat('MMM dd, yyyy').format(event.startTime),
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        event.title,
                        style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, height: 1.1),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // About the Event
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('About the Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText)),
                    const SizedBox(height: 12),
                    Text(
                      event.description,
                      style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.category_outlined, size: 16, color: apexPrimary),
                        const SizedBox(width: 8),
                        Text('Category: ${event.categoryName ?? 'General'}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        const Spacer(),
                        const Icon(Icons.person_outline, size: 16, color: apexPrimary),
                        const SizedBox(width: 8),
                        Text('Organized by: ${event.createdByUsername ?? 'Admin'}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Venue Information
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Venue Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: apexText)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: apexPrimary, size: 16),
                        const SizedBox(width: 6),
                        Text(event.location, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1524666041070-9d87656c25bb?auto=format&fit=crop&w=800&q=80'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.location_on, color: apexPrimary, size: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.directions, size: 16),
                        label: const Text('Get Directions'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: apexText,
                          side: BorderSide(color: Colors.grey[300]!),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: (event.price == null || event.price == 0) 
        ? null 
        : Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1115),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('REMAINING TICKETS', style: TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
            const SizedBox(height: 4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text('${(event.maxParticipants ?? 0) - event.currentParticipants}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Text('out of ${event.maxParticipants ?? 0}', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: (event.maxParticipants != null && event.maxParticipants! > 0) ? event.currentParticipants / event.maxParticipants! : 0,
                backgroundColor: const Color(0xFF2A2D35),
                valueColor: const AlwaysStoppedAnimation<Color>(apexPrimary),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Selling fast! Book yours now.', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(event: event)));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: apexPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Get Tickets', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakerCard(String name, String role, String imageUrl) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
          colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            Text(role, style: const TextStyle(color: apexPrimary, fontSize: 9, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(String time, String title, String subtitle, bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isExpanded ? apexPrimary.withOpacity(0.3) : Colors.transparent),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(8)),
                  child: Text(time, textAlign: TextAlign.center, style: const TextStyle(color: apexPrimary, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: apexText)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
            if (isExpanded) ...[
              const SizedBox(height: 16),
              Text(
                'An in-depth exploration of the next generation of transformer models and their practical applications in consumer robotics.',
                style: TextStyle(color: Colors.grey[700], fontSize: 12, height: 1.5),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFE0E7FF), borderRadius: BorderRadius.circular(12)),
                    child: const Text('Keynote', style: TextStyle(color: apexPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFF3E8FF), borderRadius: BorderRadius.circular(12)),
                    child: const Text('High Priority', style: TextStyle(color: Color(0xFF9333EA), fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }
}

