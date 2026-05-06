import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/log_provider.dart';
import '../../models/security_log.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class SecurityLogsScreen extends StatelessWidget {
  const SecurityLogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logProvider = Provider.of<LogProvider>(context);
    final logs = logProvider.logs;

    return Scaffold(
      backgroundColor: apexBg,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context),
            const SizedBox(height: 24),
            _buildFilterBar(),
            const SizedBox(height: 24),
            Expanded(
              child: logs.isEmpty 
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (ctx, index) {
                        final log = logs[index];
                        return _buildLogEntry(log);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.security_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No security logs found", style: TextStyle(color: Colors.grey[500])),
        ],
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
            Text("AUDIT TRAIL", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
          ],
        ),
        const SizedBox(height: 16),
        const Text("Security Logs", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: apexText)),
      ],
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip("All Logs", true),
          const SizedBox(width: 8),
          _buildFilterChip("High Severity", false),
          const SizedBox(width: 8),
          _buildFilterChip("Login Events", false),
          const SizedBox(width: 8),
          _buildFilterChip("Data Changes", false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? apexPrimary : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? apexPrimary : Colors.grey[200]!),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildLogEntry(SecurityLog log) {
    Color severityColor;
    switch (log.severity) {
      case 'high': severityColor = Colors.red; break;
      case 'medium': severityColor = Colors.orange; break;
      default: severityColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: severityColor.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(Icons.security_outlined, color: severityColor, size: 18),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(log.event, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: apexText)),
                    Text(DateFormat('MMM dd, HH:mm').format(log.time), style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text("User: ", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    Text(log.user, style: const TextStyle(color: apexPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(width: 12),
                    Text("IP: ", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    Text(log.ip, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
