import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/message_provider.dart';
import '../auth/login_screen.dart';
import 'manage_users_screen.dart';
import 'manage_events_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_settings_screen.dart';
import 'admin_analytics_screen.dart';
import 'admin_notifications_screen.dart';
import 'admin_messages_screen.dart';
import 'manage_faculties_screen.dart';
import 'manage_classes_screen.dart';
import 'manage_categories_screen.dart';
import '../teacher/event_form_screen.dart';
import 'security_logs_screen.dart';

// UI Constants matching Apex Events Tailwind config
const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);
const Color surfaceContainerLow = Color(0xFFEFF4FF);
const Color outlineVariant = Color(0xFFC6C6CD);

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminHomeScreen(),
    const ManageEventsScreen(),
    const ManageUsersScreen(),
    const AdminProfileScreen(),
    const ManageFacultiesScreen(),
    const ManageClassesScreen(),
    const ManageCategoriesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final adminName = authProvider.currentUser?.firstName ?? 'Admin';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF213145) : apexBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF131B2E) : Colors.white,
        title: Text('Apex $adminName', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : apexText),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: apexPrimary.withOpacity(0.1),
              child: Text(adminName[0].toUpperCase(), style: const TextStyle(color: apexPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
      drawer: _buildCategorizedDrawer(context, isDark),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          backgroundColor: isDark ? const Color(0xFF131B2E) : Colors.white,
          indicatorColor: apexPrimary.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard, color: apexPrimary), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), selectedIcon: Icon(Icons.confirmation_number, color: apexPrimary), label: 'Events'),
            NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people, color: apexPrimary), label: 'Users'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person, color: apexPrimary), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorizedDrawer(BuildContext context, bool isDark) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Drawer(
      backgroundColor: isDark ? const Color(0xFF131B2E) : Colors.white,
      child: Column(
        children: [
          _buildDrawerHeader(isDark, authProvider),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildDrawerSection('CORE MANAGEMENT'),
                _buildDrawerTile(Icons.dashboard_outlined, 'Home Dashboard', () => setState(() => _selectedIndex = 0), isDark),
                _buildDrawerTile(Icons.event_outlined, 'Events Hub', () => setState(() => _selectedIndex = 1), isDark),
                _buildDrawerTile(Icons.people_outline, 'User Directory', () => setState(() => _selectedIndex = 2), isDark),
                _buildDrawerTile(Icons.account_balance_outlined, 'Faculties', () => setState(() => _selectedIndex = 4), isDark),
                _buildDrawerTile(Icons.class_outlined, 'Classes', () => setState(() => _selectedIndex = 5), isDark),
                _buildDrawerTile(Icons.category_outlined, 'Categories', () => setState(() => _selectedIndex = 6), isDark),
                
                const Divider(height: 32),
                _buildDrawerSection('TOOLS & REPORTS'),
                _buildDrawerTile(Icons.analytics_outlined, 'System Analytics', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAnalyticsScreen())), isDark),
                _buildDrawerTile(Icons.campaign_outlined, 'Broadcast Center', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminNotificationsScreen())), isDark),
                _buildDrawerTile(Icons.message_outlined, 'Messages', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMessagesScreen())), isDark),
                
                const Divider(height: 32),
                _buildDrawerSection('SYSTEM'),
                _buildDrawerTile(Icons.settings_outlined, 'Preferences', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminSettingsScreen())), isDark),
                _buildDrawerTile(Icons.security_outlined, 'Security Logs', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityLogsScreen())), isDark),
                
                const Divider(height: 32),
                _buildDrawerTile(Icons.logout, 'Sign Out', () {
                  authProvider.logout();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                }, isDark, color: Colors.redAccent),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(bool isDark, AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
      color: isDark ? const Color(0xFF213145) : apexPrimary.withOpacity(0.05),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: apexPrimary,
            child: Text(auth.currentUser?.firstName?[0] ?? 'A', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(auth.currentUser?.firstName ?? 'Admin', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(auth.currentUser?.role ?? 'Super Admin', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerSection(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 0, 8),
      child: Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2)),
    );
  }

  Widget _buildDrawerTile(IconData icon, String title, VoidCallback onTap, bool isDark, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? (isDark ? Colors.white70 : apexText), size: 20),
      title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      dense: true,
    );
  }
}

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final adminName = authProvider.currentUser?.firstName ?? 'Admin';
    final totalEvents = eventProvider.allEvents.length;
    final totalUsers = authProvider.registeredUsers.length;

    final isDark = themeProvider.isDarkMode;
    final textColor = isDark ? Colors.white : apexText;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Greeting Hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark 
                    ? [apexPrimary.withOpacity(0.2), const Color(0xFF131B2E)]
                    : [apexPrimary, const Color(0xFF434190)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: apexPrimary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Admin Portal', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
                const SizedBox(height: 16),
                Text('Hello, $adminName 👋', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
                const SizedBox(height: 8),
                Text('You have full control over the platform today. Monitor events, manage users, and track analytics.', 
                  style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8), height: 1.5)),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          // Section 2: Summary Stats
          _buildHomeSection(
            'PLATFORM METRICS',
            Row(
              children: [
                Expanded(child: _buildStatCard('Live Events', totalEvents.toString(), Icons.event, Colors.blue, isDark)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard('Active Users', totalUsers.toString(), Icons.people, Colors.green, isDark)),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          // Section 3: Performance Insights
          _buildHomeSection(
            'PERFORMANCE INSIGHTS',
            _buildLargeCard('System Analytics', 'Generate detailed engagement reports', Icons.analytics_outlined, apexPrimary, isDark, 
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminAnalyticsScreen()))),
          ),
          
          const SizedBox(height: 32),
          // Section 4: Quick Actions
          _buildHomeSection(
            'QUICK SHORTCUTS',
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickAction(context, 'New Event', Icons.add_box_outlined, const EventFormScreen()),
                _buildQuickAction(context, 'Broadcast', Icons.campaign_outlined, const AdminNotificationsScreen()),
                _buildQuickAction(context, 'Messages', Icons.message_outlined, const AdminMessagesScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 16, decoration: BoxDecoration(color: apexPrimary, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
          ],
        ),
        const SizedBox(height: 16),
        content,
      ],
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131B2E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 16),
          Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildLargeCard(String title, String subtitle, IconData icon, Color color, bool isDark, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.2), shape: BoxShape.circle),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),
                  Text(subtitle, style: TextStyle(color: color.withOpacity(0.7), fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, String label, IconData icon, Widget screen) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: apexPrimary),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
