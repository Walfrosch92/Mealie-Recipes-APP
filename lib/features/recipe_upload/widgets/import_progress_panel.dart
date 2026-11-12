import 'dart:async';

import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

// ---------------------------------------------------------------------------
// Fortschritt eines laufenden Imports — steht IN der Box des gestarteten
// Imports, nicht irgendwo darunter (#45: vorher zeigte z. B. die Foto-Box
// „Wird hochgeladen …", während ein Link importiert wurde).
//
// Ein dünner, durchlaufender Balken zeigt „es läuft", die Sekundenanzeige,
// dass nichts hängt. [steps] sind die Fortschrittsmeldungen von Mealie
// (`/create/ai/stream`: „Video wird heruntergeladen …", „Audio wird
// transkribiert …" …) in der Reihenfolge ihres Eintreffens: alle bis auf die
// letzte sind erledigt (Haken), die letzte läuft gerade. Wie viele noch
// kommen, meldet Mealie nicht (Übersetzen läuft z. B. nur bei Bedarf) —
// deshalb kein Prozentbalken. Ohne Meldungen steht [label] als laufender
// Schritt da.
// ---------------------------------------------------------------------------

class ImportProgressPanel extends StatefulWidget {
  final List<String> steps;
  final String label;

  /// Optionaler Zusatz unter den Schritten (z. B. „Videos dauern länger").
  final String? hint;

  const ImportProgressPanel({
    super.key,
    this.steps = const [],
    required this.label,
    this.hint,
  });

  @override
  State<ImportProgressPanel> createState() => _ImportProgressPanelState();
}

class _ImportProgressPanelState extends State<ImportProgressPanel> {
  final _started = DateTime.now();
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  static String _elapsed(Duration d) {
    final m = d.inMinutes;
    final s = d.inSeconds % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  /// Erledigte Schritte ohne „…" am Ende („Video heruntergeladen" liest sich
  /// mit Haken besser als „Video wird heruntergeladen...").
  static String _doneText(String s) =>
      s.trim().replaceAll(RegExp(r'(\.\.\.|…)\s*$'), '').trim();

  @override
  Widget build(BuildContext context) {
    final steps = widget.steps.isEmpty ? [widget.label] : widget.steps;
    final elapsed = DateTime.now().difference(_started);
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: context.appSurface2,
        borderRadius: BorderRadius.circular(AppTokens.rSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 4,
                    color: AppTokens.accent,
                    backgroundColor: AppTokens.accent.withValues(alpha: 0.18),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(_elapsed(elapsed),
                  style: TextStyle(
                      color: context.appFgSub,
                      fontSize: 13,
                      fontFeatures: const [FontFeature.tabularFigures()])),
            ],
          ),
          const SizedBox(height: 10),
          for (var i = 0; i < steps.length; i++)
            _StepRow(
              text: i < steps.length - 1 ? _doneText(steps[i]) : steps[i],
              done: i < steps.length - 1,
            ),
          if (widget.hint != null) ...[
            const SizedBox(height: 6),
            Text(widget.hint!,
                style: TextStyle(
                    color: context.appFgTertiary, fontSize: 12, height: 1.35)),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  final String text;
  final bool done;
  const _StepRow({required this.text, required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: done
                ? const Icon(Icons.check_circle_rounded,
                    size: 16, color: AppTokens.accentDeep)
                : Icon(Icons.radio_button_checked_rounded,
                    size: 16, color: AppTokens.accent.withValues(alpha: 0.9)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: TextStyle(
                    color: done ? context.appFgSub : context.appFg,
                    fontSize: 14,
                    height: 1.3,
                    fontWeight: done ? FontWeight.w500 : FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
