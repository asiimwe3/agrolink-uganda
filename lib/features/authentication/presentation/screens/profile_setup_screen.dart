import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String? _gender;
  final _farmSizeController = TextEditingController();
  final _mainCropController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Your Profile')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tell us more about you',
                style: TextStyle(fontSize: 15, color: Colors.grey)),
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 44,
              backgroundColor: AppColors.surfaceLight,
              child: Icon(Icons.camera_alt_outlined, size: 28, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            const Text('Gender', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Male'),
                    selected: _gender == 'male',
                    onSelected: (_) => setState(() => _gender = 'male'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Female'),
                    selected: _gender == 'female',
                    onSelected: (_) => setState(() => _gender = 'female'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Text('Farm Size (Acres)', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _farmSizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'e.g. 2.5'),
            ),
            const SizedBox(height: 18),
            const Text('Main Crop', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _mainCropController,
              decoration: const InputDecoration(hintText: 'e.g. Maize'),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => context.go('/home'),
                child: const Text('Save & Continue'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('Skip for now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
