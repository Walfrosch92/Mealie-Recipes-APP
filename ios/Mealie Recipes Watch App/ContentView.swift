import SwiftUI

// Haupt-UI der watchOS-App — zwei sich AUSSCHLIESSENDE Ansichten:
//   • Kochmodus aktiv (`conn.cooking.active`): laufende/pausierte Timer
//     wischbar (ein Timer pro Seite, TabView) + Vor/Zurück-Buttons für den
//     Kochschritt (größer, wenn kein Timer läuft — mehr Platz frei). KEINE
//     Einkaufsliste (kein Timer ohne Kochmodus möglich, siehe Dart
//     TimerNotifier — die Buttons erscheinen also immer zusammen mit einem
//     evtl. laufenden Timer oder allein).
//   • Kein Kochmodus: Einkaufsliste als 1:1-Kopie der Phone-Shopping-List-View
//     (farbige Kategorie-Header, einklappbar, abhakbare Artikel, „Erledigt"-
//     Sektion) — ohne Artikel-Hinzufügen und an die Uhrgröße angepasst.
//
// Design: spiegelt das Premium-Redesign der Phone-App — warmes Dunkel,
// Orange-Verlaufs-Akzent, runde Karten, fette gerundete Typografie.

// MARK: - Design-Tokens (1:1 zur Phone-App AppTokens / AppColors)

enum WTheme {
    static let accent = Color(hex6: "FF8A00")
    static let accentDeep = Color(hex6: "FF6A00")
    static let accentLight = Color(hex6: "FFB23E")
    static let bg = Color(hex6: "0E0C0A")
    static let card = Color(hex6: "1A1714")
    static let surface2 = Color(hex6: "262019")
    static let fg = Color(hex6: "F5F1EA")
    static let fgSub = Color(hex6: "A89F92")
    static let separator = Color.white.opacity(0.08)

    static let accentGradient = LinearGradient(
        colors: [Color(hex6: "FFB23E"), Color(hex6: "FF8A00"), Color(hex6: "FF6A00")],
        startPoint: .topLeading, endPoint: .bottomTrailing
    )
}

struct ContentView: View {
    @EnvironmentObject var conn: ConnectivityManager

    var body: some View {
        Group {
            if conn.cooking.active {
                CookingNavView(cooking: conn.cooking, timers: conn.timers)
            } else {
                ShoppingListView()
            }
        }
        .navigationTitle("Mealie")
        .tint(WTheme.accent)
    }
}

// MARK: - Kochmodus: Timer-Wischer + Vor/Zurück

private struct CookingNavView: View {
    let cooking: WatchCookingState
    let timers: [WatchTimer]

    var body: some View {
        VStack(spacing: 10) {
            if !timers.isEmpty {
                TabView {
                    ForEach(timers) { t in
                        TimerRow(timer: t)
                            .padding(.horizontal, 4)
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 148)
            }
            StepNavButtons(cooking: cooking, big: timers.isEmpty)
                .frame(maxHeight: .infinity)
        }
        .padding(.horizontal, 6)
        .padding(.top, timers.isEmpty ? 0 : 4)
        .background(WTheme.bg.ignoresSafeArea())
    }
}

/// Vor/Zurück-Buttons für den aktuellen Kochschritt — Pendant zu den
/// `_NavSquare`-Pfeilen der Phone-App (ohne den mittleren „Erledigt"/„Weiter"-
/// Button, der ist hier bewusst weggelassen: die Uhr navigiert nur, das
/// Abhaken bleibt am Handy). `big` (kein Timer sichtbar) vergrößert sie.
private struct StepNavButtons: View {
    let cooking: WatchCookingState
    let big: Bool
    @EnvironmentObject var conn: ConnectivityManager

