import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/markdown_text.dart';
import '../services/app_updater.dart';
import '../widgets/tool_widgets.dart';

// ---------------------------------------------------------------------------
// „Nach Updates suchen" (Desktop): installierte Version, Prüfen, Release-
// Notizen, Herunterladen + Installieren (App startet neu) und der Schalter
// für automatische Updates. Logik: services/app_updater.dart.
// ---------------------------------------------------------------------------

class UpdateScreen extends ConsumerWidget {
  const UpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final st = ref.watch(appUpdateProvider);
    final notifier = ref.read(appUpdateProvider.notifier);
    final auto = ref.watch(autoUpdateEnabledProvider).valueOrNull ?? true;
    final rel = st.release;
    final busy = st.status == UpdateStatus.checking ||
        st.status == UpdateStatus.downloading ||
        st.status == UpdateStatus.installing;

    String statusText() => switch (st.status) {
          UpdateStatus.idle => '',
          UpdateStatus.checking => l.updateChecking,
          UpdateStatus.upToDate => l.updateUpToDate,
          UpdateStatus.available => l.updateAvailable(rel?.version ?? ''),
          UpdateStatus.downloading =>
            l.updateDownloading((st.progress * 100).round()),
          UpdateStatus.ready => l.updateReady(rel?.version ?? ''),
          UpdateStatus.installing => l.updateInstalling,
          UpdateStatus.manual => l.updateManual,
          UpdateStatus.error => l.updateFailed,
        };

    return ToolPage(
      title: l.updateTitle,
      busy: busy,
      children: [
        ToolCard(
          title: l.updateTitle,
          icon: Icons.system_update_rounded,
          children: [
            ToolInfoRow(l.updateInstalledVersion, st.currentVersion ?? '…'),
            if (st.lastCheck != null)
              ToolInfoRow(
                  l.updateLastCheck,
                  formatToolDate(
                      context, st.lastCheck!.toUtc().toIso8601String())),
            if (statusText().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ToolStatusRow(
                  ok: st.status != UpdateStatus.error &&
                      st.status != UpdateStatus.manual,
                  title: statusText(),
                  detail: st.status == UpdateStatus.error && st.error != null
                      ? '${st.error}'
                      : null,
                ),
              ),
            if (st.status == UpdateStatus.downloading)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: LinearProgressIndicator(value: st.progress),
              ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                OutlinedButton.icon(
                  onPressed: busy ? null : notifier.check,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l.updateCheckNow),
                ),
                if (st.status == UpdateStatus.available)
                  FilledButton.icon(
                    onPressed: () async {
                      if (await notifier.download()) await notifier.install();
                    },
                    icon: const Icon(Icons.download_rounded),
                    label: Text(l.updateInstallNow),
                  ),
                if (st.status == UpdateStatus.ready)
                  FilledButton.icon(
                    onPressed: notifier.install,
                    icon: const Icon(Icons.restart_alt_rounded),
                    label: Text(l.updateRestartNow),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              value: auto,
              onChanged: (v) =>
                  ref.read(autoUpdateEnabledProvider.notifier).set(v),
              title: Text(l.updateAutoTitle,
                  style: TextStyle(color: context.appFg)),
              subtitle: Text(l.updateAutoDescription,
                  style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
            ),
          ],
        ),
        if (rel != null &&
            st.status != UpdateStatus.upToDate &&
            st.status != UpdateStatus.checking)
          ToolCard(
            title: rel.name,
            icon: Icons.new_releases_rounded,
            trailing: rel.htmlUrl.isEmpty
                ? null
                : IconButton(
                    tooltip: 'GitHub',
                    icon: const Icon(Icons.open_in_new_rounded),
                    onPressed: () => launchUrl(Uri.parse(rel.htmlUrl),
                        mode: LaunchMode.externalApplication),
                  ),
            children: [
              if (rel.publishedAt != null)
                Text(formatToolDate(context, rel.publishedAt, time: false),
                    style: TextStyle(color: context.appFgSub, fontSize: 12.5)),
              const SizedBox(height: 8),
              if (rel.notes.trim().isEmpty)
                Text(l.updateNoNotes, style: TextStyle(color: context.appFgSub))
              else
                MarkdownText(
                  text: rel.notes,
                  style: TextStyle(
                      color: context.appFg, fontSize: 14, height: 1.45),
                ),
            ],
          ),
        ToolNotice(l.updateSourceHint),
      ],
    );
  }
}

/// Unsichtbar auf dem Startbildschirm (Desktop): prüft beim Start (wenn
/// eingeschaltet) und weist auf ein neues Update hin — installiert NICHT.
class DesktopUpdateTrigger extends ConsumerStatefulWidget {
  const DesktopUpdateTrigger({super.key});

  @override
  ConsumerState<DesktopUpdateTrigger> createState() =>
      _DesktopUpdateTriggerState();
}

class _DesktopUpdateTriggerState extends ConsumerState<DesktopUpdateTrigger> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _run());
  }

  Future<void> _run() async {
    final notifier = ref.read(appUpdateProvider.notifier);
    if (!await notifier.autoRun() || !mounted) return;
    final l = AppLocalizations.of(context)!;
    final version = ref.read(appUpdateProvider).release?.version ?? '';
    final open = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ctx.appCard,
        icon: const Icon(Icons.system_update_rounded,
            color: AppTokens.accentDeep),
        title: Text(l.updateAvailable(version)),
        content: Text(l.updateAvailableDescription),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(l.updateLater)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l.updateShow)),
        ],
      ),
    );
    // Installieren erst auf der Update-Seite per Knopfdruck.
    if (open == true && mounted) context.push('/updates');
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
