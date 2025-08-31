import SwiftUI

struct ReceiveTokenView: View {
    @EnvironmentObject var viewModel: TokenSessionViewModel
    let token: RitualToken

    var body: some View {
        VStack(spacing: 6) {
            Circle().strokeBorder(style: .init(lineWidth: 3)).overlay(Text("∞").font(.largeTitle))
                .frame(height: 80)

            if let msg = token.message {
                Text(msg).font(.footnote).multilineTextAlignment(.center)
            }

            GiftKindPicker(kind: $viewModel.kind)
            GiftAmountPickerView(amountMinor: $viewModel.amountMinor)

            Button("Tap to Gift") { viewModel.sendGiftRequest() }
                .buttonStyle(.borderedProminent)

            if !viewModel.statusMessage.isEmpty {
                Text(viewModel.statusMessage).font(.footnote)
            }
        }
        .padding()
    }
}

struct GiftKindPicker: View {
    @Binding var kind: GiftKind
    var body: some View {
        Picker("Gift Type", selection: $kind) {
            ForEach(GiftKind.allCases) { giftKind in
                Text(giftKind.displayName).tag(giftKind)
            }
        }
    }
}
