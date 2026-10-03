import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/services/log_manager.dart';
import '../../../core/utils/platform_features.dart';

// ---------------------------------------------------------------------------
// Update-Prüfer der Desktop-Apps (Windows/macOS) über GitHub-Releases von
// Walfrosch92/Mealie-Recipes-APP.
//
// Erkennung NUR über die Asset-Dateinamen (Tag/Titel egal), die die
// Paketier-Skripte erzeugen:
//   macOS:   MealieRecipes-<x.y.z>-arm64.dmg            (macos/packaging)
//   Windows: MealieRecipes-<x.y.z>-windows-setup.exe    (windows/packaging)
// Entwürfe und Vorab-Releases werden ignoriert.
//
// Installation:
// - Windows: Inno-Setup-Installer still (/VERYSILENT) starten, App beendet
//   sich; der Installer startet sie danach neu (installer.iss [Run]).
// - macOS (ohne Sandbox): DMG einhängen, Signatur prüfen (Team Q84VVPH7B3),
//   neue App neben die alte kopieren; ein kleines Skript wartet, bis diese
//   App beendet ist, tauscht die Bundles und startet neu. Ist der Ordner
//   nicht beschreibbar, wird die DMG nur geöffnet (manuell ziehen).
// Automatik: prüft beim Start nur; Herunterladen + Installieren startet
// immer erst der Nutzer (User-Wunsch 2026-10-03).
// ---------------------------------------------------------------------------

const _repo = 'Walfrosch92/Mealie-Recipes-APP';
const _teamId = 'Q84VVPH7B3';
const _kAutoUpdate = 'desktopAutoUpdate';
const _kPendingPath = 'desktopPendingUpdatePath';
const _kPendingVersion = 'desktopPendingUpdateVersion';
const _kLastCheck = 'desktopLastUpdateCheck';

final RegExp _assetPattern = Platform.isMacOS
    ? RegExp(r'^MealieRecipes-(\d+\.\d+\.\d+)-arm64\.dmg$')
    : RegExp(r'^MealieRecipes-(\d+\.\d+\.\d+)-windows-setup\.exe$');

class AppRelease {
  final String version;
  final String name;
  final String notes;
  final String? publishedAt;
  final String htmlUrl;
  final String assetName;
  final String assetUrl;
  final int assetSize;

  const AppRelease({
    required this.version,
    required this.name,
    required this.notes,
    required this.publishedAt,
    required this.htmlUrl,
    required this.assetName,
    required this.assetUrl,
    required this.assetSize,
  });
}

/// -1 / 0 / 1 wie compareTo; nur „x.y.z" (Rest ignoriert).
int compareVersions(String a, String b) {
  List<int> parts(String v) => v
      .split(RegExp(r'[^0-9]+'))
      .where((s) => s.isNotEmpty)
      .take(3)
      .map(int.parse)
      .toList();
  final pa = parts(a), pb = parts(b);
  for (var i = 0; i < 3; i++) {
    final x = i < pa.length ? pa[i] : 0;
    final y = i < pb.length ? pb[i] : 0;
    if (x != y) return x.compareTo(y);
  }
  return 0;
}

enum UpdateStatus {
  idle,
  checking,
  upToDate,
  available,
  downloading,
  ready,
  installing,
  manual,
  error,
}

class UpdateState {
  final UpdateStatus status;
  final String? currentVersion;
  final AppRelease? release;
  final double progress;
  final Object? error;
  final DateTime? lastCheck;

  const UpdateState({
    this.status = UpdateStatus.idle,
    this.currentVersion,
    this.release,
    this.progress = 0,
    this.error,
    this.lastCheck,
  });

  UpdateState copyWith({
    UpdateStatus? status,
    String? currentVersion,
    AppRelease? release,
    double? progress,
    Object? error,
    DateTime? lastCheck,
  }) =>
      UpdateState(
        status: status ?? this.status,
        currentVersion: currentVersion ?? this.currentVersion,
        release: release ?? this.release,
        progress: progress ?? this.progress,
        error: error,
        lastCheck: lastCheck ?? this.lastCheck,
      );
}

final appUpdateProvider =
    NotifierProvider<AppUpdateNotifier, UpdateState>(AppUpdateNotifier.new);

/// Beim Start automatisch nach Updates suchen (Standard an).
final autoUpdateEnabledProvider =
    AsyncNotifierProvider<AutoUpdateSetting, bool>(AutoUpdateSetting.new);

class AutoUpdateSetting extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async =>
      (await SharedPreferences.getInstance()).getBool(_kAutoUpdate) ?? true;

  Future<void> set(bool value) async {
    await (await SharedPreferences.getInstance()).setBool(_kAutoUpdate, value);
    state = AsyncData(value);
  }
}

