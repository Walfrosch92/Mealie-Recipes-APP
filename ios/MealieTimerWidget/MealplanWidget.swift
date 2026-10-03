import WidgetKit
import SwiftUI

// 1:1 Port aus der Swift-Vorgängerversion (`Mealie_Recipes_Widget.swift`),
// in die Flutter-MealieTimerWidget-Extension verschoben.

// MARK: - Timeline Entry

struct MealplanTimelineEntry: TimelineEntry {
    let date: Date
    let todayMeals: [WidgetMealEntry]
    let tomorrowMeals: [WidgetMealEntry]
    let formattedToday: String
    let formattedTomorrow: String
    let l10n: WidgetL10n
}

// MARK: - Provider

struct MealplanProvider: TimelineProvider {

    func placeholder(in context: Context) -> MealplanTimelineEntry {
        makeEntry(placeholder: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (MealplanTimelineEntry) -> Void) {
        completion(makeEntry(placeholder: context.isPreview))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MealplanTimelineEntry>) -> Void) {
        Task {
            await WidgetServerSync.refreshMealplan()
            let entry = makeEntry(placeholder: false)
            // Stündlich vom Server, spätestens um Mitternacht („Heute"/„Morgen"
            // wechseln).
            let midnight = Calendar.current.startOfDay(
                for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
            )
            let hourly = Date().addingTimeInterval(60 * 60)
            completion(Timeline(entries: [entry], policy: .after(min(midnight, hourly))))
        }
    }

    private func makeEntry(placeholder: Bool) -> MealplanTimelineEntry {
        let now = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
        let todayStr = WidgetSharedStore.dateString(from: now)
        let tomorrowStr = WidgetSharedStore.dateString(from: tomorrow)
        let l10n = WidgetL10n()
        let allMeals = placeholder ? sampleMeals(for: todayStr) : WidgetSharedStore.loadMealplan()

        return MealplanTimelineEntry(
            date: now,
            todayMeals: WidgetSharedStore.entriesForDateString(todayStr, from: allMeals),
            tomorrowMeals: WidgetSharedStore.entriesForDateString(tomorrowStr, from: allMeals),
            formattedToday: formatDate(now),
            formattedTomorrow: formatDate(tomorrow),
            l10n: l10n
        )
    }

    private func formatDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEE, d. MMM"
        f.locale = Locale.current
        return f.string(from: date)
    }

    private func sampleMeals(for dateStr: String) -> [WidgetMealEntry] {
        [
            WidgetMealEntry(date: dateStr, slot: "breakfast", slotName: "Frühstück",   recipeName: "Porridge",        recipeId: nil),
            WidgetMealEntry(date: dateStr, slot: "lunch",     slotName: "Mittagessen",  recipeName: "Pasta Bolognese", recipeId: nil),
            WidgetMealEntry(date: dateStr, slot: "dinner",    slotName: "Abendessen",   recipeName: "Gemüsesuppe",     recipeId: nil),
        ]
    }
}

// MARK: - Slot Row

struct MealSlotRow: View {
    let meal: WidgetMealEntry

    var slotIcon: String {
        switch meal.slot {
        case "breakfast": return "sun.rise.fill"
        case "lunch":     return "fork.knife"
        case "dinner":    return "moon.stars.fill"
        default:          return "circle.fill"
        }
    }

    var slotColor: Color {
        switch meal.slot {
        case "breakfast": return .orange
        case "lunch":     return .green
        case "dinner":    return .indigo
        default:          return .gray
        }
    }

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: slotIcon)
                .font(.caption2)
                .foregroundColor(slotColor)
                .frame(width: 14)
            Text(meal.recipeName)
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Tappable Slot Row

struct MealSlotLinkRow: View {
    let meal: WidgetMealEntry

    private var recipeURL: URL? {
        guard let id = meal.recipeId else { return nil }
        return URL(string: "mealierecipes://recipe?id=\(id)")
    }

    var body: some View {
        if let url = recipeURL {
            Link(destination: url) { MealSlotRow(meal: meal) }
        } else {
            MealSlotRow(meal: meal)
        }
    }
}

