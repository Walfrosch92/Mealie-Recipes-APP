import SwiftUI

// Einstiegspunkt der watchOS-App. Aktiviert die WatchConnectivity-Session
// beim Start, damit der vom iPhone gespiegelte Zustand (Timer + Einkaufsliste)
// sofort empfangen wird.
@main
struct MealieWatchApp: App {
    @StateObject private var connectivity = ConnectivityManager.shared

    init() {
        ConnectivityManager.shared.activate()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(connectivity)
        }
    }
}
