import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import '../../models/event.dart';
import '../user/checkout_screen.dart';
import 'payment_screen.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textTheme.bodyLarge?.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Apex Events',
          style: TextStyle(color: theme.textTheme.bodyLarge?.color, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.bookmark_border, color: theme.textTheme.bodyLarge?.color), onPressed: () {}),
          IconButton(icon: Icon(Icons.notifications_none, color: theme.textTheme.bodyLarge?.color), onPressed: () {}),
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
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _buildHeaderImage(),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                          ),
                        ),
                      ),
                      Padding(
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
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('About the Event', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
                    const SizedBox(height: 12),
                    Text(
                      event.description,
                      style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[700], fontSize: 13, height: 1.6),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.category_outlined, size: 16, color: Color(0xFF5A67D8)),
                        const SizedBox(width: 8),
                        Text('Category: ${event.categoryName ?? 'General'}', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        const Spacer(),
                        const Icon(Icons.person_outline, size: 16, color: Color(0xFF5A67D8)),
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
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Venue Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color)),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Color(0xFF5A67D8), size: 16),
                        const SizedBox(width: 6),
                        Text(event.location, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
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
                          child: const Icon(Icons.location_on, color: Color(0xFF5A67D8), size: 24),
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
                          foregroundColor: theme.textTheme.bodyLarge?.color,
                          side: BorderSide(color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!),
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
        color: theme.scaffoldBackgroundColor,
        padding: const EdgeInsets.all(20),
        child: Container(
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
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF5A67D8)),
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
                      backgroundColor: const Color(0xFF5A67D8),
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
      ),
    );
  }

  Widget _buildHeaderImage() {
    final String? url = event.imageUrl;
    if (url == null || url.isEmpty) {
      return Image.network(
        'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80',
        fit: BoxFit.cover,
      );
    }

    if (url.startsWith('http') || url.startsWith('blob:')) {
      return Image.network(url, fit: BoxFit.cover, errorBuilder: (c, e, s) => _placeholderImage());
    } else if (kIsWeb) {
      return Image.network(url, fit: BoxFit.cover, errorBuilder: (c, e, s) => _placeholderImage());
    } else {
      return Image.file(File(url), fit: BoxFit.cover, errorBuilder: (c, e, s) => _placeholderImage());
    }
  }

  Widget _placeholderImage() {
    return Image.network(
      'https://images.unsplash.com/photo-1540575467063-178a50c2df87?auto=format&fit=crop&w=800&q=80',
      fit: BoxFit.cover,
    );
  }
}
