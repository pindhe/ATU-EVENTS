import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).currentUser;
    final String initials = (user?.firstName != null && user!.firstName!.isNotEmpty && user.lastName != null && user.lastName!.isNotEmpty)
        ? "${user.firstName![0]}${user.lastName![0]}".toUpperCase() 
        : "AD";

    return Scaffold(
      backgroundColor: apexBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildProfileHeader(initials, user),
            const SizedBox(height: 32),
            _buildActionSection(context),
            const SizedBox(height: 24),
            _buildSystemStatsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String initials, dynamic user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [apexPrimary, Color(0xFF434190)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: apexPrimary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Text(initials, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(height: 20),
          Text("${user?.firstName ?? 'Admin'} ${user?.lastName ?? ''}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text(user?.role?.toUpperCase() ?? 'ADMINISTRATOR', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.email_outlined, color: Colors.white70, size: 14),
              const SizedBox(width: 8),
              Text(user?.email ?? 'admin@atu.edu', style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Account Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText)),
        const SizedBox(height: 16),
        _buildMenuTile(Icons.person_outline, "Edit Information", "Update your name and email", () {}),
        _buildMenuTile(Icons.lock_outline, "Security", "Change your password", () {}),
        _buildMenuTile(Icons.notifications_outlined, "Notification Settings", "Manage system alerts", () {}),
      ],
    );
  }

  Widget _buildSystemStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("System Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: apexText)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard("Total Events", "24", Icons.event, Colors.blue)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard("Total Users", "1.2k", Icons.people, Colors.green)),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuTile(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: apexPrimary.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: apexPrimary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: apexText)),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
