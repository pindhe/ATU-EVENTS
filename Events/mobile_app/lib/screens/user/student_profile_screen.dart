import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../auth/login_screen.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

  final Color apexPrimary = const Color(0xFF5A67D8);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final user = authProvider.currentUser;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final registeredCount = eventProvider.registeredEvents.length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, theme, user),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsRow(theme, registeredCount),
                  const SizedBox(height: 40),
                  _buildSectionTitle(theme, 'Account Settings'),
                  const SizedBox(height: 16),
                  _buildMenuCard(theme, [
                    _buildMenuItem(theme, Icons.person_outline_rounded, 'Personal Information', 'Name, Email, Phone'),
                    _buildMenuItem(theme, Icons.security_rounded, 'Security', 'Password, 2FA, Sessions'),
                    _buildMenuItem(theme, Icons.notifications_none_rounded, 'Notification Preferences', 'Email, Push, SMS'),
                  ]),
                  const SizedBox(height: 32),
                  _buildSectionTitle(theme, 'Preferences'),
                  const SizedBox(height: 16),
                  _buildMenuCard(theme, [
                    _buildMenuItem(theme, Icons.language_rounded, 'Language', 'English (US)'),
                    _buildMenuItem(theme, Icons.dark_mode_outlined, 'Dark Mode', 'System Default'),
                  ]),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        authProvider.logout();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                      },
                      icon: const Icon(Icons.logout_rounded, color: Colors.red),
                      label: const Text('Sign Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, dynamic user) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: apexPrimary,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [apexPrimary, apexPrimary.withOpacity(0.8)],
                ),
              ),
            ),
            // Abstract decorative circles
            Positioned(top: -50, right: -50, child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.05))),
            Positioned(bottom: -30, left: -20, child: CircleAvatar(radius: 60, backgroundColor: Colors.white.withOpacity(0.03))),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 42,
                    backgroundColor: apexPrimary,
                    child: Text(
                      (user?.username.isNotEmpty ?? false) ? user!.username[0].toUpperCase() : "S",
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.username ?? "Student Name",
                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  user?.email ?? "student@apex.edu",
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme, int eventsCount) {
    return Row(
      children: [
        _buildStatItem(theme, eventsCount.toString(), 'Events Joined'),
        const SizedBox(width: 16),
        _buildStatItem(theme, '04', 'Certificates'),
        const SizedBox(width: 16),
        _buildStatItem(theme, 'Level 3', 'User Status'),
      ],
    );
  }

  Widget _buildStatItem(ThemeData theme, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: apexPrimary)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color?.withOpacity(0.8)),
    );
  }

  Widget _buildMenuCard(ThemeData theme, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: items),
    );
  }

  Widget _buildMenuItem(ThemeData theme, IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: apexPrimary.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: apexPrimary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
      onTap: () {},
    );
  }
}