class AppUpdateNotifier extends Notifier<UpdateState> {
  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Accept': 'application/vnd.github+json',
      'User-Agent': 'MealieRecipes-Desktop',
    },
  ));
  String? _pendingPath;
  bool _autoRan = false;

  @override
  UpdateState build() {
    Future.microtask(_init);
    return const UpdateState();
  }

  Future<void> _init() async {
    final info = await PackageInfo.fromPlatform();
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getString(_kLastCheck);
    state = state.copyWith(
        currentVersion: info.version,
        lastCheck: last == null ? null : DateTime.tryParse(last));
  }

  Future<String> _current() async =>
      state.currentVersion ?? (await PackageInfo.fromPlatform()).version;

  /// Neuestes passendes Release (oder null, wenn keins mit Asset).
  Future<AppRelease?> _fetchLatest() async {
    final resp = await _dio.get('https://api.github.com/repos/$_repo/releases',
        queryParameters: {'per_page': 20});
    AppRelease? best;
    for (final r in (resp.data as List? ?? const [])) {
      if (r is! Map || r['draft'] == true || r['prerelease'] == true) continue;
      for (final a in (r['assets'] as List? ?? const [])) {
        if (a is! Map) continue;
        final m = _assetPattern.firstMatch(a['name']?.toString() ?? '');
        if (m == null) continue;
        final rel = AppRelease(
          version: m.group(1)!,
          name: (r['name']?.toString().trim().isNotEmpty ?? false)
              ? r['name'].toString()
              : r['tag_name']?.toString() ?? m.group(1)!,
          notes: r['body']?.toString() ?? '',
          publishedAt: r['published_at']?.toString(),
          htmlUrl: r['html_url']?.toString() ?? '',
          assetName: a['name'].toString(),
          assetUrl: a['browser_download_url'].toString(),
          assetSize: (a['size'] as num?)?.toInt() ?? 0,
        );
        if (best == null || compareVersions(rel.version, best.version) > 0) {
          best = rel;
        }
      }
    }
    return best;
  }

  /// Prüfen; liefert true, wenn ein neueres Release existiert.
  Future<bool> check() async {
    if (!PlatformFeatures.webAppTools) return false;
    state = state.copyWith(status: UpdateStatus.checking);
    try {
      final current = await _current();
      final latest = await _fetchLatest();
      final now = DateTime.now();
      await (await SharedPreferences.getInstance())
          .setString(_kLastCheck, now.toIso8601String());
      if (latest == null || compareVersions(latest.version, current) <= 0) {
        state = state.copyWith(
            status: UpdateStatus.upToDate,
            currentVersion: current,
            lastCheck: now);
        return false;
      }
      state = UpdateState(
          status: UpdateStatus.available,
          currentVersion: current,
          release: latest,
          lastCheck: now);
      return true;
    } catch (e) {
      LogManager.shared.log('⬆️ Update-Prüfung fehlgeschlagen: $e');
      state = state.copyWith(status: UpdateStatus.error, error: e);
      return false;
    }
  }

  /// Release herunterladen (in den App-Support-Ordner, überlebt Neustarts).
  Future<bool> download() async {
    final rel = state.release;
    if (rel == null) return false;
    state = state.copyWith(status: UpdateStatus.downloading, progress: 0);
    try {
      final dir =
          Directory('${(await getApplicationSupportDirectory()).path}/updates');
      if (await dir.exists()) await dir.delete(recursive: true);
      await dir.create(recursive: true);
      final path = '${dir.path}/${rel.assetName}';
      await _dio.download(
        rel.assetUrl,
        path,
        options: Options(receiveTimeout: const Duration(minutes: 15)),
        onReceiveProgress: (got, total) {
          final t = total > 0 ? total : rel.assetSize;
          if (t > 0) state = state.copyWith(progress: got / t);
        },
      );
      if (rel.assetSize > 0 && await File(path).length() != rel.assetSize) {
        throw const FileSystemException('Download incomplete');
      }
      _pendingPath = path;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kPendingPath, path);
      await prefs.setString(_kPendingVersion, rel.version);
      state = state.copyWith(status: UpdateStatus.ready, progress: 1);
      return true;
    } catch (e) {
      LogManager.shared.log('⬆️ Update-Download fehlgeschlagen: $e');
      state = state.copyWith(status: UpdateStatus.error, error: e);
      return false;
    }
  }

  /// Installieren und App neu starten. Kehrt nur zurück, wenn es nicht
  /// automatisch ging (dann Status [UpdateStatus.manual] bzw. error).
  Future<void> install() async {
    final path = _pendingPath ??
        (await SharedPreferences.getInstance()).getString(_kPendingPath);
    if (path == null || !await File(path).exists()) return;
    state = state.copyWith(status: UpdateStatus.installing);
    try {
      await _clearPending(keepFile: true);
      if (Platform.isWindows) {
        await Process.start(
          path,
          const ['/VERYSILENT', '/SUPPRESSMSGBOXES', '/NORESTART', '/SP-'],
          mode: ProcessStartMode.detached,
        );
        exit(0);
      }
      if (Platform.isMacOS) {
        final done = await _installMac(path);
        if (done) exit(0);
        state = state.copyWith(status: UpdateStatus.manual);
      }
    } catch (e) {
      LogManager.shared.log('⬆️ Update-Installation fehlgeschlagen: $e');
      state = state.copyWith(status: UpdateStatus.error, error: e);
    }
  }

  /// Beim App-Start (Automatik an): NUR prüfen — installiert wird erst,
  /// wenn der Nutzer zustimmt (User-Wunsch). true = neueres Release da.
  Future<bool> autoRun() async {
    if (!PlatformFeatures.webAppTools || _autoRan) return false;
    _autoRan = true;
    // Reste eines früheren Downloads/Installers aufräumen.
    await _clearPending();
    try {
      final dir =
          Directory('${(await getApplicationSupportDirectory()).path}/updates');
      if (await dir.exists()) await dir.delete(recursive: true);
    } catch (_) {}
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool(_kAutoUpdate) ?? true)) return false;
    return check();
  }

  Future<void> _clearPending({bool keepFile = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(_kPendingPath);
    await prefs.remove(_kPendingPath);
    await prefs.remove(_kPendingVersion);
    if (!keepFile && path != null) {
      try {
        await File(path).delete();
      } catch (_) {}
    }
  }

  // ── macOS ────────────────────────────────────────────────────────────────

  Future<bool> _installMac(String dmgPath) async {
    // …/Mealie Recipes.app/Contents/MacOS/Mealie Recipes → Bundle-Pfad.
    final appPath = File(Platform.resolvedExecutable).parent.parent.parent.path;
    final parent = Directory(appPath).parent.path;
    final translocated = appPath.contains('/AppTranslocation/') ||
        appPath.startsWith('/Volumes/');
    if (!appPath.endsWith('.app') || translocated || !await _writable(parent)) {
      // Nicht selbst ersetzbar (z. B. aus der DMG gestartet oder Ordner
      // ohne Schreibrecht) → DMG öffnen, Nutzer zieht die App selbst.
      await Process.run('/usr/bin/open', [dmgPath]);
      return false;
    }

    final work = await Directory.systemTemp.createTemp('mealie-update');
    final mount = '${work.path}/mnt';
    await Directory(mount).create();
    final attach = await Process.run('/usr/bin/hdiutil', [
      'attach', '-nobrowse', '-readonly', '-noautoopen', //
      '-mountpoint', mount, dmgPath,
    ]);
    if (attach.exitCode != 0) {
      throw ProcessException('hdiutil', const [], '${attach.stderr}');
    }
    try {
      final newApp = '$mount/Mealie Recipes.app';
      if (!await Directory(newApp).exists()) {
        throw const FileSystemException('App not found in DMG');
      }
      // Nur von uns signierte Builds installieren.
      final verify = await Process.run(
          '/usr/bin/codesign', ['--verify', '--deep', '--strict', newApp]);
      final info = await Process.run(
          '/usr/bin/codesign', ['-dv', '--verbose=2', newApp]);
      if (verify.exitCode != 0 ||
          !'${info.stderr}${info.stdout}'.contains('TeamIdentifier=$_teamId')) {
        throw const FileSystemException('Signature check failed');
      }
      final stage = '$parent/.Mealie Recipes.app.update';
      await Process.run('/bin/rm', ['-rf', stage]);
      final copy = await Process.run('/usr/bin/ditto', [newApp, stage]);
      if (copy.exitCode != 0) {
        throw ProcessException('ditto', const [], '${copy.stderr}');
      }
    } finally {
      await Process.run('/usr/bin/hdiutil', ['detach', mount, '-quiet']);
    }

    // Tausch erst, wenn diese App beendet ist; bei Fehler alte App zurück.
    final script = File('${work.path}/swap.sh');
    await script.writeAsString(r'''#!/bin/bash
PID="$1"; APP="$2"; STAGE="$3"; DMG="$4"
for _ in $(seq 1 300); do kill -0 "$PID" 2>/dev/null || break; sleep 0.2; done
OLD="$APP.old-$$"
if mv "$APP" "$OLD"; then
  if mv "$STAGE" "$APP"; then rm -rf "$OLD"; else mv "$OLD" "$APP"; fi
fi
rm -f "$DMG"
open "$APP"
rm -rf "$(dirname "$0")"
''');
    await Process.start(
      '/bin/bash',
      [
        script.path,
        '$pid',
        appPath,
        '$parent/.Mealie Recipes.app.update',
        dmgPath
      ],
      mode: ProcessStartMode.detached,
    );
    return true;
  }

  Future<bool> _writable(String dir) async {
    try {
      final probe = File('$dir/.mealie-write-test-$pid');
      await probe.writeAsString('');
      await probe.delete();
      return true;
    } catch (_) {
      return false;
    }
  }
}
