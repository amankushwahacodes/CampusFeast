import 'package:flutter/material.dart';
import 'package:campus_feast/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampusIdVerificationScreen extends StatefulWidget {
  final String token;
  
  const CampusIdVerificationScreen({
    Key? key, 
    required this.token,
  }) : super(key: key);

  @override
  State<CampusIdVerificationScreen> createState() => _CampusIdVerificationScreenState();
}

class _CampusIdVerificationScreenState extends State<CampusIdVerificationScreen> {
  final _campusIdController = TextEditingController();
  bool isLoading = false;
  final AuthService _authService = AuthService();

  void _verifyCampusId() async {
    final campusId = _campusIdController.text.trim();
    
    if (campusId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your campus ID')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final isVerified = await _authService.verifyCampusId(
        campusId: campusId,
        token: widget.token,
      );

      if (!mounted) return;

      if (isVerified) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isCampusIdVerified', true);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Campus ID verified successfully')),
        );
        
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid campus ID')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus ID Verification'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Verify Your Campus ID',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Please enter your campus ID to verify your account',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              
              // Campus ID Input
              TextField(
                controller: _campusIdController,
                decoration: InputDecoration(
                  labelText: 'Campus ID',
                  hintText: 'Enter your campus ID',
                  prefixIcon: const Icon(Icons.badge),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Verify Button
              ElevatedButton(
                onPressed: isLoading ? null : _verifyCampusId,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Verify', style: TextStyle(fontSize: 16)),
              ),
              
              const SizedBox(height: 16),
              
              // Skip for now
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}