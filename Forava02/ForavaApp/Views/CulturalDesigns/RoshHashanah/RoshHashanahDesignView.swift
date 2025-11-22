import SwiftUI
import Foundation

struct RoshHashanahDesignView: View, CulturalDesignViewProtocol {
    // MARK: - Protocol Requirements
    typealias CulturalTheme = RoshHashanahTheme
    typealias CulturalElement = RoshHashanahElement
    typealias CulturalColorPalette = RoshHashanahColorPalette
    typealias CulturalPersonalTouch = RoshHashanahPersonalTouch

    // MARK: - Content View Types
    typealias StyleContent = RoshHashanahStyleSelectionView
    typealias ElementsContent = RoshHashanahElementsSelectionView
    typealias ColorContent = RoshHashanahColorPaletteView
    typealias TouchContent = RoshHashanahPersonalTouchView
    typealias CreateContent = RoshHashanahCreateSummaryView
    typealias CheckContent = RoshHashanahCheckImageView
    typealias SendContent = RoshHashanahSendShareView
    typealias ConnectContent = RoshHashanahConnectView

    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    // MARK: - State Management
    @State var currentTab: GiftDesignTab = .style
    @State var selectedTheme: RoshHashanahTheme?
    @State var selectedElements: [RoshHashanahElement] = []
    @State var selectedColorPalette: RoshHashanahColorPalette?
    @State var selectedMessage: RoshHashanahPersonalTouch?
    @State var personalMessage: String = ""

    // MARK: - Additional State
    @State private var isGenerating = false
    @State private var generatedImages: [String: String] = [:] // Keys: "iPhone", "Apple Watch"
    @State private var showingShareSheet = false
    @State private var showAgeRestrictionAlert = false
    @StateObject private var roshHashanahAI = RoshHashanahAIService.shared
    @EnvironmentObject var ageVerification: AgeVerification
    @State private var hasGeneratedOnce = false // Track if first (free) generation completed
    @State private var showPurchaseSheet = false // Show IAP purchase dialog
    @State private var showPaywall = false // Show hard paywall when quota exhausted
    @StateObject private var paymentService = ComprehensivePaymentService.shared
    @StateObject private var quotaManager = GenerationQuotaManager.shared

    var body: some View {
        VStack(spacing: 0) {
            // Cultural Header
            ModularCulturalHeaderView(
                selectedContact: selectedContact,
                selectedEvent: selectedEvent
            )

            // Tab Navigation
            ModularCulturalTabNavigationView(
                currentTab: $currentTab,
                culturalColor: culturalColor
            )

            // Tab Content - Direct view switching (no TabView to avoid iOS "More" navigation)
            ZStack {
                if currentTab == .style {
                    styleContent()
                        .transition(.opacity)
                } else if currentTab == .elements {
                    elementsContent()
                        .transition(.opacity)
                } else if currentTab == .colour {
                    colorContent()
                        .transition(.opacity)
                } else if currentTab == .touch {
                    touchContent()
                        .transition(.opacity)
                } else if currentTab == .create {
                    createContent()
                        .transition(.opacity)
                } else if currentTab == .check {
                    checkContent()
                        .transition(.opacity)
                } else if currentTab == .send {
                    sendContent()
                        .transition(.opacity)
                } else if currentTab == .connect {
                    connectContent()
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.3), value: currentTab)
        }
        .navigationTitle("Rosh Hashanah Design")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(.hidden, for: .bottomBar)
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea([])
        .alert("Age Restriction", isPresented: $showAgeRestrictionAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You must be \(AgeVerification.minimumAge) or older to use AI generation features. If you believe this is an error, please contact support.")
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView(paymentService: paymentService, quotaManager: quotaManager)
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheetView(
                generatedImages: generatedImages,
                personalMessage: finalMessage
            )
        }
    }

    // MARK: - Computed Properties
    private var isReadyToGenerate: Bool {
        let hasTheme = selectedTheme != nil
        let hasElements = !selectedElements.isEmpty
        let hasColorPalette = selectedColorPalette != nil
        let hasMessage = selectedMessage != nil || !personalMessage.isEmpty

        // Enhanced validation logging for debugging
        if !hasTheme { print("⚠️ Tab 1 (Style): No theme selected") }
        if !hasElements { print("⚠️ Tab 2 (Elements): No elements selected") }
        if !hasColorPalette { print("⚠️ Tab 3 (Colour): No color palette selected") }
        if !hasMessage { print("⚠️ Tab 4 (Touch): No message entered") }

        return hasTheme && hasElements && hasColorPalette && hasMessage
    }

    private var selectedElementsDescription: String {
        if selectedElements.isEmpty {
            return "No elements selected"
        }
        return selectedElements.map { $0.name }.joined(separator: ", ")
    }

    private var finalMessage: String {
        if !personalMessage.isEmpty {
            return personalMessage
        }
        return selectedMessage?.message ?? "No message selected"
    }
}

