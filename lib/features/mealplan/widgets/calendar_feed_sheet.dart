import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../shared/widgets/sheet_title.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mealie_recipes/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/api/api_service.dart';
import '../../../core/providers/permissions_provider.dart';
import '../../../core/utils/iana_timezone.dart';
import '../../../core/utils/meal_types.dart';
import '../../../core/utils/mealie_locale.dart';
import '../../../core/utils/mealie_version.dart';
import '../../../core/providers/settings_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/app_chip.dart';
import '../../../shared/widgets/gradient_button.dart';
import '../../../core/utils/platform_features.dart';
import '../../../shared/widgets/collapsible_hint.dart';

// ---------------------------------------------------------------------------
// Mahlzeitplan als Kalender abonnieren (Mealie ≥ 3.29, iCal-Feed).
//
// Alles kommt vom Server: Mealie verwaltet das geheime Token des Haushalts
// und liefert den fertigen Feed unter /households/mealplans/ical/{token}.
// Die App wählt nur die Feed-Optionen (Mahlzeiten, Notizen, Uhrzeiten) —
// die stecken wie in der Webapp als Parameter im Link — und übergibt den
// Link an eine Kalender-App:
//   • webcal:// → Apple Kalender (iOS/macOS) bzw. jede Android-App, die
//     Kalender-Abos annimmt (z. B. ICSx⁵, Outlook),
//   • Google Kalender über dessen „Per URL hinzufügen"-Link (auch Android),
//   • Kopieren/Teilen für alles andere (Home Assistant, Thunderbird …).
// Ein-/Ausschalten und Zurücksetzen nur mit „Haushalt verwalten" (sonst
// antwortet Mealie mit 403) — ohne das Recht nur Hinweis + Link.
// ---------------------------------------------------------------------------

Future<void> showCalendarFeedSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      useRootNavigator: true,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (_) => const _CalendarFeedSheet(),
    );

const _kOptionsKey = 'mealplan_ical_options';

// Mealie-Standardwerte (mealplan_ical_service.py) — nur Abweichungen kommen
// in den Link, wie in der Webapp.
const _kDefaultDuration = 60;
const _kDefaultSummary = r'${type}: ${title}';
const _kDefaultDescription = '\${note}\n\n\${url}';

/// Vorbelegte Uhrzeiten (Optionen ohne `v: 2` stammen von vor der
/// Vorbelegung und bekommen sie einmalig dazu).
const _kDefaultTimes = {
  'breakfast': '08:00',
  'lunch': '12:00',
  'dinner': '18:00',
};

class _CalendarFeedSheet extends ConsumerStatefulWidget {
  const _CalendarFeedSheet();

  @override
  ConsumerState<_CalendarFeedSheet> createState() => _CalendarFeedSheetState();
}

class _CalendarFeedSheetState extends ConsumerState<_CalendarFeedSheet> {
  bool _loading = true;
  bool _busy = false;
  Object? _error;
  String? _token;

  Set<String> _types = {...kMealTypes};
  bool _includeNotes = true;

  /// Startzeit je Mahlzeit („18:00"); ohne Zeit = ganztägiger Termin.
  /// Vorbelegt mit üblichen Essenszeiten — sonst erscheint jede Mahlzeit
  /// als ganztägiger Termin.
  final Map<String, String> _times = {..._kDefaultTimes};

  // Mealie ≥ 3.30: Termindauer (Minuten) und Vorlagen für Titel/Beschreibung.
  final _durationCtrl = TextEditingController(text: '$_kDefaultDuration');
  final _summaryCtrl = TextEditingController(text: _kDefaultSummary);
  final _descriptionCtrl = TextEditingController(text: _kDefaultDescription);

  @override
  void dispose() {
    _durationCtrl.dispose();
    _summaryCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadOptions();
    _loadToken();
  }

  // ── Optionen (nur lokal, sie stecken im Link) ────────────────────────────

