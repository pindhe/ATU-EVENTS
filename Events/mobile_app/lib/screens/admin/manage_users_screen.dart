import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/class_provider.dart';
import '../../providers/log_provider.dart';
import 'admin_dashboard.dart';

const Color apexPrimary = Color(0xFF5A67D8);
const Color apexBg = Color(0xFFF8F9FF);
const Color apexText = Color(0xFF0B1C30);

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({Key? key}) : super(key: key);

  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {

  void _showCreateUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => const CreateUserDialog(),
    ).then((result) {
      if (result != null && result is User) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Managed Successfully!')));
      }
    });
  }

  void _showUserDetail(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (ctx) {
        return UserDetailSheet(
          user: user,
          onUpdate: (updatedUser) {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Updated Successfully!')));
          },
          onDelete: () {
            Provider.of<AuthProvider>(context, listen: false).deleteUser(user.id);
            Provider.of<LogProvider>(context, listen: false).addLog(
              event: 'User Deleted',
              user: Provider.of<AuthProvider>(context, listen: false).currentUser?.username ?? 'Admin',
              status: 'Success',
              severity: 'medium',
            );
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Deleted Successfully!')));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final users = authProvider.registeredUsers;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(context, users.length),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            leading: CircleAvatar(
                              radius: 28,
                              backgroundColor: apexPrimary.withAlpha(25),
                              child: Text(
                                user.firstName != null && user.firstName!.isNotEmpty ? user.firstName![0].toUpperCase() : user.username[0].toUpperCase(),
                                style: const TextStyle(color: apexPrimary, fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            title: Text(
                              '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim().isEmpty ? user.username : '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.email_outlined, size: 14, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(user.email, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getRoleColor(user.role).withAlpha(30),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: _getRoleColor(user.role).withAlpha(100)),
                                  ),
                                  child: Text(
                                    user.role.replaceAll('_', ' ').toUpperCase(),
                                    style: TextStyle(color: _getRoleColor(user.role), fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () => _showUserDetail(context, user),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: apexPrimary,
                                side: const BorderSide(color: apexPrimary),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: const Text('Manage'),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context, int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(width: 4, height: 16, decoration: BoxDecoration(color: apexPrimary, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 8),
            Text("DIRECTORY MANAGEMENT", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.1)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("User Directory", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: apexText)),
            IconButton(
              onPressed: () => _showCreateUserDialog(context),
              icon: const Icon(Icons.person_add_outlined, color: apexPrimary),
              style: IconButton.styleFrom(
                backgroundColor: apexPrimary.withOpacity(0.1),
                padding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text("Total Registered Users: $count", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
      ],
    );
  }

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'teacher':
        return Colors.blue;
      case 'normal_user':
      case 'student':
      default:
        return Colors.green;
    }
  }
}


class UserDetailSheet extends StatelessWidget {
  final User user;
  final Function(User) onUpdate;
  final VoidCallback onDelete;

  const UserDetailSheet({Key? key, required this.user, required this.onUpdate, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: apexPrimary.withAlpha(25),
                  child: Text(
                    user.firstName != null && user.firstName!.isNotEmpty ? user.firstName![0].toUpperCase() : user.username[0].toUpperCase(),
                    style: const TextStyle(color: apexPrimary, fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim().isEmpty ? user.username : '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim(),
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(user.email, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: TextStyle(color: Colors.grey[800], fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Trigger Update
                      showDialog(
                        context: context,
                        builder: (ctx) => CreateUserDialog(existingUser: user),
                      ).then((updatedUser) {
                        if (updatedUser != null && updatedUser is User) {
                          onUpdate(updatedUser);
                        }
                      });
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    label: const Text('Update', style: TextStyle(color: Colors.blue)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showDeleteConfirmation(context);
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text('Delete', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete ${user.username}? This action cannot be undone.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onDelete();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class CreateUserDialog extends StatefulWidget {
  final User? existingUser;

  const CreateUserDialog({Key? key, this.existingUser}) : super(key: key);

  @override
  _CreateUserDialogState createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _role;
  final TextEditingController _usernameController = TextEditingController();
  late String _email;
  late String _firstName;
  late String _lastName;
  String _password = '';
  String? _selectedFacultyId;
  String? _selectedClassId;

  @override
  void initState() {
    super.initState();
    _role = widget.existingUser?.role ?? 'normal_user';
    _usernameController.text = widget.existingUser?.username ?? '';
    _email = widget.existingUser?.email ?? '';
    _firstName = widget.existingUser?.firstName ?? '';
    _lastName = widget.existingUser?.lastName ?? '';

    // Generate ID for new students
    if (widget.existingUser == null && _role == 'normal_user') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _generateStudentId();
      });
    }
  }

  void _generateStudentId() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _usernameController.text = authProvider.generateNextStudentId();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final newUser = User(
        id: widget.existingUser?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        username: _usernameController.text,
        email: _email,
        role: _role,
        firstName: _firstName,
        lastName: _lastName,
        classId: _selectedClassId,
      );
      
      // Register in AuthProvider so they can actually log in
      Provider.of<AuthProvider>(context, listen: false).registerNewUser(newUser, _password);
      
      // Generate Security Log
      Provider.of<LogProvider>(context, listen: false).addLog(
        event: widget.existingUser != null ? 'User Updated' : 'New User Created',
        user: Provider.of<AuthProvider>(context, listen: false).currentUser?.username ?? 'Admin',
        status: 'Success',
        severity: 'low',
      );
      
      Navigator.of(context).pop(newUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingUser != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? 'Update User' : 'Create New User',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: apexPrimary),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _role,
                  decoration: InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'normal_user', child: Text('Student')),
                    DropdownMenuItem(value: 'teacher', child: Text('Teacher')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: (val) {
                    setState(() {
                      _role = val!;
                      _selectedFacultyId = null;
                      _selectedClassId = null;
                      if (_role == 'normal_user' && !isEditing) {
                        _generateStudentId();
                      } else if (!isEditing) {
                        _usernameController.clear();
                      }
                    });
                  },
                ),
                if (_role == 'teacher' || _role == 'normal_user') ...[
                  const SizedBox(height: 16),
                  Consumer<ClassProvider>(
                    builder: (context, classProvider, _) {
                      return DropdownButtonFormField<String>(
                        value: _selectedFacultyId,
                        decoration: InputDecoration(
                          labelText: 'Faculty',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: classProvider.faculties.map((f) => DropdownMenuItem<String>(value: f.id, child: Text(f.name))).toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedFacultyId = val;
                            _selectedClassId = null;
                          });
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Consumer<ClassProvider>(
                    builder: (context, classProvider, _) {
                      final classes = _selectedFacultyId != null ? classProvider.getClassesForFaculty(_selectedFacultyId!) : [];
                      return DropdownButtonFormField<String>(
                        value: _selectedClassId,
                        decoration: InputDecoration(
                          labelText: 'Class',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: classes.map((c) => DropdownMenuItem<String>(value: c.id, child: Text(c.name))).toList(),
                        onChanged: (val) => setState(() => _selectedClassId = val),
                        disabledHint: const Text('Select Faculty first'),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: _firstName,
                        decoration: InputDecoration(
                          labelText: 'First Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSaved: (val) => _firstName = val ?? '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: _lastName,
                        decoration: InputDecoration(
                          labelText: 'Last Name',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSaved: (val) => _lastName = val ?? '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  readOnly: _role == 'normal_user' && !isEditing,
                  decoration: InputDecoration(
                    labelText: _role == 'normal_user' ? 'Generated Student ID' : 'Username',
                    fillColor: _role == 'normal_user' && !isEditing ? Colors.grey[100] : null,
                    filled: _role == 'normal_user' && !isEditing,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    helperText: _role == 'normal_user' && !isEditing ? 'ID is generated automatically' : null,
                  ),
                  validator: (val) => val == null || val.isEmpty ? 'Please enter a value' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _email,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Please enter an email';
                    if (!val.contains('@')) return 'Please enter a valid email';
                    return null;
                  },
                  onSaved: (val) => _email = val!,
                ),
                const SizedBox(height: 16),
                if (!isEditing)
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    obscureText: true,
                    validator: (val) => val == null || val.length < 6 ? 'Password too short' : null,
                    onSaved: (val) => _password = val!,
                  ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: apexPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text(isEditing ? 'Save Changes' : 'Create User', style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