// MARK: - Protocol Implementation
extension RoshHashanahDesignView {
    @ViewBuilder func styleContent() -> StyleContent {
        RoshHashanahStyleSelectionView(
            selectedTheme: $selectedTheme,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func elementsContent() -> ElementsContent {
        RoshHashanahElementsSelectionView(
            selectedElements: $selectedElements,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func colorContent() -> ColorContent {
        RoshHashanahColorPaletteView(
            selectedColorPalette: $selectedColorPalette,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func touchContent() -> TouchContent {
        RoshHashanahPersonalTouchView(
            selectedMessage: $selectedMessage,
            personalMessage: $personalMessage,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func createContent() -> CreateContent {
        RoshHashanahCreateSummaryView(
            selectedTheme: selectedTheme,
            selectedElements: selectedElements,
            selectedColorPalette: selectedColorPalette,
            finalMessage: finalMessage,
            isReadyToGenerate: isReadyToGenerate,
            culturalColor: culturalColor,
            onGenerate: {
                generateRoshHashanahGift()
            }
        )
    }

    @ViewBuilder func checkContent() -> CheckContent {
        RoshHashanahCheckImageView(
            generatedImages: generatedImages,
            personalMessage: finalMessage,
            isGenerating: $isGenerating,
            culturalColor: culturalColor,
            hasGeneratedOnce: hasGeneratedOnce,
            paymentService: paymentService,
            isFreeTier: !paymentService.isSubscribed,
            onRegenerate: {
                regenerateWithCreditCheck()
            }
        )
    }

    @ViewBuilder func sendContent() -> SendContent {
        RoshHashanahSendShareView(
            generatedImages: generatedImages,
            personalMessage: finalMessage,
            selectedContact: selectedContact,
            culturalColor: culturalColor,
            showingShareSheet: $showingShareSheet,
            onGoBackToGenerate: {
                currentTab = .create
            }
        )
    }

    @ViewBuilder func connectContent() -> ConnectContent {
        RoshHashanahConnectView(
            selectedContact: selectedContact,
            culturalColor: culturalColor
        )
    }

    // MARK: - Generation Logic
    private func generateRoshHashanahGift() {
        print("🎯 Generate Rosh Hashanah Gift button tapped")

        // COMPLIANCE: Apple Guideline 1.2.1 - Age gate for AI-generated content
        guard ageVerification.canAccessAIGeneration() else {
            print("❌ Age verification failed - user is underage")
            showAgeRestrictionAlert = true
            return
        }

                // MONETIZATION: Check free quota (3 generations lifetime)
        if !paymentService.isSubscribed && !hasGeneratedOnce {
            // First-time generation - check free quota
            if !quotaManager.hasFreeQuota() {
                print("❌ Free quota exhausted - showing paywall")
                showPaywall = true
                return
            }
        }

print("=" + String(repeating: "=", count: 79))
        print("📊 ALL TAB SELECTIONS - USER PREFERENCES:")
        print("=" + String(repeating: "=", count: 79))
        print("Tab 1 - THEME: \(selectedTheme?.rawValue ?? "❌ NOT SELECTED")")
        print("Tab 2 - ELEMENTS (\(selectedElements.count)): \(selectedElements.map { $0.name }.joined(separator: ", "))")
        print("Tab 3 - COLOR PALETTE: \(selectedColorPalette?.name ?? "❌ NOT SELECTED")")
        if let colors = selectedColorPalette {
            print("        PRIMARY: \(colors.primaryColor)")
            print("        SECONDARY: \(colors.secondaryColor)")
            print("        ACCENT: \(colors.accentColor)")
        }
        print("Tab 4 - MESSAGE: \(finalMessage)")
        print("=" + String(repeating: "=", count: 79))

        guard isReadyToGenerate else {
            print("❌ Not ready to generate - validation failed")
            return
        }

        print("✅ Starting Rosh Hashanah generation...")
        isGenerating = true
        currentTab = .check

        Task {
            do {
                // Get selected element (single element selection)
                let selectedElement = selectedElements.first

                // Generate iPhone background (tall format - no text in AI)
                print("📱 Generating iPhone background...")
                let iPhoneResult = try await roshHashanahAI.generateRoshHashanahGift(
                    theme: selectedTheme!,
                    element: selectedElement,
                    colorPalette: selectedColorPalette!,
                    message: "", // No text in AI - will overlay natively
                    contactName: selectedContact.name
                )
                print("✅ iPhone background generated: \(iPhoneResult)")

                // Generate Apple Watch background (square format - no text in AI)
                print("⌚ Generating Apple Watch background...")
                let watchResult = try await roshHashanahAI.generateRoshHashanahGift(
                    theme: selectedTheme!,
                    element: selectedElement,
                    colorPalette: selectedColorPalette!,
                    message: "", // No text in AI - will overlay natively
                    contactName: selectedContact.name,
                    format: .appleWatch // Specify Watch format for square dimensions
                )
                print("✅ Apple Watch background generated: \(watchResult)")

                await MainActor.run {
                    self.generatedImages["iPhone"] = iPhoneResult
                    self.generatedImages["Apple Watch"] = watchResult  // Match enum rawValue with space
                    self.isGenerating = false
                                        // MONETIZATION: Use free quota if not subscribed and first generation
                    if !self.paymentService.isSubscribed && !self.hasGeneratedOnce {
                        self.quotaManager.useFreeGeneration()
                        print("📊 Free quota used. Remaining: \(self.quotaManager.quotaRemaining)")
                    }

                    self.hasGeneratedOnce = true  // Mark first generation as complete
                }
            } catch {
                print("❌ Generation failed with error: \(error)")
                await MainActor.run {
                    self.isGenerating = false
                    // Handle error appropriately
                    print("💥 Error details: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Regeneration with IAP
    private func regenerateWithCreditCheck() {
        print("🔄 Regenerate requested")

        // First generation is free, subsequent ones require credits
        if hasGeneratedOnce {
            // Check if user has credits
            if paymentService.hasRegenerationCredits() {
                // Use a credit and regenerate
                let success = paymentService.useRegenerationCredit(for: "Rosh Hashanah")
                if success {
                    print("✅ Credit used for Rosh Hashanah regeneration")
                    generateRoshHashanahGift()
                } else {
                    print("❌ Failed to use credit")
                }
            } else {
                // No credits available - show purchase sheet
                print("⚠️ No credits available - showing purchase dialog")
                showPurchaseSheet = true
            }
        } else {
            // First generation is free
            print("✅ First generation - free")
            generateRoshHashanahGift()
        }
    }
}
