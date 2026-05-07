import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildProfileHeader(context, user),
                  const SizedBox(height: 32),
                  _buildDepartmentCard(context),
                  const SizedBox(height: 32),
                  _buildInfoSection(context, user),
                  const SizedBox(height: 40),
                  _buildActionButtons(context),
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
      title: Text("My Profile", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87, fontWeight: FontWeight.bold, fontSize: 24)),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: apexPrimary, width: 2),
              ),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: apexPrimary.withOpacity(0.1),
                child: Text(
                  (user?.firstName?.isNotEmpty ?? false) ? user!.firstName![0] : (user?.username.isNotEmpty ?? false ? user!.username[0] : "T"),
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: apexPrimary),
                ),
              ),
            ),
            PositionBag(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: apexPrimary, shape: BoxShape.circle),
                child: Icon(Icons.camera_alt, color: Theme.of(context).cardColor, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "${user?.firstName ?? ''} ${user?.lastName ?? ''}".trim().isEmpty ? "Teacher Account" : "${user?.firstName} ${user?.lastName}",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87),
        ),
        const SizedBox(height: 4),
        Text(
          "Faculty Member • Apex University",
          style: TextStyle(fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, dynamic user) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          _buildInfoRow(context, Icons.alternate_email, "Username", user?.username ?? "N/A"),
          const Divider(height: 32),
          _buildInfoRow(context, Icons.email_outlined, "Email Address", user?.email ?? "N/A"),
          const Divider(height: 32),
          _buildInfoRow(context, Icons.verified_user_outlined, "Role", "Faculty / Teacher"),
          const Divider(height: 32),
          _buildInfoRow(context, Icons.calendar_today_outlined, "Joined", "September 2023"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: apexPrimary, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
          ],
        ),
      ],
    );
  }

  Widget _buildDepartmentCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: apexPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: apexPrimary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: apexPrimary, borderRadius: BorderRadius.circular(15)),
            child: Icon(Icons.account_balance_rounded, color: Theme.of(context).cardColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Department", style: TextStyle(fontSize: 12, color: apexPrimary, fontWeight: FontWeight.bold)),
                Text("Computer Science & Engineering", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: apexPrimary,
              foregroundColor: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text("Edit Profile Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {},
          child: const Text("Reset Password", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class PositionBag extends StatelessWidget {
  final double? top, bottom, left, right;
  final Widget child;
  const PositionBag({Key? key, this.top, this.bottom, this.left, this.right, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(top: top, bottom: bottom, left: left, right: right, child: child);
  }
}

