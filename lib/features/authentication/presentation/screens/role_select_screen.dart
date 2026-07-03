import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/auth_providers.dart';

class _RoleOption {
  final String value;
  final String label;
  final String description;
  final IconData icon;
  const _RoleOption(this.value, this.label, this.description, this.icon);
}

const _roleOptions = [
  _RoleOption(AppConstants.roleFarmer, 'Farmer', 'Grow crops and manage your farm', Icons.grass_rounded),
  _RoleOption(AppConstants.roleSaccoAdmin, 'SACCO Member', 'Manage savings, loans & shares', Icons.account_balance_rounded),
  _RoleOption(AppConstants.roleVendor, 'Vendor / Buyer', 'Buy or sell agricultural goods', Icons.storefront_rounded),
  _RoleOption(AppConstants.roleExtensionOfficer, 'Extension Officer', 'Support and advise farmers', Icons.support_agent_rounded),
];

class RoleSelectScreen extends ConsumerStatefulWidget {
  const RoleSelectScreen({super.key});

  @override
  ConsumerState<RoleSelectScreen> createState() => _RoleSelectScreenState();
}

class _RoleSelectScreenState extends ConsumerState<RoleSelectScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Role')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'How will you be using AgroLink Uganda?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: _roleOptions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final option = _roleOptions[i];
                  final isSelected = _selected == option.value;
                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () => setState(() => _selected = option.value),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGreen.withOpacity(0.08)
                            : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? AppColors.primaryGreen : AppColors.border,
                          width: isSelected ? 1.5 : 1,
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primaryGreen.withOpacity(0.12),
                            child: Icon(option.icon, color: AppColors.primaryGreen),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(option.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 2),
                                Text(option.description,
                                    style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle_rounded, color: AppColors.primaryGreen),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected == null
                    ? null
                    : () {
                        ref.read(pendingRegistrationProvider.notifier).setRole(_selected!);
                        context.push('/register');
                      },
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
