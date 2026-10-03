import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Hinweisleiste „nur ansehen" — wenn dem Nutzer in Mealie das Recht für
/// Änderungen fehlt (z. B. Organisieren).
class ReadOnlyBanner extends StatelessWidget {
  final String text;
  const ReadOnlyBanner({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTokens.accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppTokens.rSm),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lock_outline_rounded,
              size: 18, color: AppTokens.accentDeep),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: context.appFgSub, fontSize: 12.5, height: 1.35)),
          ),
        ],
      ),
    );
  }
}
