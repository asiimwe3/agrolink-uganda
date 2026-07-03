import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class SaccoDashboardScreen extends StatelessWidget {
  const SaccoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SACCO')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bukalasi Farmers SACCO', style: TextStyle(color: Colors.white70, fontSize: 12)),
                SizedBox(height: 6),
                Text('UGX 450,000', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
                Text('Total Savings', style: TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Savings', value: 'UGX 450,000', icon: Icons.savings_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(label: 'Loans', value: 'UGX 1,200,000', icon: Icons.request_quote_rounded)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatCard(label: 'Shares', value: 'UGX 300,000', icon: Icons.pie_chart_rounded)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(label: 'Dividends', value: 'UGX 120,000', icon: Icons.trending_up_rounded)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _ActionButton(label: 'Deposit', icon: Icons.arrow_downward_rounded, onTap: () {})),
              const SizedBox(width: 10),
              Expanded(child: _ActionButton(label: 'Withdraw', icon: Icons.arrow_upward_rounded, onTap: () {})),
              const SizedBox(width: 10),
              Expanded(child: _ActionButton(label: 'Apply Loan', icon: Icons.description_rounded, onTap: () {})),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 6),
          ..._mockTransactions.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.$1, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          Text(t.$2, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Text(
                      t.$3,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: t.$3.startsWith('+') ? AppColors.success : AppColors.error,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

const _mockTransactions = [
  ('Deposit', '15 May 2026', '+ UGX 50,000'),
  ('Loan Disbursement', '16 May 2026', '+ UGX 1,000,000'),
  ('Withdrawal', '02 Apr 2026', '- UGX 100,000'),
  ('Loan Repayment', '18 Apr 2026', '- UGX 210,000'),
];

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.primaryGreen.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 20),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
