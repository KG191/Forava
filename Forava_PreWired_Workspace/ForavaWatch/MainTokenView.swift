import SwiftUI

struct MainTokenView: View {
    @EnvironmentObject var viewModel: TokenSessionViewModel
    @StateObject private var watchConnectivity = WatchConnectivityManager.shared
    @StateObject private var terminologyService = DynamicCulturalTerminologyService.shared
    @State private var receivedGifts: [RakhiGift] = []
    @State private var showingGiftDetail = false
    @State private var selectedGift: RakhiGift?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if !receivedGifts.isEmpty {
                    // Cultural Gift View
                    VStack(spacing: 12) {
                        Text("\(terminologyService.shortGiftTerm)s")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.orange)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(receivedGifts) { gift in
                                    RakhiMiniCard(rakhi: gift) {
                                        selectedGift = gift
                                        showingGiftDetail = true
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                } else if let token = viewModel.activeToken {
                    ReceiveTokenView(token: token)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "gift.circle")
                            .font(.system(size: 40))
                            .foregroundStyle(.orange.opacity(0.6))

                        Text("Waiting for \(terminologyService.shortGiftTerm)")
                            .font(.headline.weight(.medium))
                            .foregroundStyle(.primary)

                        Text("\(terminologyService.shortGiftTerm)s sent from iPhone will appear here")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        Button("Load Sample") {
                            loadSampleGift()
                        }
                        .font(.caption)
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
            .onAppear {
                setupWatchConnectivity()
            }
        }
        .sheet(isPresented: $showingGiftDetail) {
            if let selectedGift = selectedGift {
                RakhiWatchFaceView(rakhi: selectedGift)
            }
        }
    }

    private func setupWatchConnectivity() {
        // Listen for incoming gifts from iPhone
        watchConnectivity.onRakhiReceived = { gift in
            DispatchQueue.main.async {
                receivedGifts.append(gift)
            }
        }
    }

    private func loadSampleGift() {
        let sampleGift = RakhiGift(
            rakhi: Rakhi(
                name: "Sample Traditional \(terminologyService.shortGiftTerm)",
                imageName: "rakhi_sample",
                description: "A beautiful traditional rakhi",
                price: 25.0,
                category: .traditional,
                colors: ["Gold", "Red"]
            ),
            sender: "Sample Sender",
            recipient: "You",
            sentDate: Date(),
            status: .received,
            paymentAmount: nil,
            message: terminologyService.culturalBlessing
        )

        receivedGifts.append(sampleGift)
    }
}

struct RakhiMiniCard: View {
    let rakhi: RakhiGift
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.orange.opacity(0.3), .red.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)

                    Image(systemName: "gift.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.orange)
                }

                VStack(spacing: 2) {
                    Text(rakhi.sender)
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Circle()
                        .fill(statusColor)
                        .frame(width: 4, height: 4)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var statusColor: Color {
        switch rakhi.status {
        case .sent:
            return .orange
        case .received:
            return .blue
        case .paid:
            return .green
        case .completed:
            return .purple
        }
    }
}
