import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/class_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class ManageClassesScreen extends StatelessWidget {
  const ManageClassesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final classes = classProvider.classes;

    return Scaffold(
      backgroundColor: apexBg,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(context, classProvider),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (context, index) {
                  final schoolClass = classes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      leading: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: apexPrimary.withOpacity(0.1), shape: BoxShape.circle),
                        child: const Icon(Icons.class_outlined, color: apexPrimary),
                      ),
                      title: Text(schoolClass.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Text('ID: ${schoolClass.id}', style: TextStyle(color: Colors.grey[600])),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit_outlined, color: apexPrimary),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, ClassProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 16, decoration: BoxDecoration(color: apexPrimary, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text("CLASSROOM MANAGEMENT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Classes", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: apexText)),
            IconButton(
              onPressed: () => _showAddDialog(context, provider),
              icon: const Icon(Icons.add, color: apexPrimary),
              style: IconButton.styleFrom(backgroundColor: apexPrimary.withOpacity(0.1), padding: const EdgeInsets.all(12)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text("Total Active Classes: ${provider.classes.length}", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  void _showAddDialog(BuildContext context, ClassProvider provider) {
    final controller = TextEditingController();
    String? selectedFacultyId;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add New Class'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedFacultyId,
                decoration: const InputDecoration(labelText: 'Select Faculty'),
                items: provider.faculties.map((f) => DropdownMenuItem(value: f.id, child: Text(f.name))).toList(),
                onChanged: (val) => setDialogState(() => selectedFacultyId = val),
              ),
              const SizedBox(height: 16),
              TextField(controller: controller, decoration: const InputDecoration(labelText: 'Class Name')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty && selectedFacultyId != null) {
                  provider.addClass(controller.text, selectedFacultyId!);
                  Navigator.pop(ctx);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
