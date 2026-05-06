import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';

class TeacherStudentsScreen extends StatefulWidget {
  const TeacherStudentsScreen({Key? key}) : super(key: key);

  @override
  _TeacherStudentsScreenState createState() => _TeacherStudentsScreenState();
}

class _TeacherStudentsScreenState extends State<TeacherStudentsScreen> {
  String _searchQuery = '';
  String? _selectedClassId;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final classProvider = Provider.of<ClassProvider>(context);
    final teacherId = authProvider.currentUser?.email ?? ''; // Using email as ID for mock
    
    final myClasses = classProvider.getClassesForTeacher(teacherId);
    final allStudents = classProvider.getStudentsForTeacher(teacherId);

    final filteredStudents = allStudents.where((s) {
      final matchesSearch = (s.firstName?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase()) || 
                            (s.lastName?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase());
      
      if (_selectedClassId != null) {
        final studentsInClass = classProvider.getStudentsInClass(_selectedClassId!);
        return matchesSearch && studentsInClass.any((sc) => sc.id == s.id);
      }
      
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Students'), backgroundColor: Colors.teal),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Students',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonFormField<String?>(
              value: _selectedClassId,
              decoration: const InputDecoration(labelText: 'Filter by Class', border: OutlineInputBorder()),
              items: [
                const DropdownMenuItem(value: null, child: Text('All Classes')),
                ...myClasses.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
              ],
              onChanged: (val) => setState(() => _selectedClassId = val),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredStudents.isEmpty
                ? const Center(child: Text('No students found.'))
                : ListView.builder(
                    itemCount: filteredStudents.length,
                    itemBuilder: (ctx, index) {
                      final student = filteredStudents[index];
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text('${student.firstName} ${student.lastName}'),
                        subtitle: Text(student.email),
                        trailing: const Icon(Icons.chevron_right),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
