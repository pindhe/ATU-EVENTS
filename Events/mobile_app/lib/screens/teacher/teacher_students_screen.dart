import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../../models/user.dart';

const Color apexPrimary = Color(0xFF5A67D8);

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
    final teacherId = authProvider.currentUser?.email ?? '';
    
    final myClasses = classProvider.getClassesForTeacher(teacherId);
    final allStudents = classProvider.getStudentsForTeacher(teacherId);

    final filteredStudents = allStudents.where((s) {
      final matchesSearch = (s.firstName?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase()) || 
                            (s.lastName?.toLowerCase() ?? '').contains(_searchQuery.toLowerCase()) ||
                            (s.username.toLowerCase()).contains(_searchQuery.toLowerCase());
      
      if (_selectedClassId != null) {
        final studentsInClass = classProvider.getStudentsInClass(_selectedClassId!);
        return matchesSearch && studentsInClass.any((sc) => sc.id == s.id);
      }
      
      return matchesSearch;
    }).toList();

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
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildClassFilter(myClasses),
                  if (_selectedClassId != null) ...[
                    const SizedBox(height: 32),
                    _buildClassInsightCard(classProvider.getClassName(_selectedClassId!), filteredStudents.length),
                  ],
                  const SizedBox(height: 32),
                  _buildStudentsHeader(filteredStudents.length),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          _buildStudentsList(filteredStudents),
          const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
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
      title: Text("Student Directory", style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87, fontWeight: FontWeight.bold, fontSize: 24)),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.sort, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: "Search by name or ID...",
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: apexPrimary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildClassFilter(List<dynamic> classes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Filter by Class", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterChip(null, "All Classes"),
              ...classes.map((c) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: _buildFilterChip(c.id.toString(), c.name.toString()),
              )).cast<Widget>(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String? id, String label) {
    final isSelected = _selectedClassId == id;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) => setState(() => _selectedClassId = id),
      backgroundColor: Theme.of(context).cardColor,
      selectedColor: apexPrimary,
      labelStyle: TextStyle(
        color: isSelected ? Theme.of(context).cardColor : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      elevation: 0,
      pressElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSelected ? apexPrimary : Colors.grey[200]!)),
    );
  }

  Widget _buildStudentsHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Students List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: apexPrimary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Text("$count Total", style: const TextStyle(color: apexPrimary, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildStudentsList(List<User> students) {
    if (students.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_search_outlined, size: 64, color: Colors.grey[200]),
              const SizedBox(height: 16),
              Text("No students match your criteria", style: TextStyle(color: Colors.grey[400])),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final student = students[index];
            return _buildStudentCard(student);
          },
          childCount: students.length,
        ),
      ),
    );
  }

  Widget _buildClassInsightCard(String className, int studentCount) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [apexPrimary, apexPrimary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: apexPrimary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CLASS OVERVIEW", style: TextStyle(color: Theme.of(context).cardColor.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                  const SizedBox(height: 4),
                  Text(className, style: TextStyle(color: Theme.of(context).cardColor, fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                child: Icon(Icons.analytics_outlined, color: Theme.of(context).cardColor, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildMetricItem("Students", studentCount.toString(), Icons.people_outline),
              const SizedBox(width: 24),
              _buildMetricItem("Attendance", "94%", Icons.calendar_today_outlined),
              const SizedBox(width: 24),
              _buildMetricItem("Average", "B+", Icons.grade_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Theme.of(context).cardColor.withOpacity(0.7), size: 14),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: Theme.of(context).cardColor.withOpacity(0.7), fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: Theme.of(context).cardColor, fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStudentCard(dynamic student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: apexPrimary.withOpacity(0.1),
            child: Text(
              (student.firstName?.isNotEmpty ?? false) ? student.firstName![0] : (student.username.isNotEmpty ? student.username[0] : "?"),
              style: const TextStyle(color: apexPrimary, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${student.firstName ?? ''} ${student.lastName ?? ''}".trim().isEmpty ? student.username : "${student.firstName} ${student.lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(student.email, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.badge_outlined, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(student.username, style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

