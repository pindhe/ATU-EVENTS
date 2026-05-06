import 'package:flutter/material.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class StudentNotificationsScreen extends StatelessWidget {
  const StudentNotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: apexBg,
      appBar: AppBar(
        backgroundColor: apexBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: apexText),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Apex Events',
          style: TextStyle(color: apexText, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: apexText),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Notifications', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: apexText)),
                        const SizedBox(height: 4),
                        Text('Manage your event alerts and requests', style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.2)),
                      ],
                    ),
                  ),
                  Text('Mark all as\nread', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, color: apexPrimary, fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            // Event Reminders
            _buildSectionTitle(Icons.calendar_today, 'EVENT REMINDERS'),
            _buildEventReminderCard(),

            // Networking Requests
            _buildSectionTitle(Icons.people_outline, 'NETWORKING REQUESTS'),
            _buildNetworkingCard('David Chen', 'CTO at InnovateX', '"I\'d love to connect and discuss your recent presentation on sustainable logistics."', 'https://images.unsplash.com/photo-1560250097-0b93528c311a?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80', false),
            _buildNetworkingCard('Sarah Jenkins', 'Director, Prime Logistics', '"Referred by your colleague. Interested in your VIP event management services."', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80', true),

            // App Updates
            _buildSectionTitle(Icons.phone_android, 'APP UPDATES'),
            _buildAppUpdateCard(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
      child: Row(
        children: [
          Icon(icon, size: 16, color: apexText),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: apexText, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildEventReminderCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&auto=format&fit=crop&w=150&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Global Tech\nSummit 2024', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: apexText, height: 1.2)),
                      const SizedBox(height: 8),
                      Text('Your primary session \'The Future of AI\' begins at 10:00 AM in Hall A. Don\'t forget your digital badge.', style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.5)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Starting\nin 2h', textAlign: TextAlign.right, style: TextStyle(fontSize: 11, color: apexPrimary, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: apexPrimary, shape: BoxShape.circle)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.confirmation_number_outlined, size: 16, color: Colors.white),
                label: const Text('View Ticket', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: apexPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkingCard(String name, String role, String message, String imageUrl, bool isUnread) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: apexText)),
                      Text(role, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                    ],
                  ),
                ),
                if (isUnread) Container(width: 6, height: 6, decoration: const BoxDecoration(color: apexPrimary, shape: BoxShape.circle)),
              ],
            ),
            const SizedBox(height: 12),
            Text(message, style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[700], height: 1.5)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: apexPrimary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: apexText,
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppUpdateCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(color: apexPrimary, shape: BoxShape.circle),
              child: const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Apex Events v2.4 Now\nAvailable', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: apexText, height: 1.2)),
                  const SizedBox(height: 8),
                  Text(
                    'We\'ve introduced real-time floor mapping and enhanced messaging for seamless event navigation. Update your app to access the latest networking tools.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  const Text('Learn more about the update', style: TextStyle(fontSize: 11, color: apexPrimary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
