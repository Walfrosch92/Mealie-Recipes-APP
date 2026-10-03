import WidgetKit
import SwiftUI

// 1:1 Port aus der Swift-Vorgängerversion (`ShoppingListWidget.swift`).

// MARK: - Timeline Entry

struct ShoppingTimelineEntry: TimelineEntry {
    let date: Date
    let items: [WidgetShoppingItem]
    let l10n: WidgetL10n

    var unchecked: [WidgetShoppingItem] { items.filter { !$0.checked } }
    var uncheckedCount: Int { unchecked.count }
}

// MARK: - Provider

struct ShoppingProvider: TimelineProvider {

    func placeholder(in context: Context) -> ShoppingTimelineEntry {
        ShoppingTimelineEntry(date: Date(), items: sampleItems, l10n: WidgetL10n())
    }

    func getSnapshot(in context: Context, completion: @escaping (ShoppingTimelineEntry) -> Void) {
        let items = context.isPreview ? sampleItems : WidgetSharedStore.loadShoppingItems()
        completion(ShoppingTimelineEntry(date: Date(), items: items, l10n: WidgetL10n()))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ShoppingTimelineEntry>) -> Void) {
        Task {
            // Selbst beim Server nachsehen (Änderungen aus Webapp/anderen
            // Geräten), sonst der zuletzt gespeicherte Stand.
            await WidgetServerSync.refreshShopping()
            let items = WidgetSharedStore.loadShoppingItems()
            let entry = ShoppingTimelineEntry(date: Date(), items: items, l10n: WidgetL10n())
            // Alle 30 min neu — iOS teilt das Kontingent selbst ein.
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }

    private var sampleItems: [WidgetShoppingItem] {
        [
            WidgetShoppingItem(id: "1", name: "Milch",   checked: false, category: nil),
            WidgetShoppingItem(id: "2", name: "Butter",  checked: false, category: nil),
            WidgetShoppingItem(id: "3", name: "Brot",    checked: true,  category: nil),
            WidgetShoppingItem(id: "4", name: "Tomaten", checked: false, category: nil),
            WidgetShoppingItem(id: "5", name: "Eier",    checked: false, category: nil),
        ]
    }
}

// MARK: - Item Row

struct ShoppingItemRow: View {
    let item: WidgetShoppingItem

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: item.checked ? "checkmark.circle.fill" : "circle")
                .font(.caption2)
                .foregroundColor(item.checked ? .green : .secondary)
                .frame(width: 14)
            Text(item.name)
                .font(.caption)
                .foregroundColor(item.checked ? .secondary : .primary)
                .strikethrough(item.checked)
                .lineLimit(1)
        }
    }
}

// MARK: - Small View

struct ShoppingSmallView: View {
    let entry: ShoppingTimelineEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "cart.fill").font(.caption2).foregroundColor(.green)
                Text(entry.l10n.s("shopping")).font(.caption2.weight(.semibold)).foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
            if entry.uncheckedCount == 0 {
                Image(systemName: "checkmark.circle.fill").font(.title2).foregroundColor(.green)
                Text(entry.l10n.s("all_done")).font(.caption2).foregroundColor(.secondary)
            } else {
                Text("\(entry.uncheckedCount)")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.5)
                Text(entry.l10n.s("open"))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Medium View

struct ShoppingMediumView: View {
    let entry: ShoppingTimelineEntry
    private let maxVisible = 5

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Label {
                    Text(entry.l10n.s("shopping_list")).font(.caption.weight(.bold))
                } icon: {
                    Image(systemName: "cart.fill").foregroundColor(.green).font(.caption)
                }
                Spacer()
                if entry.uncheckedCount > 0 {
                    Text("\(entry.uncheckedCount) \(entry.l10n.s("open"))")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(6)
                }
            }

            Divider()

            if entry.items.isEmpty {
                Text(entry.l10n.s("no_items"))
                    .font(.caption).foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if entry.uncheckedCount == 0 {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    Text(entry.l10n.s("all_completed")).font(.caption).foregroundColor(.secondary)
                }
            } else {
                ForEach(entry.unchecked.prefix(maxVisible), id: \.id) { ShoppingItemRow(item: $0) }
                if entry.uncheckedCount > maxVisible {
                    Text("+ \(entry.uncheckedCount - maxVisible) \(entry.l10n.s("more"))")
                        .font(.caption2).foregroundColor(.secondary).padding(.leading, 20)
                }
            }

            Spacer(minLength: 0)
        }
        .padding(14)
    }
}

// MARK: - Large View

struct ShoppingLargeView: View {
    let entry: ShoppingTimelineEntry
    private let maxVisible = 12

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label {
                    Text(entry.l10n.s("shopping_list")).font(.headline)
                } icon: {
                    Image(systemName: "cart.fill").foregroundColor(.green)
                }
                Spacer()
                if entry.uncheckedCount > 0 {
                    Text("\(entry.uncheckedCount) \(entry.l10n.s("open"))")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(6)
                }
            }

            Divider()

            if entry.items.isEmpty {
                Spacer(minLength: 0)
                Text(entry.l10n.s("no_items"))
                    .font(.body).foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer(minLength: 0)
            } else if entry.uncheckedCount == 0 {
                Spacer(minLength: 0)
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green).font(.title2)
                    Text(entry.l10n.s("all_completed")).font(.body).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                Spacer(minLength: 0)
            } else {
                ForEach(entry.unchecked.prefix(maxVisible), id: \.id) { ShoppingItemRow(item: $0) }
                if entry.uncheckedCount > maxVisible {
                    Text("+ \(entry.uncheckedCount - maxVisible) \(entry.l10n.s("more"))")
                        .font(.caption).foregroundColor(.secondary).padding(.leading, 20)
                }
                Spacer(minLength: 0)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Entry View

struct ShoppingWidgetEntryView: View {
    @Environment(\.widgetFamily) var family
    var entry: ShoppingTimelineEntry

    var body: some View {
        switch family {
        case .systemSmall: ShoppingSmallView(entry: entry)
        case .systemLarge: ShoppingLargeView(entry: entry)
        default:           ShoppingMediumView(entry: entry)
        }
    }
}

// MARK: - Widget Declaration

struct ShoppingListWidget: Widget {
    let kind: String = "ShoppingListWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ShoppingProvider()) { entry in
            ShoppingWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .widgetURL(URL(string: "mealierecipes://shopping"))
        }
        .configurationDisplayName(WidgetL10n().s("shopping_list"))
        .description(WidgetL10n().s("desc_shopping"))
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
