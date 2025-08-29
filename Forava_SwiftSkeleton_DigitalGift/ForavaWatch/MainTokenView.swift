import SwiftUI

struct MainTokenView: View {
    @EnvironmentObject var vm: TokenSessionViewModel
    var body: some View {
        Group {
            if let token = vm.activeToken {
                ReceiveTokenView(token: token)
            } else {
                VStack(spacing: 8) {
                    Text("No Token Yet").font(.headline)
                    Button("Load Sample") { vm.loadSample() }
                }
            }
        }
    }
}