  Future<void> _loadOptions() async {
    try {
      final raw =
          (await SharedPreferences.getInstance()).getString(_kOptionsKey);
      if (raw == null) return;
      final m = jsonDecode(raw) as Map<String, dynamic>;
      final types = (m['types'] as List?)?.whereType<String>().toSet();
      if (!mounted) return;
      setState(() {
        if (types != null && types.isNotEmpty) {
          _types = types.where(kMealTypes.contains).toSet();
        }
        _includeNotes = m['includeNotes'] as bool? ?? true;
        if (m['duration'] is num) {
          _durationCtrl.text = '${(m['duration'] as num).toInt()}';
        }
        if (m['summary'] is String) _summaryCtrl.text = m['summary'] as String;
        if (m['description'] is String) {
          _descriptionCtrl.text = m['description'] as String;
        }
        _times
          ..clear()
          ..addAll(m['v'] == 2 ? const {} : _kDefaultTimes)
          ..addAll(((m['times'] as Map?) ?? const {})
              .map((k, v) => MapEntry('$k', '$v')));
      });
    } catch (_) {/* Standardwerte */}
  }

  Future<void> _saveOptions() async {
    try {
      await (await SharedPreferences.getInstance()).setString(
          _kOptionsKey,
          jsonEncode({
            'v': 2,
            'types': _types.toList(),
            'includeNotes': _includeNotes,
            'times': _times,
            'duration': int.tryParse(_durationCtrl.text.trim()),
            'summary': _summaryCtrl.text,
            'description': _descriptionCtrl.text,
          }));
    } catch (_) {}
  }

  // ── Token vom Server ─────────────────────────────────────────────────────

