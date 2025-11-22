import SwiftUI
import Foundation

struct EidAlAdhaDesignView: View, CulturalDesignViewProtocol {
    // MARK: - Protocol Requirements
    typealias CulturalTheme = EidAlAdhaTheme
    typealias CulturalElement = EidAlAdhaElement
    typealias CulturalColorPalette = EidAlAdhaColorPalette
    typealias CulturalPersonalTouch = EidAlAdhaPersonalTouch

    // MARK: - Content View Types
    typealias StyleContent = EidAlAdhaStyleSelectionView
    typealias ElementsContent = EidAlAdhaElementsSelectionView
    typealias ColorContent = EidAlAdhaColorPaletteView
    typealias TouchContent = EidAlAdhaPersonalTouchView
    typealias CreateContent = EidAlAdhaCreateSummaryView
    typealias CheckContent = EidAlAdhaCheckImageView
    typealias SendContent = EidAlAdhaSendShareView
    typealias ConnectContent = EidAlAdhaConnectView

    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    // MARK: - State Management
    @State var currentTab: GiftDesignTab = .style
    @State var selectedTheme: EidAlAdhaTheme?
    @State var selectedElements: [EidAlAdhaElement] = []
    @State var selectedColorPalette: EidAlAdhaColorPalette?
    @State var selectedMessage: EidAlAdhaPersonalTouch?
    @State var personalMessage: String = ""

    // MARK: - Additional State
    @State private var isGenerating = false
    @State private var generatedImages: [String: String] = [:] // Keys: "iPhone", "Apple Watch"
    @State private var showingShareSheet = false
    @State private var showAgeRestrictionAlert = false
    @StateObject private var eidAlAdhaAI = EidAlAdhaAIService.shared
    @EnvironmentObject var ageVerification: AgeVerification
    @State private var hasGeneratedOnce = false // Track if first (free) generation completed
    @State private var showPurchaseSheet = false // Show IAP purchase dialog
    @State private var showPaywall = false // Show hard paywall when quota exhausted
    @StateObject private var paymentService = ComprehensivePaymentService.shared
    @StateObject private var quotaManager = GenerationQuotaManager.shared

    var body: some View{
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
        .navigationTitle("EidAlAdha Design")
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
extension EidAlAdhaDesignView {
    @ViewBuilder func styleContent() -> StyleContent {
        EidAlAdhaStyleSelectionView(
            selectedTheme: $selectedTheme,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func elementsContent() -> ElementsContent {
        EidAlAdhaElementsSelectionView(
            selectedElements: $selectedElements,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func colorContent() -> ColorContent {
        EidAlAdhaColorPaletteView(
            selectedColorPalette: $selectedColorPalette,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func touchContent() -> TouchContent {
        EidAlAdhaPersonalTouchView(
            selectedMessage: $selectedMessage,
            personalMessage: $personalMessage,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func createContent() -> CreateContent {
        EidAlAdhaCreateSummaryView(
            selectedTheme: selectedTheme,
            selectedElements: selectedElements,
            selectedColorPalette: selectedColorPalette,
            finalMessage: finalMessage,
            isReadyToGenerate: isReadyToGenerate,
            culturalColor: culturalColor,
            onGenerate: {
                generateEidAlAdhaGift()
            }
        )
    }

    @ViewBuilder func checkContent() -> CheckContent {
        EidAlAdhaCheckImageView(
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
        EidAlAdhaSendShareView(
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
        EidAlAdhaConnectView(
            selectedContact: selectedContact,
            culturalColor: culturalColor
        )
    }

    // MARK: - Generation Logic
    private func generateEidAlAdhaGift() {
        print("🎯 Generate EidAlAdha Gift button tapped")

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
            print("        PRIMARY: \(colors.primaryHex)")
            print("        SECONDARY: \(colors.secondaryHex)")
            print("        ACCENT: \(colors.accentHex)")
            print("        BACKGROUND: \(colors.backgroundHex)")
            print("        AI HINT: \(colors.aiColorHint)")
        }
        print("Tab 4 - MESSAGE: \(finalMessage)")
        print("=" + String(repeating: "=", count: 79))

        guard isReadyToGenerate else {
            print("❌ Cannot generate - missing required selections")
            return
        }

        guard let theme = selectedTheme,
              let primaryElement = selectedElements.first,
              let colorPalette = selectedColorPalette else {
            print("❌ Missing critical generation parameters")
            return
        }

        Task {
            isGenerating = true
            currentTab = .check  // Automatically switch to Check tab

            do {
                print("🎨 Starting EidAlAdha AI generation...")
                print("   Theme: \(theme.rawValue)")
                print("   Primary Element: \(primaryElement.name)")
                print("   Color Palette: \(colorPalette.name)")
                print("   Message: \(finalMessage)")
                print("   Contact: \(selectedContact.name)")

                // Generate iPhone version
                let iPhoneURL = try await eidAlAdhaAI.generateEidAlAdhaGift(
                    theme: theme,
                    element: primaryElement,
                    colorPalette: colorPalette,
                    message: finalMessage,
                    contactName: selectedContact.name,
                    format: .iPhone
                )

                await MainActor.run {
                    generatedImages["iPhone"] = iPhoneURL
                    print("✅ iPhone image generated: \(iPhoneURL)")
                }

                // Generate Apple Watch version
                let watchURL = try await eidAlAdhaAI.generateEidAlAdhaGift(
                    theme: theme,
                    element: primaryElement,
                    colorPalette: colorPalette,
                    message: finalMessage,
                    contactName: selectedContact.name,
                    format: .appleWatch
                )

                await MainActor.run {
                    generatedImages["Apple Watch"] = watchURL  // CRITICAL: Must have space!
                    print("✅ Apple Watch image generated: \(watchURL)")
                    isGenerating = false

                    // MONETIZATION: Use free quota if not subscribed and first generation
                    if !self.paymentService.isSubscribed && !self.hasGeneratedOnce {
                        self.quotaManager.useFreeGeneration()
                        print("📊 Free quota used. Remaining: \(self.quotaManager.quotaRemaining)")
                    }

                    self.hasGeneratedOnce = true  // Mark first generation as complete
                }

                print("🎉 All EidAlAdha images generated successfully!")

            } catch {
                print("❌ EidAlAdha generation failed: \(error.localizedDescription)")
                await MainActor.run {
                    isGenerating = false
                    // TODO: Show error alert to user
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
                let success = paymentService.useRegenerationCredit(for: "Eid Al Adha")
                if success {
                    print("✅ Credit used for Eid Al Adha regeneration")
                    generateEidAlAdhaGift()
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
            generateEidAlAdhaGift()
        }
    }
}
