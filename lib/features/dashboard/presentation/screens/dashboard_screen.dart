import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: refresh weather, farm summary, savings & loan status
            await Future.delayed(const Duration(milliseconds: 600));
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _Header(),
              const SizedBox(height: 20),
              _WeatherCard(),
              const SizedBox(height: 16),
              _QuickActionsGrid(),
              const SizedBox(height: 20),
              const Text('Overview', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              const SizedBox(height: 10),
              _OverviewGrid(),
              const SizedBox(height: 20),
              _SectionCard(
                title: 'Farm Records',
                icon: Icons.agriculture_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'AI Advisor',
                icon: Icons.psychology_alt_rounded,
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _SectionCard(
                title: 'Measure Land',
                icon: Icons.map_rounded,
                onTap: () => context.push('/measure-land'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          backgroundColor: AppColors.surfaceLight,
          child: Icon(Icons.person, color: AppColors.textSecondary),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good morning,', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              Text('John Kato', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _WeatherCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s Weather', style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 4),
                Text('24°C', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
                Text('Light Rain', style: TextStyle(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Icon(Icons.wb_cloudy_rounded, color: Colors.white, size: 36),
              SizedBox(height: 8),
              Text('Humidity 78%', style: TextStyle(color: Colors.white70, fontSize: 11)),
              Text('Wind 12 km/h', style: TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actions = [
      (Icons.grass_rounded, 'My Farm'),
      (Icons.account_balance_rounded, 'SACCO'),
      (Icons.storefront_rounded, 'Market'),
      (Icons.wb_sunny_rounded, 'Weather'),
    ];
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      children: actions.map((a) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primaryGreen.withOpacity(0.1),
              child: Icon(a.$1, color: AppColors.primaryGreen, size: 22),
            ),
            const SizedBox(height: 6),
            Text(a.$2, style: const TextStyle(fontSize: 11)),
          ],
        );
      }).toList(),
    );
  }
}

class _OverviewGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      ('Farm Size', '2.5 Acres', Icons.crop_square_rounded),
      ('Savings Balance', 'UGX 450,000', Icons.savings_rounded),
      ('Loan Status', 'UGX 600,000', Icons.request_quote_rounded),
      ('Main Crop', 'Maize', Icons.eco_rounded),
    ];
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: stats.map((s) {
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(s.$3, color: AppColors.primaryGreen, size: 20),
              const Spacer(),
              Text(s.$2, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Text(s.$1, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _SectionCard({required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
