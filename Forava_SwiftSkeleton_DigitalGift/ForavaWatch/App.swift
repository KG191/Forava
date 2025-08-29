import SwiftUI

@main
struct ForavaWatchApp: App {
    @StateObject var sessionVM = TokenSessionViewModel()
    var body: some Scene {
        WindowGroup { MainTokenView().environmentObject(sessionVM) }
    }
}
