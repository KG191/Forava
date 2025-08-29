import SwiftUI

struct ReceiveRakhiView: View {
    @EnvironmentObject var vm: RakhiSessionViewModel
    let rakhi: Rakhi

    var body: some View {
        VStack(spacing: 6) {
            Circle().strokeBorder(style: .init(lineWidth: 3)).overlay(Text("🧵").font(.largeTitle))
                .frame(height: 80)

            if let msg = rakhi.message {
                Text(msg).font(.footnote).multilineTextAlignment(.center)
            }

            GiftKindPicker(kind: $vm.kind)
            GiftAmountPickerView(amountMinor: $vm.amountMinor)

            Button("Tap to Gift") { vm.sendGiftRequest() }
                .buttonStyle(.borderedProminent)

            if !vm.statusMessage.isEmpty {
                Text(vm.statusMessage).font(.footnote)
            }
        }
        .padding()
    }
}

struct GiftKindPicker: View {
    @Binding var kind: GiftKind
    var body: some View {
        Picker("Gift Type", selection: $kind) {
            ForEach(GiftKind.allCases) { k in
                Text(k.displayName).tag(k)
            }
        }
    }
}
