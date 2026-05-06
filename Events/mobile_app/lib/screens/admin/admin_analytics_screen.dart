import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class AdminAnalyticsScreen extends StatelessWidget {
  const AdminAnalyticsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);

    final totalUsers = authProvider.registeredUsers.length;
    final totalEvents = eventProvider.allEvents.length;
    final studentsCount = authProvider.registeredUsers.where((u) => u.role == 'normal_user').length;
    final teachersCount = authProvider.registeredUsers.where((u) => u.role == 'teacher').length;

    return Scaffold(
      backgroundColor: apexBg,
      appBar: AppBar(
        title: const Text('Analytics & Insight', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: apexPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Generating report...')));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Overview Statistics'),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              children: [
                _buildStatCard('Total Users', totalUsers.toString(), Icons.people_outline, Colors.blue),
                _buildStatCard('Active Events', totalEvents.toString(), Icons.event_available_outlined, Colors.green),
                _buildStatCard('Total Reach', '4.2k', Icons.trending_up_outlined, Colors.orange),
                _buildStatCard('Engagement', '86%', Icons.auto_graph_outlined, Colors.purple),
              ],
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Role Distribution'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRoleIndicator('Students', studentsCount, totalUsers, Colors.blue),
                  _buildRoleIndicator('Teachers', teachersCount, totalUsers, Colors.teal),
                  _buildRoleIndicator('Admins', totalUsers - studentsCount - teachersCount, totalUsers, apexPrimary),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionHeader('Popular Categories'),
            const SizedBox(height: 16),
            _buildCategoryRank('Technology', 0.85, Colors.blue),
            _buildCategoryRank('Academics', 0.62, Colors.green),
            _buildCategoryRank('Social', 0.45, Colors.orange),
            _buildCategoryRank('Sports', 0.38, Colors.red),
            const SizedBox(height: 32),
            _buildSectionHeader('Recent System Activity'),
            const SizedBox(height: 16),
            _buildActivityItem('User Registration', 'Student ATU-2026-003 was created', '10 mins ago', Icons.person_add_outlined, Colors.blue),
            _buildActivityItem('Event Published', 'Annual Symposium is now live', '2 hours ago', Icons.campaign_outlined, Colors.green),
            _buildActivityItem('Security Alert', 'Login detected from new device', '5 hours ago', Icons.security_outlined, Colors.orange),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText));
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: apexText)),
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleIndicator(String label, int count, int total, Color color) {
    final percent = total > 0 ? count / total : 0.0;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: percent,
                strokeWidth: 6,
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text('${(percent * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w600)),
        Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }

  Widget _buildCategoryRank(String label, double percent, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: apexText, fontSize: 13)),
              Text('${(percent * 100).toInt()}%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 8,
              backgroundColor: color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String title, String desc, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: apexText, fontSize: 14)),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          Text(time, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
        ],
      ),
    );
  }
}
