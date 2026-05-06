import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/class_provider.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class ManageCategoriesScreen extends StatelessWidget {
  const ManageCategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final classProvider = Provider.of<ClassProvider>(context);
    final categories = classProvider.categories;

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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: apexPrimary.withOpacity(0.1), shape: BoxShape.circle),
                          child: const Icon(Icons.category_outlined, color: apexPrimary),
                        ),
                        const SizedBox(height: 12),
                        Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
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
            Text("CONTENT CLASSIFICATION", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Categories", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: apexText)),
            IconButton(
              onPressed: () => _showAddDialog(context, provider),
              icon: const Icon(Icons.add, color: apexPrimary),
              style: IconButton.styleFrom(backgroundColor: apexPrimary.withOpacity(0.1), padding: const EdgeInsets.all(12)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text("Event & Data Groups: ${provider.categories.length}", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  void _showAddDialog(BuildContext context, ClassProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add New Category'),
        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Category Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                provider.addCategory(controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
