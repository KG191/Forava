import SwiftUI
import Foundation

struct AnniversaryDesignView: View, CulturalDesignViewProtocol {
    // MARK: - Protocol Requirements
    typealias CulturalTheme = AnniversaryTheme
    typealias CulturalElement = AnniversaryElement
    typealias CulturalColorPalette = AnniversaryColorPalette
    typealias CulturalPersonalTouch = AnniversaryPersonalTouch

    // MARK: - Content View Types
    typealias StyleContent = AnniversaryStyleSelectionView
    typealias ElementsContent = AnniversaryElementsSelectionView
    typealias ColorContent = AnniversaryColorPaletteView
    typealias TouchContent = AnniversaryPersonalTouchView
    typealias CreateContent = AnniversaryCreateSummaryView
    typealias CheckContent = AnniversaryCheckImageView
    typealias SendContent = AnniversarySendShareView

    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    // MARK: - State Management
    @State var currentTab: GiftDesignTab = .style
    @State var selectedTheme: AnniversaryTheme?
    @State var selectedGiftOption: String?
    @State var selectedElements: [AnniversaryElement] = []
    @State var selectedColorPalette: AnniversaryColorPalette?
    @State var selectedMessage: AnniversaryPersonalTouch?
    @State var personalMessage: String = ""

    // MARK: - Additional State
    @State private var isGenerating = false
    @State private var generatedImages: [String: String] = [:] // Keys: "iPhone", "AppleWatch"
    @State private var showingShareSheet = false
    @StateObject private var anniversaryAI = AnniversaryAIService.shared

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
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.3), value: currentTab)
        }
        .navigationTitle("Anniversary Design")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .toolbar(.hidden, for: .tabBar)
        .toolbarBackground(.hidden, for: .bottomBar)
        .background(Color(.systemGroupedBackground))
        .edgesIgnoringSafeArea([])
    }

    // MARK: - Computed Properties
    private var isReadyToGenerate: Bool {
        let hasTheme = selectedTheme != nil
        let hasGiftOption = selectedGiftOption != nil
        let hasElements = !selectedElements.isEmpty
        let hasColorPalette = selectedColorPalette != nil
        let hasMessage = selectedMessage != nil || !personalMessage.isEmpty

        // Enhanced validation logging for debugging
        if !hasTheme { print("⚠️ Tab 1 (Style): No theme selected") }
        if !hasGiftOption { print("⚠️ Tab 1 (Style): No gift option selected") }
        if !hasElements { print("⚠️ Tab 2 (Elements): No elements selected") }
        if !hasColorPalette { print("⚠️ Tab 3 (Colour): No color palette selected") }
        if !hasMessage { print("⚠️ Tab 4 (Touch): No message entered") }

        return hasTheme && hasGiftOption && hasElements && hasColorPalette && hasMessage
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
extension AnniversaryDesignView {
    @ViewBuilder func styleContent() -> StyleContent {
        AnniversaryStyleSelectionView(
            selectedTheme: $selectedTheme,
            selectedGiftOption: $selectedGiftOption,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func elementsContent() -> ElementsContent {
        AnniversaryElementsSelectionView(
            selectedElements: $selectedElements,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func colorContent() -> ColorContent {
        AnniversaryColorPaletteView(
            selectedColorPalette: $selectedColorPalette,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func touchContent() -> TouchContent {
        AnniversaryPersonalTouchView(
            selectedMessage: $selectedMessage,
            personalMessage: $personalMessage,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func createContent() -> CreateContent {
        AnniversaryCreateSummaryView(
            selectedTheme: selectedTheme,
            selectedGiftOption: selectedGiftOption,
            selectedElements: selectedElements,
            selectedColorPalette: selectedColorPalette,
            finalMessage: finalMessage,
            isReadyToGenerate: isReadyToGenerate,
            culturalColor: culturalColor,
            onGenerate: {
                generateAnniversaryGift()
            }
        )
    }

    @ViewBuilder func checkContent() -> CheckContent {
        AnniversaryCheckImageView(
            generatedImages: generatedImages,
            personalMessage: finalMessage,
            isGenerating: $isGenerating,
            culturalColor: culturalColor,
            onRegenerate: {
                generateAnniversaryGift()
            }
        )
    }

    @ViewBuilder func sendContent() -> SendContent {
        AnniversarySendShareView(
            generatedImages: generatedImages,
            personalMessage: finalMessage,
            selectedContact: selectedContact,
            culturalColor: culturalColor,
            showingShareSheet: $showingShareSheet
        )
    }

    // MARK: - Generation Logic
    private func generateAnniversaryGift() {
        print("🎯 Generate Anniversary Gift button tapped")
        print("=" + String(repeating: "=", count: 79))
        print("📊 ALL TAB SELECTIONS - USER PREFERENCES:")
        print("=" + String(repeating: "=", count: 79))
        print("Tab 1 - THEME: \(selectedTheme?.rawValue ?? "❌ NOT SELECTED")")
        print("Tab 1 - GIFT OPTION: \(selectedGiftOption ?? "❌ NOT SELECTED")")
        print("Tab 2 - ELEMENTS (\(selectedElements.count)): \(selectedElements.map { $0.name }.joined(separator: ", "))")
        print("Tab 3 - COLOR PALETTE: \(selectedColorPalette?.name ?? "❌ NOT SELECTED")")
        if let colors = selectedColorPalette {
            print("        PRIMARY: \(colors.primaryColorName) (\(colors.primaryColor))")
            print("        SECONDARY: \(colors.secondaryColorName) (\(colors.secondaryColor))")
            print("        ACCENT: \(colors.accentColorName) (\(colors.accentColor))")
        }
        print("Tab 4 - MESSAGE: \(finalMessage)")
        print("=" + String(repeating: "=", count: 79))

        guard isReadyToGenerate else {
            print("❌ Not ready to generate - validation failed")
            return
        }

        print("✅ Starting Anniversary generation...")
        isGenerating = true
        currentTab = .check

        Task {
            do {
                // Generate iPhone background (tall format - no text in AI)
                print("📱 Generating iPhone background...")
                let iPhoneResult = try await anniversaryAI.generateAnniversaryGift(
                    theme: selectedTheme!,
                    giftOption: selectedGiftOption,
                    elements: selectedElements,
                    colorPalette: selectedColorPalette!,
                    message: "", // No text in AI - will overlay natively
                    contactName: selectedContact.name
                )
                print("✅ iPhone background generated: \(iPhoneResult)")

                // Generate Apple Watch background (square format - no text in AI)
                print("⌚ Generating Apple Watch background...")
                let watchResult = try await anniversaryAI.generateAnniversaryGift(
                    theme: selectedTheme!,
                    giftOption: selectedGiftOption,
                    elements: selectedElements,
                    colorPalette: selectedColorPalette!,
                    message: "", // No text in AI - will overlay natively
                    contactName: selectedContact.name,
                    format: .appleWatch // Specify Watch format for square dimensions
                )
                print("✅ Apple Watch background generated: \(watchResult)")

                await MainActor.run {
                    self.generatedImages["iPhone"] = iPhoneResult
                    self.generatedImages["AppleWatch"] = watchResult
                    self.isGenerating = false
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
}
