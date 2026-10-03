import SwiftUI
import WidgetKit
#if canImport(ActivityKit)
import ActivityKit

@available(iOS 16.1, *)
struct TimerLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock-screen / banner view (auch die Darstellung im Apple-Watch-
            // Smart-Stack). Tap-Ziel via widgetURL: auf der Uhr startet watchOS
            // bei vorhandener Watch-App diese (sonst die iPhone-App), auf dem
            // iPhone routet `mealierecipes://timer` in den Kochmodus.
            LockScreenView(state: context.state)
                .activityBackgroundTint(Color.black.opacity(0.85))
                .activitySystemActionForegroundColor(.white)
                .widgetURL(URL(string: "mealierecipes://timer"))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "timer")
                        .foregroundColor(.orange)
                        .font(.title2)
                        .padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    if context.state.isPaused {
                        Text("Pause")
                            .font(.title3.bold())
                            .foregroundColor(.orange)
                            .padding(.trailing, 4)
                    } else {
                        Text(timerInterval: Date()...context.state.endDate,
                             countsDown: true)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)
                            .frame(minWidth: 70)
                            .padding(.trailing, 4)
                    }
                }
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .center, spacing: 2) {
                        Text(context.state.timerName)
                            .font(.headline)
                            .foregroundColor(.white)
                            .lineLimit(1)
                        Text(context.state.recipeName)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    if context.state.extraCount > 0 {
                        Text("+ \(context.state.extraCount) weitere Timer")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            } compactLeading: {
                Image(systemName: "timer")
                    .foregroundColor(.orange)
            } compactTrailing: {
                if context.state.isPaused {
                    Image(systemName: "pause.fill").foregroundColor(.orange)
                } else {
                    Text(timerInterval: Date()...context.state.endDate,
                         countsDown: true,
                         showsHours: false)
                        .monospacedDigit()
                        .frame(maxWidth: 50)
                }
            } minimal: {
                Image(systemName: "timer").foregroundColor(.orange)
            }
            .keylineTint(.orange)
        }
    }
}

@available(iOS 16.1, *)
private struct LockScreenView: View {
    let state: TimerActivityAttributes.TimerState

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "timer")
                .font(.system(size: 28))
                .foregroundColor(.orange)
            VStack(alignment: .leading, spacing: 2) {
                Text(state.timerName)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(state.recipeName)
                    .font(.caption)
                    .foregroundColor(.gray)
                if state.extraCount > 0 {
                    Text("+ \(state.extraCount) weitere Timer")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            if state.isPaused {
                Text("Pause")
                    .font(.title2.bold())
                    .foregroundColor(.orange)
            } else {
                Text(timerInterval: Date()...state.endDate, countsDown: true)
                    .monospacedDigit()
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: 90)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
#endif
