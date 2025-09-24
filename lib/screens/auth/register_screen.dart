import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import '../main_screen.dart';
import '../admin/admin_dashboard.dart';
import '../vendor/vendor_dashboard.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _campusIdController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedUserType = 'student'; // student, staff, vendor, admin
  bool isLoading = false;

  final AuthService _authService = AuthService();

  void _register() async {
    setState(() => isLoading = true);

    try {
      final result = await _authService.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        campusId: _campusIdController.text.trim(),
        userType: _selectedUserType,
        password: _passwordController.text,
      );

      final token = result['data']['token'];
      final user = result['data']['user'];

      // Store token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      if (!mounted) return;

      // Navigate based on userType
      switch (user['userType']) {
        case 'vendor':
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const VendorDashboard()),
          );
          break;
        case 'admin':
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
          break;
        default:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone')),
            TextField(
                controller: _campusIdController,
                decoration: const InputDecoration(labelText: 'Campus ID')),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            const SizedBox(height: 12),
            DropdownButton<String>(
              value: _selectedUserType,
              items: const [
                DropdownMenuItem(value: 'student', child: Text('Student')),
                DropdownMenuItem(value: 'staff', child: Text('Staff')),
                DropdownMenuItem(value: 'vendor', child: Text('Vendor')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (value) => setState(() => _selectedUserType = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : _register,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _campusIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
