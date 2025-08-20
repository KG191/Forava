import SwiftUI

struct MainTokenView: View {
    @EnvironmentObject var vm: TokenSessionViewModel
    @StateObject private var watchConnectivity = WatchConnectivityManager.shared
    @State private var receivedRakhis: [RakhiGift] = []
    @State private var showingRakhiDetail = false
    @State private var selectedRakhi: RakhiGift?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if !receivedRakhis.isEmpty {
                    // Rakhi View
                    VStack(spacing: 12) {
                        Text("Rakhi Gifts")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.orange)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(receivedRakhis) { rakhi in
                                    RakhiMiniCard(rakhi: rakhi) {
                                        selectedRakhi = rakhi
                                        showingRakhiDetail = true
                                    }
                                }
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                } else if let token = vm.activeToken {
                    ReceiveTokenView(token: token)
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "gift.circle")
                            .font(.system(size: 40))
                            .foregroundStyle(.orange.opacity(0.6))
                        
                        Text("Waiting for Rakhi")
                            .font(.headline.weight(.medium))
                            .foregroundStyle(.primary)
                        
                        Text("Rakhis sent from iPhone will appear here")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Load Sample") { 
                            loadSampleRakhi()
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
        .sheet(isPresented: $showingRakhiDetail) {
            if let selectedRakhi = selectedRakhi {
                RakhiWatchFaceView(rakhi: selectedRakhi)
            }
        }
    }
    
    private func setupWatchConnectivity() {
        // Listen for incoming Rakhis from iPhone
        watchConnectivity.onRakhiReceived = { rakhi in
            DispatchQueue.main.async {
                receivedRakhis.append(rakhi)
            }
        }
    }
    
    private func loadSampleRakhi() {
        let sampleRakhi = RakhiGift(
            rakhi: Rakhi(
                name: "Sample Traditional Rakhi",
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
            message: "Happy Raksha Bandhan!"
        )
        
        receivedRakhis.append(sampleRakhi)
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