    var body: some View {
        HStack(spacing: big ? 20 : 14) {
            StepButton(
                systemName: "chevron.left",
                enabled: cooking.canBack,
                size: big ? 64 : 46
            ) { conn.sendStepAction("previous") }
            StepButton(
                systemName: "chevron.right",
                enabled: cooking.canNext,
                size: big ? 64 : 46
            ) { conn.sendStepAction("next") }
        }
    }
}

private struct StepButton: View {
    let systemName: String
    let enabled: Bool
    let size: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: size * 0.4, weight: .bold))
                .foregroundStyle(enabled ? .white : WTheme.fgSub.opacity(0.5))
                .frame(width: size, height: size)
                .background(
                    Circle().fill(
                        enabled
                            ? AnyShapeStyle(WTheme.accentGradient)
                            : AnyShapeStyle(WTheme.card.opacity(0.5))
                    )
                )
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
    }
}

// MARK: - Einkaufsliste (kein Kochmodus aktiv)

private struct ShoppingListView: View {
    @EnvironmentObject var conn: ConnectivityManager
    @State private var collapsed: Set<String> = []

    private var open: [WatchShoppingItem] { conn.shopping.filter { !$0.checked } }
    private var done: [WatchShoppingItem] { conn.shopping.filter { $0.checked } }

    /// Kategorien in Erscheinungsreihenfolge (Name + Farbe). Das iPhone sortiert
    /// die Items bereits wie die Shopping-List-View.
    private var orderedCategories: [CatGroup] {
        var seen = Set<String>()
        var out: [CatGroup] = []
        for it in open where !seen.contains(it.category) {
            seen.insert(it.category)
            out.append(CatGroup(name: it.category, color: it.categoryColor))
        }
        return out
    }

    private func toggle(_ key: String) {
        if collapsed.contains(key) { collapsed.remove(key) } else { collapsed.insert(key) }
    }

    var body: some View {
        let lang = conn.language
        List {
            if conn.shopping.isEmpty {
                Text(WatchL10n.t("shoppingEmpty", lang))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(WTheme.fgSub)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(orderedCategories) { cat in
                    let items = open.filter { $0.category == cat.name }
                    CategoryHeader(
                        title: cat.name.isEmpty ? WatchL10n.t("uncategorized", lang) : cat.name,
                        colorHex: cat.color,
                        count: items.count,
                        collapsed: collapsed.contains(cat.name)
                    ) { toggle(cat.name) }
                    .listRowBackground(Color.clear)

                    if !collapsed.contains(cat.name) {
                        ForEach(items) { ShoppingRowView(item: $0) }
                    }
                }

                if !done.isEmpty {
                    CategoryHeader(
                        title: WatchL10n.t("completed", lang),
                        colorHex: "",
                        count: done.count,
                        collapsed: collapsed.contains("__done__")
                    ) { toggle("__done__") }
                    .listRowBackground(Color.clear)

                    if !collapsed.contains("__done__") {
                        ForEach(done) { ShoppingRowView(item: $0) }
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(WTheme.bg.ignoresSafeArea())
    }
}

private struct CatGroup: Identifiable {
    let name: String
    let color: String
    var id: String { name }
}

// Farbiger, einklappbarer Kategorie-Header — spiegelt den categoryHeaderChip
// der Phone-View (gefüllte Kapsel in Kategorie-Farbe, Text schwarz/weiß je
// nach Helligkeit, Count-Badge, Chevron).
private struct CategoryHeader: View {
    let title: String
    let colorHex: String
    let count: Int
    let collapsed: Bool
    let onTap: () -> Void

    var body: some View {
        let bg = colorHex.isEmpty ? WTheme.surface2 : Color(hex6: colorHex)
        let fg = colorHex.isEmpty ? WTheme.fg : textColorOn(colorHex)
        Button(action: onTap) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(fg)
                    .lineLimit(1)
                Spacer(minLength: 0)
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(fg)
                        .padding(5)
                        .background(Circle().fill(fg.opacity(0.18)))
                }
                Image(systemName: collapsed ? "chevron.down" : "chevron.up")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(fg.opacity(0.85))
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 12, style: .continuous).fill(bg))
        }
        .buttonStyle(.plain)
        .listRowInsets(EdgeInsets(top: 3, leading: 2, bottom: 1, trailing: 2))
    }
}