// MARK: - Small View

struct MealplanSmallView: View {
    let entry: MealplanTimelineEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 4) {
                Image(systemName: "fork.knife.circle.fill")
                    .font(.caption2)
                    .foregroundColor(.orange)
                Text(entry.l10n.s("today"))
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            if entry.todayMeals.isEmpty {
                Spacer(minLength: 0)
                Text(entry.l10n.s("nothing_planned"))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer(minLength: 0)
            } else {
                ForEach(entry.todayMeals.prefix(3), id: \.slot) { MealSlotLinkRow(meal: $0) }
                Spacer(minLength: 0)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Medium View

struct MealplanMediumView: View {
    let entry: MealplanTimelineEntry

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            dayColumn(label: entry.l10n.s("today"),    subLabel: entry.formattedToday,    meals: entry.todayMeals,    accent: .orange)
            Divider().padding(.horizontal, 10)
            dayColumn(label: entry.l10n.s("tomorrow"), subLabel: entry.formattedTomorrow, meals: entry.tomorrowMeals, accent: .blue)
        }
        .padding(14)
    }

    @ViewBuilder
    private func dayColumn(label: String, subLabel: String, meals: [WidgetMealEntry], accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            VStack(alignment: .leading, spacing: 1) {
                Text(label).font(.caption.weight(.bold)).foregroundColor(accent)
                Text(subLabel).font(.caption2).foregroundColor(.secondary)
            }
            if meals.isEmpty {
                Text(entry.l10n.s("nothing_planned")).font(.caption2).foregroundColor(.secondary)
            } else {
                ForEach(meals, id: \.slot) { MealSlotLinkRow(meal: $0) }
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

// MARK: - Large View

struct MealplanLargeView: View {
    let entry: MealplanTimelineEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "fork.knife.circle.fill").font(.body).foregroundColor(.orange)
                Text(entry.l10n.s("meal_plan")).font(.headline)
            }
            Divider().padding(.vertical, 10)
            daySection(label: entry.l10n.s("today"),    subLabel: entry.formattedToday,    meals: entry.todayMeals,    accent: .orange)
            Divider().padding(.vertical, 10)
            daySection(label: entry.l10n.s("tomorrow"), subLabel: entry.formattedTomorrow, meals: entry.tomorrowMeals, accent: .blue)
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    private func daySection(label: String, subLabel: String, meals: [WidgetMealEntry], accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text(label).font(.subheadline.weight(.semibold)).foregroundColor(accent)
                Text(subLabel).font(.caption).foregroundColor(.secondary)
            }
            if meals.isEmpty {
                Text(entry.l10n.s("no_meals")).font(.caption).foregroundColor(.secondary).padding(.leading, 4)
            } else {
                ForEach(meals, id: \.slot) { meal in
                    largeMealRow(meal: meal)
                }
            }
        }
    }

    @ViewBuilder
    private func largeMealRow(meal: WidgetMealEntry) -> some View {
        let content = HStack {
            MealSlotRow(meal: meal)
            Spacer(minLength: 0)
            Text(meal.slotName).font(.caption2).foregroundColor(.secondary)
        }
        .padding(.leading, 4)

        if let id = meal.recipeId, let url = URL(string: "mealierecipes://recipe?id=\(id)") {
            Link(destination: url) { content }
        } else {
            content
        }
    }
}

// MARK: - Entry View

struct MealplanWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: MealplanTimelineEntry

    var body: some View {
        switch family {
        case .systemSmall: MealplanSmallView(entry: entry)
        case .systemLarge: MealplanLargeView(entry: entry)
        default:           MealplanMediumView(entry: entry)
        }
    }
}

// MARK: - Widget Declaration

struct MealplanWidget: Widget {
    let kind: String = "MealplanWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MealplanProvider()) { entry in
            MealplanWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .widgetURL(URL(string: "mealierecipes://mealplan"))
        }
        .configurationDisplayName(WidgetL10n().s("meal_plan"))
        .description(WidgetL10n().s("desc_mealplan"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
