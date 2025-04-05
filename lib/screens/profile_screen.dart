import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_button.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Profile',
        hasBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // Navigate to edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildProfileOptions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.gradientPrimary,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white24,
            child: Icon(
              Icons.person,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Sir Ammar',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'ammar@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStat('Total Balance', '\$267,345'),
              _verticalDivider(),
              _buildStat('Accounts', '3'),
              _verticalDivider(),
              _buildStat('Cards', '2'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _verticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white24,
    );
  }

  Widget _buildProfileOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildProfileOption(
            'Personal Information',
            Icons.person_outline,
            () {
              // Navigate to personal info
            },
          ),
          _buildDivider(),
          _buildProfileOption(
            'Security & Privacy',
            Icons.security,
            () {
              // Navigate to security settings
            },
          ),
          _buildDivider(),
          _buildProfileOption(
            'Notification Settings',
            Icons.notifications_none,
            () {
              // Navigate to notifications
            },
          ),
          _buildDivider(),
          _buildProfileOption(
            'Payment Methods',
            Icons.credit_card,
            () {
              // Navigate to payment methods
            },
          ),
          _buildDivider(),
          _buildProfileOption(
            'Help & Support',
            Icons.help_outline,
            () {
              // Navigate to help
            },
          ),
          _buildDivider(),
          _buildProfileOption(
            'About Us',
            Icons.info_outline,
            () {
              // Navigate to about
            },
          ),
          _buildDivider(),
          const SizedBox(height: 20),
          CustomButton(
            text: 'LOG OUT',
            onPressed: () {
              _showLogoutConfirmation(context);
            },
            backgroundColor: Colors.transparent,
            textColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFEEEEEE),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text(
          'Are you sure you want to log out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
              );
            },
            child: const Text('LOG OUT'),
          ),
        ],
      ),
    );
  }
} 