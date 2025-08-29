import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Onboarding & Apple Pay Setup", destination: OnboardingView())
                NavigationLink("Settings", destination: SettingsView())
            }
            .navigationTitle("RakhiConnect")
        }
    }
}