  Future<void> _loadToken() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final t = await ref.read(apiServiceProvider).fetchMealplanIcalToken();
      if (mounted) setState(() => _token = t);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _run(Future<String?> Function() op) async {
    final l = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final t = await op();
      if (mounted) setState(() => _token = t);
    } catch (e) {
      messenger.showSnackBar(
          SnackBar(content: Text(userErrorMessage(e, l.saveFailed))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<bool> _confirm(String text, String action) async {
    final l = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: ctx.appCard,
            content: Text(text),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text(l.cancel)),
              FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: Text(action)),
            ],
          ),
        ) ??
        false;
  }

  // ── Link ─────────────────────────────────────────────────────────────────

  String _feedUrl() {
    final query = <String, List<String>>{};
    // Alle Mahlzeiten = Parameter weglassen (wie die Webapp).
    if (_types.isNotEmpty && _types.length < kMealTypes.length) {
      query['types'] = [
        for (final t in kMealTypes)
          if (_types.contains(t)) t
      ];
    }
    if (!_includeNotes) query['includeNotes'] = ['false'];
    var hasTimes = false;
    for (final t in kMealTypes) {
      final time = _times[t];
      if (_types.contains(t) && time != null && time.isNotEmpty) {
        query[t] = [time];
        hasTimes = true;
      }
    }
    if (hasTimes) {
      final zone = guessIanaTimeZone();
      if (zone != null) query['tz'] = [zone];
    }
    if (ref.read(mealie330Provider)) {
      // Sprache der Mahlzeiten-Namen im Kalender = App-Sprache (Kalender-
      // Apps schicken keine Sprache mit).
      query['lang'] = [
        mealieLocaleFor(
            ref.read(settingsProvider).valueOrNull?.selectedLanguage)
      ];
      final duration = int.tryParse(_durationCtrl.text.trim());
      if (hasTimes &&
          duration != null &&
          duration >= 1 &&
          duration <= 1440 &&
          duration != _kDefaultDuration) {
        query['duration'] = ['$duration'];
      }
      final summary = _summaryCtrl.text;
      if (summary.trim().isNotEmpty && summary != _kDefaultSummary) {
        query['summary'] = [summary];
      }
      final description = _descriptionCtrl.text;
      if (description.trim().isNotEmpty &&
          description != _kDefaultDescription) {
        query['description'] = [description];
      }
    }
    return ref.read(apiServiceProvider).mealplanIcalFeedUrl(_token!, query);
  }

  /// Öffnet den Standard-Kalender des Nutzers mit dem Abo (webcal://):
  /// Apple Kalender (iOS/macOS), auf Android die als Standard gewählte App
  /// für Kalender-Abos (z. B. Outlook, ICSx⁵). Nimmt keine App webcal-Links
  /// an — auf Android der Normalfall mit Google Kalender, der das nur über
  /// seine Webseite kann — öffnet sich Google Kalenders „Per URL
  /// hinzufügen" mit dem fertigen Link.
  Future<void> _subscribe() async {
    final webcal = Uri.parse(_feedUrl()).replace(scheme: 'webcal');
    var ok = false;
    try {
      ok = await launchUrl(webcal, mode: LaunchMode.externalApplication);
    } catch (_) {}
    if (ok) return;
    try {
      await launchUrl(
          Uri.https(
              'calendar.google.com', '/calendar/r', {'cid': webcal.toString()}),
          // Desktop (Windows/macOS): Standardbrowser — einen In-App-
          // Browser gibt es dort nicht.
          mode: PlatformFeatures.isMobile
              ? LaunchMode.inAppBrowserView
              : LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.calendarFeedNoApp)));
      }
    }
  }

  Future<void> _copy() async {
    final l = AppLocalizations.of(context)!;
    await Clipboard.setData(ClipboardData(text: _feedUrl()));
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(l.linkCopied)));
    }
  }

  Future<void> _share(BuildContext buttonContext) async {
    final box = buttonContext.findRenderObject() as RenderBox?;
    await SharePlus.instance.share(ShareParams(
      text: _feedUrl(),
      sharePositionOrigin:
          box == null ? null : box.localToGlobal(Offset.zero) & box.size,
    ));
  }

  Future<void> _pickTime(String type) async {
    final current = _times[type];
    final parts = current?.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: parts != null && parts.length == 2
          ? TimeOfDay(
              hour: int.tryParse(parts[0]) ?? 12,
              minute: int.tryParse(parts[1]) ?? 0)
          : _defaultTime(type),
    );
    if (picked == null || !mounted) return;
    setState(() => _times[type] =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
    _saveOptions();
  }

  TimeOfDay _defaultTime(String type) => switch (type) {
        'breakfast' => const TimeOfDay(hour: 8, minute: 0),
        'lunch' => const TimeOfDay(hour: 12, minute: 0),
        'dinner' => const TimeOfDay(hour: 18, minute: 0),
        _ => const TimeOfDay(hour: 15, minute: 0),
      };

  // ── UI ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final perms = ref.watch(userPermissionsProvider);
    final canManage = perms.admin || perms.canManageHousehold;

    final children = <Widget>[
      const Center(child: SheetHandle()),
      SheetTitle(l.calendarFeedTitle),
      const SizedBox(height: 8),
      CollapsibleHint(
          text: l.calendarFeedDescription,
          prefsKey: 'hint_calendar_feed_collapsed',
          icon: Icons.event_rounded,
          dense: true),
      const SizedBox(height: 16),
    ];

    if (_loading) {
      children.add(const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: CircularProgressIndicator())));
    } else if (_error != null) {
      children.addAll([
        Text(userErrorMessage(_error!), style: TextStyle(color: context.appFg)),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
              onPressed: _loadToken,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l.retry)),
        ),
      ]);
    } else if (_token == null) {
      children.addAll([
        Text(
            canManage
                ? l.calendarFeedOff
                : '${l.calendarFeedOff} ${l.calendarFeedAskManager}',
            style: TextStyle(color: context.appFg, fontSize: 14)),
        if (canManage) ...[
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _busy
                ? null
                : () =>
                    _run(ref.read(apiServiceProvider).createMealplanIcalToken),
            icon: const Icon(Icons.event_available_rounded),
            label: Text(l.calendarFeedTurnOn),
          ),
        ],
      ]);
    } else {
      children.addAll(_feedOptions(l, canManage));
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.8,
      maxChildSize: 0.95,
      builder: (_, scroll) => ListView(
        controller: scroll,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: children,
      ),
    );
  }

  List<Widget> _feedOptions(AppLocalizations l, bool canManage) {
    final selected = [
      for (final t in kMealTypes)
        if (_types.contains(t)) t
    ];
    return [
      // Mahlzeiten
      Text(l.calendarFeedMealTypes,
          style: TextStyle(color: context.appFgSub, fontSize: 13)),
      const SizedBox(height: 6),
      Wrap(spacing: 6, runSpacing: 6, children: [
        for (final t in kMealTypes)
          AppChip(
            label: mealTypeLabel(t, l),
            icon: _types.contains(t) ? Icons.check_rounded : null,
            selected: _types.contains(t),
            onTap: () {
              final on = !_types.contains(t);
              // Mindestens eine Mahlzeit bleibt gewählt.
              if (!on && _types.length == 1) return;
              setState(() => on ? _types.add(t) : _types.remove(t));
              _saveOptions();
            },
          ),
      ]),
      SwitchListTile.adaptive(
        contentPadding: EdgeInsets.zero,
        activeTrackColor: AppTokens.accent,
        title: Text(l.calendarFeedIncludeNotes),
        value: _includeNotes,
        onChanged: (v) {
          setState(() => _includeNotes = v);
          _saveOptions();
        },
      ),
      // Uhrzeiten
      Text(l.calendarFeedTimesHint,
          style: TextStyle(color: context.appFgSub, fontSize: 13)),
      const SizedBox(height: 6),
      Wrap(spacing: 6, runSpacing: 6, children: [
        for (final t in selected)
          AppChip(
            icon: Icons.schedule_rounded,
            label: _times[t] == null
                ? mealTypeLabel(t, l)
                : '${mealTypeLabel(t, l)} · ${_times[t]}',
            selected: _times[t] != null,
            onTap: () => _pickTime(t),
            removeTooltip: l.delete,
            onRemove: _times[t] == null
                ? null
                : () {
                    setState(() => _times.remove(t));
                    _saveOptions();
                  },
          ),
      ]),
      // ── Mealie ≥ 3.30: Termindauer + eigene Vorlagen ─────────────────
      if (ref.watch(mealie330Provider)) ...[
        if (_types.any((t) => (_times[t] ?? '').isNotEmpty)) ...[
          const SizedBox(height: 14),
          TextField(
            controller: _durationCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: l.calendarFeedDuration,
              isDense: true,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) {
              setState(() {});
              _saveOptions();
            },
          ),
        ],
        const SizedBox(height: 6),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: 8),
            title: Text(l.calendarFeedEventDetails,
                style: TextStyle(
                    color: context.appFg,
                    fontSize: 15,
                    fontWeight: FontWeight.w600)),
            children: [
              Text(
                  l.calendarFeedEventDetailsHint(
                      r'${type}, ${title}, ${note}, ${url}'),
                  style: TextStyle(color: context.appFgSub, fontSize: 13)),
              const SizedBox(height: 10),
              TextField(
                controller: _summaryCtrl,
                decoration: InputDecoration(
                  labelText: l.calendarFeedEventTitle,
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {});
                  _saveOptions();
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionCtrl,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: l.calendarFeedEventDescription,
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {});
                  _saveOptions();
                },
              ),
              const SizedBox(height: 6),
              Text(l.calendarFeedEventDetailsWarning,
                  style: TextStyle(color: context.appFgTertiary, fontSize: 12)),
            ],
          ),
        ),
      ],
      const SizedBox(height: 18),
      // Abonnieren — öffnet den Standard-Kalender.
      FilledButton.icon(
        onPressed: _subscribe,
        icon: const Icon(Icons.event_rounded),
        label: Text(l.calendarFeedSubscribe),
      ),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _copy,
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: Text(l.copyLinkAction),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Builder(
            builder: (bctx) => OutlinedButton.icon(
              onPressed: () => _share(bctx),
              icon: const Icon(Icons.ios_share_rounded, size: 18),
              label: Text(l.assetsShare),
            ),
          ),
        ),
      ]),
      const SizedBox(height: 10),
      Text(l.calendarFeedPublicHint,
          style: TextStyle(color: context.appFgTertiary, fontSize: 12)),
      if (canManage) ...[
        const SizedBox(height: 18),
        Text(l.calendarFeedResetHint,
            style: TextStyle(color: context.appFgSub, fontSize: 13)),
        const SizedBox(height: 6),
        Row(children: [
          Expanded(
            child: TextButton.icon(
              onPressed: _busy
                  ? null
                  : () async {
                      if (!await _confirm(
                          l.calendarFeedResetHint, l.calendarFeedReset)) {
                        return;
                      }
                      await _run(
                          ref.read(apiServiceProvider).createMealplanIcalToken);
                    },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l.calendarFeedReset),
            ),
          ),
          Expanded(
            child: TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: _busy
                  ? null
                  : () async {
                      if (!await _confirm(
                          l.calendarFeedResetHint, l.calendarFeedTurnOff)) {
                        return;
                      }
                      await _run(() async {
                        await ref
                            .read(apiServiceProvider)
                            .deleteMealplanIcalToken();
                        return null;
                      });
                    },
              icon: const Icon(Icons.event_busy_rounded),
              label: Text(l.calendarFeedTurnOff),
            ),
          ),
        ]),
      ],
    ];
  }
}
