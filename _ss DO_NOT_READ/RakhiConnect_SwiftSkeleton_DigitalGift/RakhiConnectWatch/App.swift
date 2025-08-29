import SwiftUI

@main
struct RakhiConnectWatchApp: App {
    @StateObject var sessionVM = RakhiSessionViewModel()
    var body: some Scene {
        WindowGroup { MainRakhiView().environmentObject(sessionVM) }
    }
}
