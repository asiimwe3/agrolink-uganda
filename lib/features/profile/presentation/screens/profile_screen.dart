import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.surfaceLight,
                child: Icon(Icons.person, size: 32, color: AppColors.textSecondary),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('John Kato', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    Text('+256 700 123456', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsTile(icon: Icons.language_rounded, label: 'Language', trailing: 'English'),
          _SettingsSwitchTile(
            icon: Icons.dark_mode_outlined,
            label: 'Dark Mode',
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          _SettingsTile(icon: Icons.settings_outlined, label: 'Settings'),
          _SettingsTile(icon: Icons.help_outline_rounded, label: 'Help Center'),
          _SettingsTile(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy'),
          _SettingsTile(icon: Icons.description_outlined, label: 'Terms of Service'),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
            title: const Text('Logout', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
            onTap: () async {
              await SupabaseService.client.auth.signOut();
              if (context.mounted) context.go('/welcome');
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailing;
  const _SettingsTile({required this.icon, required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary),
      title: Text(label),
      trailing: trailing != null
          ? Text(trailing!, style: const TextStyle(color: AppColors.textSecondary))
          : const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
      onTap: () {},
    );
  }
}

class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SettingsSwitchTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.textSecondary),
      title: Text(label),
      value: value,
      activeColor: AppColors.primaryGreen,
      onChanged: onChanged,
    );
  }
}
