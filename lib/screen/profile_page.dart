import 'package:flutter/material.dart';
import 'package:textproject/screen/app_theme.dart';
import 'package:textproject/widget/app_bottom_nav.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) => MainScaffold(
    title: 'Profile',
    selectedIndex: 4,
    showAdd: false,
    body: ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const SizedBox(height: 25),
        const Center(
          child: CircleAvatar(
            radius: 43,
            backgroundColor: Color(0xFFE8ECEB),
            child: Icon(Icons.person, size: 55, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'Sahal Muhammed',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        const Center(
          child: Text(
            'sahal@example.com',
            style: TextStyle(fontSize: 11, color: AppTheme.muted),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: OutlinedButton(
            onPressed: () => _message(context, 'Change Photo'),
            child: const Text('Change Photo', style: TextStyle(fontSize: 11)),
          ),
        ),
        const SizedBox(height: 30),
        _setting(context, Icons.person_outline, 'Personal Information'),
        _setting(context, Icons.notifications_none, 'Notifications'),
        _setting(context, Icons.lock_outline, 'Security'),
        _setting(context, Icons.color_lens_outlined, 'Appearance'),
        _setting(context, Icons.help_outline, 'Help & Support'),
        _setting(context, Icons.logout, 'Log Out'),
      ],
    ),
  );

  Widget _setting(BuildContext context, IconData icon, String title) =>
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(icon, color: AppTheme.teal, size: 21),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          size: 18,
          color: AppTheme.muted,
        ),
        onTap: () => _message(context, title),
      );

  void _message(BuildContext context, String text) => ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text('$text selected')));
}
