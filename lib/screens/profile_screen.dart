import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 160 + bottomPadding),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Profile picture
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.8),
                      AppColors.primary.withOpacity(0.3),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/dhanur_logo.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dhanur Music',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Premium Subscriber',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '1 public playlist · 248 liked songs',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 28),

              // Stats row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat('248', 'Liked'),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.surfaceLight,
                    ),
                    _buildStat('6', 'Playlists'),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.surfaceLight,
                    ),
                    _buildStat('12', 'Following'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Edit Profile button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: AppColors.textHint.withOpacity(0.4),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),

              // Settings list
              _buildSettingsTile(Icons.history_rounded, 'Listening History'),
              _buildSettingsTile(Icons.download_rounded, 'Downloads'),
              _buildSettingsTile(Icons.equalizer_rounded, 'Audio Quality'),
              _buildSettingsTile(Icons.dark_mode_rounded, 'Appearance'),
              _buildSettingsTile(Icons.notifications_outlined, 'Notifications'),
              _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy'),
              _buildSettingsTile(Icons.info_outline_rounded, 'About'),
              _buildSettingsTile(Icons.logout_rounded, 'Log Out',
                  isDestructive: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title,
      {bool isDestructive = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.surfaceLight.withOpacity(0.5),
              width: 0.5,
            ),
          ),
        ),
        child: ListTile(
          leading: Icon(
            icon,
            color: isDestructive ? Colors.redAccent : AppColors.textSecondary,
            size: 24,
          ),
          title: Text(
            title,
            style: TextStyle(
              color: isDestructive ? Colors.redAccent : AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textHint,
            size: 22,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ),
    );
  }
}
