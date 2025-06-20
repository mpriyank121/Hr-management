import 'package:flutter/material.dart';

import '../../config/font_style.dart';
import '../../core/widgets/App_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Notification',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildNotificationItem(
            context,
            icon: Icons.shield_outlined,
            title: 'Account Security Alert',
            subtitle: 'We\'ve noticed some unusual activity on your account.',
            time: '09:00 AM',
          ),
          const SizedBox(height: 16),
          _buildNotificationItem(
            context,
            icon: Icons.download_outlined,
            title: 'System Update Available',
            subtitle: 'We\'ve noticed some unusual activity on your account.',
            time: '09:00 AM',
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text('Yesterday', style: FontStyles.subTextStyle()),
          ),
          _buildNotificationItem(
            context,
            icon: Icons.lock_open_outlined,
            title: 'Password Reset Successful',
            subtitle: 'We\'ve noticed some unusual activity on your account.',
            time: '09:00 AM',
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Icon(icon, color: Colors.black, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: FontStyles.subHeadingStyle(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: FontStyles.subTextStyle()),
              const SizedBox(height: 8),
              Text(
                time,
                style: FontStyles.subTextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 