import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({Key? key}) : super(key: key);

  @override
  _AdminSettingsScreenState createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _maintenanceMode = false;
  bool _registrationOpen = true;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: apexBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 32),
            _buildSectionTitle("Display & Appearance"),
            const SizedBox(height: 16),
            _buildSettingCard(
              Icons.dark_mode_outlined,
              "Dark Mode",
              "Toggle between light and dark theme",
              Switch(
                value: themeProvider.isDarkMode,
                onChanged: (val) => themeProvider.toggleTheme(),
                activeColor: apexPrimary,
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle("System Controls"),
            const SizedBox(height: 16),
            _buildSettingCard(
              Icons.engineering_outlined,
              "Maintenance Mode",
              "Disable access for non-admin users",
              Switch(
                value: _maintenanceMode,
                onChanged: (val) => setState(() => _maintenanceMode = val),
                activeColor: apexPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingCard(
              Icons.app_registration,
              "User Registration",
              "Allow new users to create accounts",
              Switch(
                value: _registrationOpen,
                onChanged: (val) => setState(() => _registrationOpen = val),
                activeColor: apexPrimary,
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle("Advanced Configuration"),
            const SizedBox(height: 16),
            _buildActionCard(Icons.storage_outlined, "Clear Cache", "Refresh temporary system data"),
            const SizedBox(height: 12),
            _buildActionCard(Icons.backup_outlined, "Manual Backup", "Save system state to local storage"),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: apexText),
              onPressed: () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Container(width: 4, height: 16, decoration: BoxDecoration(color: apexPrimary, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text("SYSTEM CONTROL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
          ],
        ),
        const SizedBox(height: 16),
        const Text("Settings", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: apexText)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: apexText.withOpacity(0.7)));
  }

  Widget _buildSettingCard(IconData icon, String title, String subtitle, Widget trailing) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: apexPrimary.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: apexPrimary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: apexText)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildActionCard(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
          child: Icon(icon, color: Colors.grey[700], size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: apexText)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: () {},
      ),
    );
  }
}
