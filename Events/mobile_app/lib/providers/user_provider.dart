import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  List<User> _users = [];

  UserProvider() {
    _loadUsers();
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> userList = _users.map((u) => jsonEncode({
      'id': u.id,
      'username': u.username,
      'email': u.email,
      'role': u.role,
      'firstName': u.firstName,
      'lastName': u.lastName,
    })).toList();
    await prefs.setStringList('stored_users', userList);
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? userList = prefs.getStringList('stored_users');
    if (userList != null && userList.isNotEmpty) {
      _users = userList.map((u) {
        final data = jsonDecode(u);
        return User(
          id: data['id'],
          username: data['username'],
          email: data['email'],
          role: data['role'],
          firstName: data['firstName'],
          lastName: data['lastName'],
        );
      }).toList();
    } else {
      // Default mock users if nothing is stored
      _users = [
        User(id: '1', username: 'admin', email: 'admin@atu.edu', role: 'admin', firstName: 'Super', lastName: 'Admin'),
        User(id: '2', username: 'jdoe', email: 'teacher@atu.edu', role: 'teacher', firstName: 'John', lastName: 'Doe'),
        User(id: '3', username: 'sstudent', email: 'user@atu.edu', role: 'normal_user', firstName: 'Sarah', lastName: 'Student'),
      ];
      _saveUsers();
    }
    notifyListeners();
  }

  List<User> get allUsers => [..._users];
  int get totalUsers => _users.length;

  void addUser(User user) {
    _users.add(user);
    _saveUsers();
    notifyListeners();
  }

  void deleteUser(String id) {
    _users.removeWhere((u) => u.id == id);
    _saveUsers();
    notifyListeners();
  }
}
