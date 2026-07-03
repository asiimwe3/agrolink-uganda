import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';

class OtpVerifyScreen extends ConsumerStatefulWidget {
  const OtpVerifyScreen({super.key});

  @override
  ConsumerState<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends ConsumerState<OtpVerifyScreen> {
  final _otpController = TextEditingController();
  bool _isSubmitting = false;
  String? _error;

  Future<void> _verify() async {
    final pending = ref.read(pendingRegistrationProvider);
    if (pending.phone == null) return;

    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      final repo = ref.read(authRepositoryProvider);
      final res = await repo.verifyOtp(
        phoneNumber: pending.phone!,
        otp: _otpController.text.trim(),
      );
      final userId = res.user?.id;
      if (userId == null) throw Exception('Verification failed');

      final existing = await repo.fetchProfile(userId);
      if (existing == null) {
        await repo.createProfile(
          userId: userId,
          phoneNumber: pending.phone!,
          fullName: pending.fullName ?? '',
          role: pending.role ?? 'farmer',
        );
      }
      if (mounted) context.push('/profile-setup');
    } catch (e) {
      setState(() => _error = 'Invalid code. Please try again.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = ref.watch(pendingRegistrationProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Your Number')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 6-digit code sent to\n${pending.phone ?? ''}',
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 6,
              style: const TextStyle(fontSize: 24, letterSpacing: 12, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(counterText: '', hintText: '••••••'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _verify,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Verify & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
