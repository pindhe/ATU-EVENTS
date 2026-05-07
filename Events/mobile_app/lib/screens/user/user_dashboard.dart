import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'student_events_screen.dart';
import 'student_notifications_screen.dart';
import 'student_my_events_screen.dart';
import 'student_search_screen.dart';
import 'student_profile_screen.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  final Color apexPrimary = const Color(0xFF5A67D8);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const StudentEventsScreen(),
    const StudentSearchScreen(),
    const StudentMyEventsScreen(),
    const StudentProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: _buildProfessionalDrawer(context, user),
      body: Stack(
        children: [
          _screens[_selectedIndex],
          // Custom Drawer Trigger
          Positioned(
            top: 50,
            left: 20,
            child: GestureDetector(
              onTap: () => _scaffoldKey.currentState?.openDrawer(),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.cardColor.withOpacity(0.9),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Icon(Icons.menu_rounded, color: theme.textTheme.bodyLarge?.color),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(0.95),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.grid_view_rounded, Icons.grid_view_rounded, "Home"),
                    _buildNavItem(1, Icons.search_rounded, Icons.search_rounded, "Search"),
                    _buildNavItem(2, Icons.bookmark_outline_rounded, Icons.bookmark_rounded, "Saved"),
                    _buildNavItem(3, Icons.person_outline_rounded, Icons.person_rounded, "Profile"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalDrawer(BuildContext context, dynamic user) {
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          _buildDrawerHeader(context, user),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                _buildDrawerItem(Icons.grid_view_rounded, "Events Dashboard", 0),
                _buildDrawerItem(Icons.bookmark_rounded, "My Registered Events", 2),
                _buildDrawerItem(Icons.notifications_rounded, "Notifications", null, screen: const StudentNotificationsScreen()),
                _buildDrawerItem(Icons.settings_rounded, "App Settings", 3), // Profile handles settings
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Divider(),
                ),
                _buildDrawerItem(Icons.help_outline_rounded, "Help & Support", null),
                _buildDrawerItem(Icons.info_outline_rounded, "About ATU Events", null),
              ],
            ),
          ),
          _buildDrawerFooter(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, dynamic user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
      decoration: BoxDecoration(
        color: apexPrimary,
        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: apexPrimary,
              child: Text(
                (user?.username.isNotEmpty ?? false) ? user!.username[0].toUpperCase() : "S",
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            user?.username ?? "Student",
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? "student@apex.edu",
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int? index, {Widget? screen}) {
    final isSelected = index != null && _selectedIndex == index;
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? apexPrimary.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pop(context);
          if (index != null) {
            setState(() => _selectedIndex = index);
          } else if (screen != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          }
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        dense: true,
      ),
    );
  }

  Widget _buildDrawerFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: InkWell(
        onTap: () {
          Provider.of<AuthProvider>(context, listen: false).logout();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 16),
            const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isSelected = _selectedIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? apexPrimary.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? apexPrimary : Colors.grey[500],
              size: 24,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: BoxDecoration(color: apexPrimary, shape: BoxShape.circle),
              ),
          ],
        ),
      ),
    );
  }
}
