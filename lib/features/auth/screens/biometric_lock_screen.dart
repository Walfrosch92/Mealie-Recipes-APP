import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../providers/biometric_lock_provider.dart';

// ---------------------------------------------------------------------------
// BiometricLockScreen — wird als Overlay über die ganze App gelegt sobald
// `biometricLockProvider` true ist. KEINE Navigation hier: der Screen
// verschwindet sobald der Notifier unlocked wird; die App darunter ist
// dann sofort wieder bedienbar (mirrors Swifts BiometricLockView mit
// onUnlocked-Callback).
// ---------------------------------------------------------------------------

class BiometricLockScreen extends ConsumerStatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  ConsumerState<BiometricLockScreen> createState() =>
      _BiometricLockScreenState();
}

class _BiometricLockScreenState extends ConsumerState<BiometricLockScreen> {
  final _auth = LocalAuthentication();
  bool _failed = false;
  bool _authInFlight = false;

  @override
  void initState() {
    super.initState();
    // Auto-Prompt sobald der Lock-Screen erscheint (Cold-Start oder
    // Background-Return). Mirrors Swifts `.onAppear { authenticate() }`.
    WidgetsBinding.instance.addPostFrameCallback((_) => _authenticate());
  }

  Future<void> _authenticate() async {
    if (_authInFlight) return;
    _authInFlight = true;
    final l = AppLocalizations.of(context)!;
    setState(() => _failed = false);
    bool ok = false;
    try {
      ok = await _auth.authenticate(
        localizedReason: l.biometricPrompt,
        // false = Geräte-Passcode als Fallback wenn Biometrie nicht
        // verfügbar/registriert ist. Mirrors Swifts Policy-Switch.
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (_) {
      ok = false;
    }
    _authInFlight = false;
    if (!mounted) return;
    if (ok) {
      ref.read(biometricLockProvider.notifier).unlock();
    } else {
      setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.appBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppTokens.accentGradient,
                    boxShadow: context.appAccentGlow,
                  ),
                  child: const Icon(Icons.lock_rounded,
                      size: 56, color: Colors.white),
                ),
                const SizedBox(height: 28),
                // Marke bewusst NICHT übersetzt — immer „Mealie Recipes".
                Text('Mealie Recipes',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(l.biometricPrompt,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: context.appFgSub, fontSize: 15)),
                if (_failed) ...[
                  const SizedBox(height: 16),
                  Text(l.biometricFailed,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                ],
                const SizedBox(height: 32),
                GradientButton(
                  label: l.retry,
                  icon: Icons.fingerprint_rounded,
                  onTap: _authenticate,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
