import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);

class TeacherSettingsScreen extends StatelessWidget {
  const TeacherSettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel("Preferences"),
                  const SizedBox(height: 16),
                  _buildSettingsCard(context, [
                    _buildSwitchTile(
                      context,
                      "Dark Mode",
                      "Enhance visual comfort at night",
                      Icons.dark_mode_outlined,
                      themeProvider.isDarkMode,
                      (val) => themeProvider.toggleTheme(),
                    ),
                  ]),
                  const SizedBox(height: 32),
                  _buildSectionLabel("Account & Security"),
                  const SizedBox(height: 16),
                  _buildSettingsCard(context, [
                    _buildActionTile(context, "Change Password", "Secure your account access", Icons.lock_outline),
                    const Divider(indent: 56),
                    _buildActionTile(context, "Two-Factor Auth", "Add an extra layer of security", Icons.security_outlined),
                    const Divider(indent: 56),
                    _buildActionTile(context, "Privacy Settings", "Control who can see your profile", Icons.privacy_tip_outlined),
                  ]),
                  const SizedBox(height: 32),
                  _buildSectionLabel("Support"),
                  const SizedBox(height: 16),
                  _buildSettingsCard(context, [
                    _buildActionTile(context, "Help Center", "Find answers to common questions", Icons.help_outline),
                    const Divider(indent: 56),
                    _buildActionTile(context, "About ATU Events", "Version 2.4.0 (Stable)", Icons.info_outline),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("App Settings", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87, fontWeight: FontWeight.bold, fontSize: 24)),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 0.5));
  }

  Widget _buildSettingsCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile(BuildContext context, String title, String subtitle, IconData icon, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: apexPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: apexPrimary, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: apexPrimary,
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, String title, String subtitle, IconData icon) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.grey[600], size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
    );
  }
}

