import SwiftUI

@main
struct ForavaApp: App {
    @StateObject private var preferences = CulturePreferencesManager()

    var body: some Scene {
        WindowGroup {
            if preferences.isFirstLaunch() {
                WelcomeView()
                    .environmentObject(preferences)
            } else {
                ContentView()
                    .environmentObject(preferences)
            }
        }
    }
}
