import WidgetKit
import SwiftUI

// 1:1 Port aus der Swift-Vorgängerversion (`DailyRecipeWidget.swift`).

// MARK: - Timeline Entry

struct DailyRecipeEntry: TimelineEntry {
    let date: Date
    let recipe: WidgetRecipeSummary?
    let l10n: WidgetL10n
}

// MARK: - Provider

struct DailyRecipeProvider: TimelineProvider {

    func placeholder(in context: Context) -> DailyRecipeEntry {
        DailyRecipeEntry(date: Date(), recipe: sampleRecipe, l10n: WidgetL10n())
    }

    func getSnapshot(in context: Context, completion: @escaping (DailyRecipeEntry) -> Void) {
        let recipe = context.isPreview ? sampleRecipe : WidgetSharedStore.dailyRecipe()
        completion(DailyRecipeEntry(date: Date(), recipe: recipe, l10n: WidgetL10n()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DailyRecipeEntry>) -> Void) {
        let recipe = WidgetSharedStore.dailyRecipe()
        let entry = DailyRecipeEntry(date: Date(), recipe: recipe, l10n: WidgetL10n())
        // Reload um Mitternacht — Tagesindex wechselt, neues Rezept des Tages.
        let midnight = Calendar.current.startOfDay(
            for: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        )
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }

    private var sampleRecipe: WidgetRecipeSummary {
        WidgetRecipeSummary(
            id: "sample",
            name: "Pasta Bolognese",
            description: "Ein klassisches italienisches Pastagericht mit Hackfleisch-Tomatensauce.",
            category: "Hauptgericht"
        )
    }
}

// MARK: - Small View

struct DailyRecipeSmallView: View {
    let entry: DailyRecipeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.caption2)
                    .foregroundColor(.orange)
                Text(entry.l10n.s("daily_recipe"))
                    .font(.caption2.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            if let recipe = entry.recipe {
                Text(recipe.name)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(3)
                    .foregroundColor(.primary)
                if let category = recipe.category {
                    Text(category)
                        .font(.caption2)
                        .foregroundColor(.orange)
                }
            } else {
                Text(entry.l10n.s("no_recipes"))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Medium View

struct DailyRecipeMediumView: View {
    let entry: DailyRecipeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: "sparkles")
                    .font(.caption)
                    .foregroundColor(.orange)
                Text(entry.l10n.s("daily_recipe"))
                    .font(.caption.weight(.semibold))
                    .foregroundColor(.secondary)
            }
            if let recipe = entry.recipe {
                Text(recipe.name)
                    .font(.headline)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                if let desc = recipe.description, !desc.isEmpty {
                    Text(desc)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
                Spacer(minLength: 0)
                if let category = recipe.category {
                    Text(category)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange.opacity(0.15))
                        .foregroundColor(.orange)
                        .cornerRadius(4)
                }
            } else {
                Spacer(minLength: 0)
                Text(entry.l10n.s("no_recipes"))
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer(minLength: 0)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Large View

struct DailyRecipeLargeView: View {
    let entry: DailyRecipeEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "sparkles")
                    .font(.body)
                    .foregroundColor(.orange)
                Text(entry.l10n.s("daily_recipe"))
                    .font(.headline)
            }
            Divider().padding(.vertical, 10)
            if let recipe = entry.recipe {
                Text(recipe.name)
                    .font(.title3.weight(.bold))
                    .lineLimit(2)
                    .padding(.bottom, 8)
                if let desc = recipe.description, !desc.isEmpty {
                    Text(desc)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(6)
                }
                Spacer(minLength: 0)
                if let category = recipe.category {
                    Text(category)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.orange.opacity(0.15))
                        .foregroundColor(.orange)
                        .cornerRadius(6)
                }
            } else {
                Spacer(minLength: 0)
                Text(entry.l10n.s("no_recipes"))
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer(minLength: 0)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Entry View

struct DailyRecipeEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: DailyRecipeEntry

    private var recipeURL: URL? {
        guard let id = entry.recipe?.id else { return nil }
        return URL(string: "mealierecipes://recipe?id=\(id)")
    }

    var body: some View {
        Group {
            switch family {
            case .systemSmall: DailyRecipeSmallView(entry: entry)
            case .systemLarge: DailyRecipeLargeView(entry: entry)
            default:           DailyRecipeMediumView(entry: entry)
            }
        }
        .widgetURL(recipeURL)
    }
}

// MARK: - Widget Declaration

struct DailyRecipeWidget: Widget {
    let kind: String = "DailyRecipeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DailyRecipeProvider()) { entry in
            DailyRecipeEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName(WidgetL10n().s("daily_recipe"))
        .description(WidgetL10n().s("desc_daily"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
