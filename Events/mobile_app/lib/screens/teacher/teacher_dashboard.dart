import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/login_screen.dart';
import 'teacher_students_screen.dart';
import 'teacher_announcements_screen.dart';
import 'teacher_profile_screen.dart';
import 'teacher_settings_screen.dart';
import 'event_form_screen.dart';
import '../common/event_list_item.dart';
import '../common/event_detail_screen.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final teacherId = authProvider.currentUser?.email ?? ''; // Mock ID
    final teacherUsername = authProvider.currentUser?.username ?? '';
    
    final myEvents = eventProvider.getEventsByTeacher(teacherUsername);
    final upcomingEvents = myEvents.where((e) => e.startTime.isAfter(DateTime.now())).toList();
    final myStudents = classProvider.getStudentsForTeacher(teacherId);

    return Scaffold(
      backgroundColor: apexBg,
      appBar: AppBar(
        title: const Text('Teacher Dashboard', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: apexPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
            },
          )
        ],
      ),
      drawer: _buildDrawer(context, authProvider),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${authProvider.currentUser?.firstName ?? 'Teacher'}!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildStatCard('Total Events', myEvents.length.toString(), Icons.event, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Upcoming', upcomingEvents.length.toString(), Icons.schedule, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _buildStatCard('Students', myStudents.length.toString(), Icons.people, Colors.green)),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Quick Access', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildQuickAction(context, Icons.add_circle, 'Create New Event', const EventFormScreen(), apexPrimary),
            _buildQuickAction(context, Icons.people, 'My Students', const TeacherStudentsScreen(), Colors.indigo),
            _buildQuickAction(context, Icons.campaign, 'Send Announcement', const TeacherAnnouncementsScreen(), Colors.purple),
            const SizedBox(height: 32),
            const Text('My Recent Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (myEvents.isEmpty)
              const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No events created yet.')))
            else
              ...myEvents.take(3).map((e) => EventListItem(
                event: e,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: e))),
              )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventFormScreen())),
        backgroundColor: apexPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String title, Widget screen, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider authProvider) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: apexPrimary),
            accountName: Text(authProvider.currentUser?.username ?? 'Teacher'),
            accountEmail: Text(authProvider.currentUser?.email ?? ''),
            currentAccountPicture: const CircleAvatar(backgroundColor: Colors.white, child: Icon(Icons.person, color: apexPrimary)),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('My Events'),
            onTap: () {
              Navigator.pop(context);
              // Already on dashboard, could filter dashboard to only show list
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Students'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherStudentsScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.campaign),
            title: const Text('Announcements'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherAnnouncementsScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherProfileScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TeacherSettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
