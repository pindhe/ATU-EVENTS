import 'package:flutter/material.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier {
  final List<User> _users = [
    User(id: '1', username: 'admin', email: 'admin@atu.edu', role: 'admin', firstName: 'Super', lastName: 'Admin'),
    User(id: '2', username: 'jdoe', email: 'teacher@atu.edu', role: 'teacher', firstName: 'John', lastName: 'Doe'),
    User(id: '3', username: 'sstudent', email: 'user@atu.edu', role: 'normal_user', firstName: 'Sarah', lastName: 'Student'),
  ];

  List<User> get allUsers => [..._users];

  int get totalUsers => _users.length;
}
