import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/school_class.dart';
import '../models/user.dart';
import '../models/faculty.dart';
import '../models/category.dart';

class ClassProvider with ChangeNotifier {
  List<Faculty> _faculties = [];
  List<Category> _categories = [];
  List<SchoolClass> _classes = [];

  final List<User> _mockStudents = [
    User(id: 's1', username: 'student1', email: 's1@atu.edu', role: 'normal_user', firstName: 'Alice', lastName: 'Johnson'),
    User(id: 's2', username: 'student2', email: 's2@atu.edu', role: 'normal_user', firstName: 'Bob', lastName: 'Smith'),
    User(id: 's3', username: 'student3', email: 's3@atu.edu', role: 'normal_user', firstName: 'Charlie', lastName: 'Davis'),
  ];

  ClassProvider() {
    _loadData();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('faculties', _faculties.map((f) => jsonEncode(f.toJson())).toList());
    await prefs.setStringList('categories', _categories.map((c) => jsonEncode(c.toJson())).toList());
    await prefs.setStringList('classes', _classes.map((c) => jsonEncode(c.toJson())).toList());
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final facultiesJson = prefs.getStringList('faculties');
    final categoriesJson = prefs.getStringList('categories');
    final classesJson = prefs.getStringList('classes');

    if (facultiesJson != null) {
      _faculties = facultiesJson.map((f) => Faculty.fromJson(jsonDecode(f))).toList();
    }
    if (categoriesJson != null) {
      _categories = categoriesJson.map((c) => Category.fromJson(jsonDecode(c))).toList();
    }
    if (classesJson != null) {
      _classes = classesJson.map((c) => SchoolClass.fromJson(jsonDecode(c))).toList();
    }
    notifyListeners();
  }

  List<SchoolClass> get classes => [..._classes];
  List<Faculty> get faculties => [..._faculties];
  List<Category> get categories => [..._categories];

  List<SchoolClass> getClassesForFaculty(String facultyId) {
    return _classes.where((c) => c.facultyId == facultyId).toList();
  }

  List<SchoolClass> getClassesForTeacher(String teacherId) {
    return _classes.where((c) => c.teacherId == teacherId).toList();
  }

  List<User> getStudentsInClass(String classId) {
    try {
      final schoolClass = _classes.firstWhere((c) => c.id == classId);
      return _mockStudents.where((s) => schoolClass.studentIds.contains(s.id)).toList();
    } catch (e) {
      return [];
    }
  }

  List<User> getStudentsForTeacher(String teacherId) {
    final teacherClasses = getClassesForTeacher(teacherId);
    final allStudentIds = teacherClasses.expand((c) => c.studentIds).toSet();
    return _mockStudents.where((s) => allStudentIds.contains(s.id)).toList();
  }

  String getClassName(String classId) {
    try {
      return _classes.firstWhere((c) => c.id == classId).name;
    } catch (e) {
      return 'Unknown Class';
    }
  }

  void addFaculty(String name) {
    _faculties.add(Faculty(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name));
    _saveData();
    notifyListeners();
  }

  void addClass(String name, String facultyId) {
    _classes.add(SchoolClass(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      facultyId: facultyId,
      teacherId: '',
      studentIds: [],
    ));
    _saveData();
    notifyListeners();
  }

  void addCategory(String name) {
    _categories.add(Category(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name));
    _saveData();
    notifyListeners();
  }
}
