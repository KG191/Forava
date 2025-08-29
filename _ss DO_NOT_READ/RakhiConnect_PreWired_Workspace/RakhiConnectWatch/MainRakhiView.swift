import SwiftUI

struct MainRakhiView: View {
    @EnvironmentObject var vm: RakhiSessionViewModel
    var body: some View {
        Group {
            if let rakhi = vm.activeRakhi {
                ReceiveRakhiView(rakhi: rakhi)
            } else {
                VStack(spacing: 8) {
                    Text("No Rakhi Yet").font(.headline)
                    Button("Load Sample") { vm.loadSample() }
                }
            }
        }
    }
}
