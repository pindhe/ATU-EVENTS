import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/event_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/event.dart';
import '../auth/login_screen.dart';
import 'teacher_students_screen.dart';
import 'teacher_announcements_screen.dart';
import 'teacher_profile_screen.dart';
import 'teacher_settings_screen.dart';
import 'event_form_screen.dart';
import '../common/event_list_item.dart';
import '../common/event_detail_screen.dart';

const Color apexPrimary = Color(0xFF5A67D8);

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({Key? key}) : super(key: key);

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    final teacherId = authProvider.currentUser?.email ?? '';
    final teacherUsername = authProvider.currentUser?.username ?? '';
    
    final myEvents = eventProvider.getEventsByTeacher(teacherUsername);
    final upcomingEvents = myEvents.where((e) => e.startTime.isAfter(DateTime.now())).toList();
    final myStudents = classProvider.getStudentsForTeacher(teacherId);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, authProvider, themeProvider),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(authProvider),
                  const SizedBox(height: 32),
                  _buildStatsGrid(myEvents.length, upcomingEvents.length, myStudents.length),
                  const SizedBox(height: 40),
                  _buildSectionHeader("Quick Actions"),
                  const SizedBox(height: 16),
                  _buildQuickActionsRow(context),
                  const SizedBox(height: 40),
                  _buildSectionHeader("My Recent Events"),
                  const SizedBox(height: 16),
                  _buildEventsList(context, myEvents),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context, authProvider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EventFormScreen())),
        backgroundColor: apexPrimary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Event', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AuthProvider auth, ThemeProvider theme) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      backgroundColor: apexPrimary,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        title: const Text("Teacher Portal", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: false,
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [apexPrimary, Color(0xFF434190)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(theme.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.white),
          onPressed: () => theme.toggleTheme(),
        ),
        IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            auth.logout();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildWelcomeSection(AuthProvider auth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back,",
          style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          "${auth.currentUser?.firstName ?? 'Teacher'}!",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(int total, int upcoming, int students) {
    return Row(
      children: [
        Expanded(child: _buildStatCard("Events", total.toString(), Icons.event_note, Colors.blue)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard("Upcoming", upcoming.toString(), Icons.timer_outlined, Colors.orange)),
        const SizedBox(width: 16),
        Expanded(child: _buildStatCard("Students", students.toString(), Icons.school_outlined, Colors.green)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
        TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(color: apexPrimary, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildQuickActionsRow(BuildContext context) {
    return Row(
      children: [
        _buildActionItem(context, Icons.add_task, "Add Event", const EventFormScreen(), apexPrimary),
        const SizedBox(width: 12),
        _buildActionItem(context, Icons.people_alt_outlined, "Students", const TeacherStudentsScreen(), Colors.indigo),
        const SizedBox(width: 12),
        _buildActionItem(context, Icons.campaign_outlined, "Broadcast", const TeacherAnnouncementsScreen(), Colors.purple),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label, Widget screen, Color color) {
    return Expanded(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventsList(BuildContext context, List<Event> events) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(Icons.event_busy, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text("No events created yet", style: TextStyle(color: Colors.grey[500])),
            ],
          ),
        ),
      );
    }
    return Column(
      children: events.take(3).map((e) => EventListItem(
        event: e as Event,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: e as Event))),
      )).toList().cast<Widget>(),
    );
  }

  Widget _buildDrawer(BuildContext context, AuthProvider auth) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Column(
        children: [
          _buildDrawerHeader(auth),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildDrawerItem(context, Icons.grid_view_rounded, "Dashboard", null, true),
                _buildDrawerItem(context, Icons.people_alt_rounded, "My Students", const TeacherStudentsScreen(), false),
                _buildDrawerItem(context, Icons.campaign_rounded, "Broadcast Center", const TeacherAnnouncementsScreen(), false),
                _buildDrawerItem(context, Icons.event_rounded, "Event Manager", null, false),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Divider(height: 1, color: Color(0xFFEDF2F7)),
                ),
                _buildDrawerItem(context, Icons.person_rounded, "Profile", const TeacherProfileScreen(), false),
                _buildDrawerItem(context, Icons.settings_suggest_rounded, "Settings", const TeacherSettingsScreen(), false),
                _buildDrawerItem(context, Icons.help_outline_rounded, "Support", null, false),
              ],
            ),
          ),
          _buildDrawerFooter(context, auth),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: const BoxDecoration(
        color: apexPrimary,
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: apexPrimary.withOpacity(0.1),
              child: Text(
                (auth.currentUser?.firstName?.isNotEmpty ?? false) 
                  ? auth.currentUser!.firstName![0] 
                  : (auth.currentUser?.username.isNotEmpty ?? false ? auth.currentUser!.username[0] : 'T'), 
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: apexPrimary)
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  auth.currentUser?.firstName ?? 'Teacher',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  auth.currentUser?.email ?? 'Faculty Member',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, Widget? screen, bool isSelected) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? apexPrimary.withOpacity(0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          if (screen != null) Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
        leading: Icon(icon, color: isSelected ? apexPrimary : textColor.withOpacity(0.6), size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? apexPrimary : textColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        dense: true,
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context, AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEDF2F7))),
      ),
      child: InkWell(
        onTap: () {
          auth.logout();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 16),
            const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