private struct ShoppingRowView: View {
    let item: WatchShoppingItem
    @EnvironmentObject var conn: ConnectivityManager

    var body: some View {
        Button {
            conn.sendShoppingToggle(item.id)
        } label: {
            HStack(spacing: 10) {
                if item.checked {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(WTheme.accentDeep)
                } else {
                    Image(systemName: "circle")
                        .font(.system(size: 18))
                        .foregroundStyle(WTheme.fgSub)
                }
                Text(item.text)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .strikethrough(item.checked)
                    .foregroundStyle(item.checked ? WTheme.fgSub : WTheme.fg)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(WTheme.card)
            )
        }
        .buttonStyle(.plain)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
    }
}

private struct TimerRow: View {
    let timer: WatchTimer
    @EnvironmentObject var conn: ConnectivityManager
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 6) {
            Text(timer.name)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(WTheme.fgSub)
                .lineLimit(1)

            // Sekundengenauer Countdown ohne manuellen Timer — TimelineView
            // rendert jede Sekunde neu und rechnet die Restzeit aus endMillis.
            // `.id(...)` mit scenePhase + endMillis: watchOS friert die UI im
            // Hintergrund ein und die periodic-Schedule (from: .now) re-ankert
            // beim Zurückkommen nicht zuverlässig → Countdown wirkte „hängend".
            // Beim Wechsel nach .active (oder neuem Timer) wird die TimelineView
            // neu erzeugt → frische Anker-Zeit → sofort korrekter Countdown.
            TimelineView(.periodic(from: .now, by: 1)) { ctx in
                let text = Text(timer.displayTime(ctx.date))
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .monospacedDigit()
                if timer.isPaused {
                    text.foregroundStyle(WTheme.fgSub)
                } else {
                    text.foregroundStyle(WTheme.accentGradient)
                }
            }
            .id("\(timer.id)-\(timer.endMillis)-\(scenePhase)")

            HStack(spacing: 12) {
                Button {
                    conn.sendAction(timer.isPaused ? "resume" : "pause", id: timer.id)
                } label: {
                    Image(systemName: timer.isPaused ? "play.fill" : "pause.fill")
                        .foregroundStyle(WTheme.fg)
                }
                .buttonStyle(.borderless)
                .frame(width: 40, height: 40)
                .background(Circle().fill(WTheme.surface2))

                Button {
                    conn.sendAction("stop", id: timer.id)
                } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.borderless)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color(hex6: "E53935")))
            }
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(WTheme.card)
        )
        .padding(.vertical, 2)
    }
}

// MARK: - Farb-Helfer (Hex RRGGBB)

extension Color {
    init(hex6 hex: String) {
        let s = hex.trimmingCharacters(in: CharacterSet(charactersIn: " #"))
        var v: UInt64 = 0
        Scanner(string: s).scanHexInt64(&v)
        self = Color(
            red: Double((v & 0xFF0000) >> 16) / 255.0,
            green: Double((v & 0x00FF00) >> 8) / 255.0,
            blue: Double(v & 0x0000FF) / 255.0
        )
    }
}

/// Schwarz/weiß je nach Helligkeit — 1:1 zu `_brightness` der Phone-View
/// (0.299·r + 0.587·g + 0.114·b, Threshold 0.5).
private func textColorOn(_ hex: String) -> Color {
    let s = hex.trimmingCharacters(in: CharacterSet(charactersIn: " #"))
    var v: UInt64 = 0
    Scanner(string: s).scanHexInt64(&v)
    let r = Double((v & 0xFF0000) >> 16) / 255.0
    let g = Double((v & 0x00FF00) >> 8) / 255.0
    let b = Double(v & 0x0000FF) / 255.0
    let brightness = 0.299 * r + 0.587 * g + 0.114 * b
    return brightness < 0.5 ? .white : Color.black.opacity(0.85)
}
