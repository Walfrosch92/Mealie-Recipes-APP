// Hosts, deren Links fast immer Rezeptvideos sind (Kurzvideos/Reels).
// Genutzt vom Import-Screen (KI-Schalter automatisch an) und vom KI-Import
// auf Servern < 3.23: Videos laufen dort über /create/url, weil nur dieser
// Weg transkribiert — die erzwungene KI-Seitenanalyse läse bloß den Seitentext.
// Ob der Server ein Video wirklich laden kann, entscheidet er selbst (yt-dlp).
final _videoHost = RegExp(
  r'(^|\.)(youtube\.com|youtu\.be|instagram\.com|tiktok\.com|'
  r'facebook\.com|fb\.watch|vimeo\.com|twitch\.tv|dailymotion\.com)$',
);

bool looksLikeVideoUrl(String text) {
  final host = Uri.tryParse(text.trim())?.host.toLowerCase() ?? '';
  return host.isNotEmpty && _videoHost.hasMatch(host);
}
