import SwiftUI
import WidgetKit

@main
struct MealieTimerWidgetBundle: WidgetBundle {
    var body: some Widget {
        // Home-Screen-Widgets — 1:1 Port aus der Swift-Vorgängerversion.
        MealplanWidget()
        ShoppingListWidget()
        DailyRecipeWidget()

        if #available(iOS 16.1, *) {
            TimerLiveActivity()
        }
    }
}
