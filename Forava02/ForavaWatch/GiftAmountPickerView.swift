import SwiftUI

struct GiftAmountPickerView: View {
    @Binding var amountMinor: Int64
    var body: some View {
        Picker("Amount", selection: $amountMinor) {
            ForEach(Constants.defaultAmountPresetsMinor, id: \.self) { minor in
                Text(MoneyFormat.string(minor: minor, currency: Constants.defaultCurrency)).tag(minor)
            }
        }
    }
}
