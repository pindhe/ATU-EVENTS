import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';
import 'student_events_screen.dart';
import 'student_notifications_screen.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);
const Color apexInactive = Color(0xFF8B95A5);

class UserDashboard extends StatefulWidget {
  const UserDashboard({Key? key}) : super(key: key);

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const StudentEventsScreen(),
    const Center(child: Text('Search Screen Placeholder')),
    const Center(child: Text('Saved Events Placeholder')),
    const Center(child: Text('Profile Screen Placeholder')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: apexBg,
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: apexPrimary,
          unselectedItemColor: apexInactive,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          elevation: 0,
          items: [
            _buildNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
            _buildNavItem(Icons.search_outlined, Icons.search, 'Search', 1),
            _buildNavItem(Icons.bookmark_outline, Icons.bookmark, 'Saved', 2),
            _buildNavItem(Icons.person_outline, Icons.person, 'Profile', 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData inactiveIcon, IconData activeIcon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: isSelected
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: apexPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(activeIcon, color: Colors.white, size: 20),
            )
          : Icon(inactiveIcon, size: 24),
      label: isSelected ? '' : label,
    );
  }

  void _logout() {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }
}
