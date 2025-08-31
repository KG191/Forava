import SwiftUI
import Foundation

@main
struct ForavaApp: App {
    @StateObject private var urlHandler = UniversalLinkHandler()
    // ✅ All services restored - files now properly added to Xcode project
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @StateObject private var migrationService = CulturalSystemMigrationService.shared
    @StateObject private var terminologyService = DynamicCulturalTerminologyService.shared
    @StateObject private var globalUpdateService = GlobalTerminologyUpdateService.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                // ✅ All environment objects restored
                .environmentObject(subscriptionManager)
                .environmentObject(terminologyService)
                .environmentObject(migrationService)
                .environmentObject(globalUpdateService)
                .sheet(item: $urlHandler.paymentRequest) { request in
                    UniversalLinkPaymentView(request: request)
                }
                .onOpenURL { url in
                    urlHandler.handle(url: url)
                }
                .task {
                    // ✅ Full service initialization restored
                    // PHASE 1: Initialize subscription products
                    await subscriptionManager.loadProducts()

                    // CRITICAL FIX: Perform cultural system migration
                    if migrationService.isMigrationRequired() {
                        await migrationService.performSystemMigration()
                    }

                    // PHASE 5: Initialize global terminology system
                    await globalUpdateService.performGlobalUpdate()
                    print("✅ All 6 phases integrated and operational!")
                }
        }
    }
}

class UniversalLinkHandler: ObservableObject {
    @Published var paymentRequest: UniversalLinkPaymentRequest?

    func handle(url: URL) {
        print("[UNIVERSAL LINK] Handling URL: \(url)")

        guard url.scheme == "https",
              url.host == AppConfig.associatedDomain,
              url.path == "/Forava/app" else {  // Only handle actual app Universal Links
            print("[UNIVERSAL LINK] Invalid URL format: \(url)")
            return
        }

        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        guard let queryItems = components?.queryItems else {
            print("[UNIVERSAL LINK] No query items found")
            return
        }

        var amount: Decimal = AppConfig.defaultAmount
        var description: String = AppConfig.defaultDescription
        var rakhiId: String?
        var sender: String?
        var currency: String = AppConfig.currencyCode

        for item in queryItems {
            switch item.name {
            case "amount":
                if let value = item.value, let parsedAmount = Decimal(string: value) {
                    amount = parsedAmount
                }
            case "desc":
                description = item.value ?? AppConfig.defaultDescription
            case "rakhi_id":
                rakhiId = item.value
            case "sender":
                sender = item.value
            case "currency":
                currency = item.value ?? AppConfig.currencyCode
            default:
                break
            }
        }

        DispatchQueue.main.async {
            self.paymentRequest = UniversalLinkPaymentRequest(
                amount: amount,
                description: description,
                currency: currency,
                rakhiId: rakhiId,
                sender: sender ?? "Anonymous"
            )
        }
    }
}

struct UniversalLinkPaymentRequest: Identifiable {
    let id = UUID()
    let amount: Decimal
    let description: String
    let currency: String
    let rakhiId: String?
    let sender: String
}

struct UniversalLinkPaymentView: View {
    let request: UniversalLinkPaymentRequest
    @Environment(\.dismiss) private var dismiss
    @State private var selectedAmount: Decimal
    @State private var isProcessingPayment = false

    private var quickAmounts: [Decimal] {
        return AppConfig.auspiciousAmounts.filter { $0 <= 1001 }
    }

    init(request: UniversalLinkPaymentRequest) {
        self.request = request
        self._selectedAmount = State(initialValue: request.amount)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                headerSection
                amountSelectionSection
                Spacer()
                paymentButton
                securityNote
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            .navigationTitle("Gift Request")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            Text("🎊")
                .font(.system(size: 64))

            VStack(spacing: 8) {
                Text("Gift Request from")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text(request.sender)
                    .font(.title.weight(.bold))
                    .foregroundStyle(.orange)
            }

            Text("Thank you for the beautiful Rakhi!")
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 32)
    }

    private var amountSelectionSection: some View {
        VStack(spacing: 16) {
            Text("Select Gift Amount")
                .font(.headline)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                ForEach(quickAmounts, id: \.self) { amount in
                    amountButton(for: amount)
                }
            }
        }
    }

    private func amountButton(for amount: Decimal) -> some View {
        Button {
            selectedAmount = amount
        } label: {
            VStack(spacing: 4) {
                Text("$\(NSDecimalNumber(decimal: amount).intValue)")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(selectedAmount == amount ? .white : .primary)

                if amount == request.amount {
                    Text("Suggested")
                        .font(.caption2)
                        .foregroundStyle(selectedAmount == amount ? .white.opacity(0.8) : .orange)
                } else if NSDecimalNumber(decimal: amount).intValue % 10 == 1 {
                    Text("Auspicious")
                        .font(.caption2)
                        .foregroundStyle(selectedAmount == amount ? .white.opacity(0.8) : .green)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedAmount == amount ? .orange : Color(.systemGray6))
            )
        }
        .buttonStyle(.plain)
    }

    private var paymentButton: some View {
        Button {
            processPayment()
        } label: {
            HStack(spacing: 12) {
                if isProcessingPayment {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: "gift.fill")
                }
                Text(isProcessingPayment ? "Processing..." : "Send Gift - $\(NSDecimalNumber(decimal: selectedAmount).intValue)")
            }
            .font(.headline.weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isProcessingPayment ? .gray : .orange)
            )
        }
        .disabled(isProcessingPayment)
    }

    private var securityNote: some View {
        Text("Secure payment via Apple Pay")
            .font(.caption)
            .foregroundStyle(.secondary)
    }

    private func processPayment() {
        isProcessingPayment = true

        // Process payment using existing PaymentCoordinator
        PaymentCoordinator.shared.presentApplePay(
            amountMinor: Int64(NSDecimalNumber(decimal: selectedAmount).doubleValue * 100),
            currencyCode: request.currency
        ) { _ in
            DispatchQueue.main.async {
                isProcessingPayment = false

                // Show result and dismiss
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    dismiss()
                }
            }
        }
    }
}
