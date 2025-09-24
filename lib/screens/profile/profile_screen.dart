import 'package:flutter/material.dart';
import 'package:campus_feast/models/user.dart';
import 'package:campus_feast/screens/auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User currentUser = User(
    id: 'user1',
    name: 'Rahul Kumar',
    email: 'rahul.kumar@university.edu',
    phone: '+91 98765 43210',
    campusId: 'CSE2021001',
    userType: UserType.student,
    walletBalance: 463.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.5),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                children: [
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      currentUser.name.split(' ').map((n) => n[0]).join().toUpperCase(),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Text(
                    currentUser.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  Text(
                    '${_getUserTypeLabel(currentUser.userType)} • ${currentUser.campusId}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Quick Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ProfileStat(
                        icon: Icons.receipt_long,
                        label: 'Orders',
                        value: '23',
                      ),
                      _ProfileStat(
                        icon: Icons.star,
                        label: 'Rating',
                        value: '4.8',
                      ),
                      _ProfileStat(
                        icon: Icons.savings,
                        label: 'Saved',
                        value: '₹387',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _ProfileTile(
                    icon: Icons.person,
                    title: 'Personal Information',
                    subtitle: 'Update your personal details',
                    onTap: () => _showPersonalInfoDialog(),
                  ),
                  
                  _ProfileTile(
                    icon: Icons.location_on,
                    title: 'Delivery Addresses',
                    subtitle: 'Manage your pickup locations',
                    onTap: () {},
                  ),
                  
                  _ProfileTile(
                    icon: Icons.notifications,
                    title: 'Notifications',
                    subtitle: 'Manage your notification preferences',
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),
                  
                  Text(
                    'Food Preferences',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _ProfileTile(
                    icon: Icons.favorite,
                    title: 'Favorite Vendors',
                    subtitle: 'View your favorite food spots',
                    onTap: () {},
                  ),
                  
                  _ProfileTile(
                    icon: Icons.restaurant_menu,
                    title: 'Dietary Preferences',
                    subtitle: 'Set your dietary restrictions',
                    onTap: () {},
                  ),

                  const SizedBox(height: 24),
                  
                  Text(
                    'Support',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _ProfileTile(
                    icon: Icons.help,
                    title: 'Help & Support',
                    subtitle: 'Get help or report issues',
                    onTap: () {},
                  ),
                  
                  _ProfileTile(
                    icon: Icons.feedback,
                    title: 'Feedback',
                    subtitle: 'Share your thoughts with us',
                    onTap: () {},
                  ),
                  
                  _ProfileTile(
                    icon: Icons.info,
                    title: 'About Campus Feast',
                    subtitle: 'Version 1.0.0',
                    onTap: () => _showAboutDialog(),
                  ),

                  const SizedBox(height: 24),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _logout,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.error,
                        side: BorderSide(color: Theme.of(context).colorScheme.error),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Logout'),
                    ),
                  ),
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPersonalInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Personal Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow('Name', currentUser.name),
            _InfoRow('Email', currentUser.email),
            _InfoRow('Phone', currentUser.phone),
            _InfoRow('Campus ID', currentUser.campusId),
            _InfoRow('User Type', _getUserTypeLabel(currentUser.userType)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to edit profile
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: 'Campus Feast',
      applicationVersion: '1.0.0',
      applicationIcon: Icon(
        Icons.restaurant,
        size: 64,
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        const Text(
          'Campus Feast is your go-to app for hassle-free food ordering on campus. Skip the lines, enjoy exclusive wallet discounts, and savor your favorite meals!',
        ),
        const SizedBox(height: 16),
        const Text('Developed for the betterment of campus dining experience.'),
      ],
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  String _getUserTypeLabel(UserType type) {
    switch (type) {
      case UserType.student:
        return 'Student';
      case UserType.staff:
        return 'Staff';
      case UserType.vendor:
        return 'Vendor';
      case UserType.admin:
        return 'Admin';
    }
  }
}

class _ProfileStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}