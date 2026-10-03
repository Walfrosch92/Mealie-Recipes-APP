import Foundation
#if canImport(ActivityKit)
import ActivityKit

// Shared between the main app (start/update/end the activity) and the
// Widget Extension (render its UI).
@available(iOS 16.1, *)
public struct TimerActivityAttributes: ActivityAttributes {
    public typealias ContentState = TimerState

    public struct TimerState: Codable, Hashable {
        public let timerName: String
        public let recipeName: String
        public let endDate: Date          // absolute end-time, used by Text(timerInterval:)
        public let totalSeconds: Int
        public let isPaused: Bool
        public let extraCount: Int        // n other concurrent timers (display "+2" etc.)

        public init(timerName: String,
                    recipeName: String,
                    endDate: Date,
                    totalSeconds: Int,
                    isPaused: Bool,
                    extraCount: Int) {
            self.timerName = timerName
            self.recipeName = recipeName
            self.endDate = endDate
            self.totalSeconds = totalSeconds
            self.isPaused = isPaused
            self.extraCount = extraCount
        }
    }

    public init() {}
}
#endif
