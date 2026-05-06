import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  List<Map<String, dynamic>> _mockUsers = [
    {
      'username': 'admin',
      'password': 'admin123',
      'user': User(id: '1', username: 'admin', email: 'admin@atu.edu', role: 'admin', firstName: 'Super', lastName: 'Admin')
    },
  ];

  AuthProvider() {
    _loadUsers();
  }

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  String get userRole => _currentUser?.role ?? 'normal_user';
  List<User> get registeredUsers => _mockUsers.map((e) => e['user'] as User).toList();

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> usersJson = _mockUsers.map((record) {
      final user = record['user'] as User;
      return jsonEncode({
        'username': record['username'],
        'password': record['password'],
        'user': {
          'id': user.id,
          'username': user.username,
          'email': user.email,
          'role': user.role,
          'firstName': user.firstName,
          'lastName': user.lastName,
        }
      });
    }).toList();
    await prefs.setStringList('registered_users', usersJson);
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? usersJson = prefs.getStringList('registered_users');
    if (usersJson != null) {
      _mockUsers = usersJson.map((s) {
        final data = jsonDecode(s);
        final userData = data['user'];
        return {
          'username': data['username'],
          'password': data['password'],
          'user': User(
            id: userData['id'],
            username: userData['username'],
            email: userData['email'],
            role: userData['role'],
            firstName: userData['firstName'],
            lastName: userData['lastName'],
          ),
        };
      }).toList();
      notifyListeners();
    }
  }

  String generateNextStudentId() {
    final year = DateTime.now().year.toString();
    final prefix = 'ATU-$year-';
    
    // Filter users who have an ID starting with this year's prefix
    final yearIds = _mockUsers
        .where((u) => u['username'].toString().startsWith(prefix))
        .map((u) {
          final parts = u['username'].toString().split('-');
          if (parts.length == 3) {
            return int.tryParse(parts[2]) ?? 0;
          }
          return 0;
        })
        .toList();

    int nextNum = 1;
    if (yearIds.isNotEmpty) {
      yearIds.sort();
      nextNum = yearIds.last + 1;
    }

    return '$prefix${nextNum.toString().padLeft(3, '0')}';
  }

  Future<bool> login(String identifier, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));

    try {
      final userRecord = _mockUsers.firstWhere(
        (record) => record['username'] == identifier && record['password'] == password,
      );
      _currentUser = userRecord['user'];
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void registerNewUser(User user, String password) {
    final index = _mockUsers.indexWhere((r) => r['username'] == user.username);
    if (index >= 0) {
      _mockUsers[index] = {
        'username': user.username,
        'password': password.isNotEmpty ? password : _mockUsers[index]['password'],
        'user': user,
      };
    } else {
      _mockUsers.add({
        'username': user.username,
        'password': password,
        'user': user,
      });
    }
    _saveUsers();
    notifyListeners();
  }

  void deleteUser(String id) {
    _mockUsers.removeWhere((r) => (r['user'] as User).id == id);
    _saveUsers();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}

