import SwiftUI
import Foundation

struct DiwaliDesignView: View, CulturalDesignViewProtocol {
    // MARK: - Protocol Requirements
    typealias CulturalTheme = DiwaliTheme
    typealias CulturalElement = DiwaliElement
    typealias CulturalColorPalette = DiwaliColorPalette
    typealias CulturalPersonalTouch = DiwaliPersonalTouch

    // MARK: - Content View Types
    typealias StyleContent = DiwaliStyleSelectionView
    typealias ElementsContent = DiwaliElementsSelectionView
    typealias ColorContent = DiwaliColorPaletteView
    typealias TouchContent = DiwaliPersonalTouchView
    typealias CreateContent = DiwaliCreateSummaryView
    typealias CheckContent = DiwaliCheckImageView
    typealias SendContent = DiwaliSendShareView
    typealias ConnectContent = DiwaliConnectView

    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    // MARK: - State Management
    @State var currentTab: GiftDesignTab = .style
    @State var selectedTheme: DiwaliTheme?
    @State var selectedElements: [DiwaliElement] = []
    @State var selectedColorPalette: DiwaliColorPalette?
    @State var selectedMessage: DiwaliPersonalTouch?
    @State var personalMessage: String = ""

    // MARK: - Additional State
    @State private var isGenerating = false
    @State private var generatedImages: [String: String] = [:] // Keys: "iPhone", "AppleWatch"
    @State private var showingShareSheet = false
    @StateObject private var chineseNewYearAI = DiwaliAIService.shared

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
        .navigationTitle("Diwali Design")
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
extension DiwaliDesignView {
    @ViewBuilder func styleContent() -> StyleContent {
        DiwaliStyleSelectionView(
            selectedTheme: $selectedTheme,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func elementsContent() -> ElementsContent {
        DiwaliElementsSelectionView(
            selectedElements: $selectedElements,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func colorContent() -> ColorContent {
        DiwaliColorPaletteView(
            selectedColorPalette: $selectedColorPalette,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func touchContent() -> TouchContent {
        DiwaliPersonalTouchView(
            selectedMessage: $selectedMessage,
            personalMessage: $personalMessage,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func createContent() -> CreateContent {
        DiwaliCreateSummaryView(
            selectedTheme: selectedTheme,
            selectedElements: selectedElements,
            selectedColorPalette: selectedColorPalette,
            finalMessage: finalMessage,
            isReadyToGenerate: isReadyToGenerate,
            culturalColor: culturalColor,
            onGenerate: {
                generateDiwaliGift()
            }
        )
    }

    @ViewBuilder func checkContent() -> CheckContent {
        DiwaliCheckImageView(
            generatedImages: generatedImages,
            personalMessage: finalMessage,
            isGenerating: $isGenerating,
            culturalColor: culturalColor,
            onRegenerate: {
                generateDiwaliGift()
            }
        )
    }

    @ViewBuilder func sendContent() -> SendContent {
        DiwaliSendShareView(
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
        DiwaliConnectView(
            selectedContact: selectedContact,
            culturalColor: culturalColor
        )
    }

    // MARK: - Generation Logic
    private func generateDiwaliGift() {
        print("🎯 Generate Diwali Gift button tapped")
        print("=" + String(repeating: "=", count: 79))
        print("📊 ALL TAB SELECTIONS - USER PREFERENCES:")
        print("=" + String(repeating: "=", count: 79))
        print("Tab 1 - THEME: \(selectedTheme?.rawValue ?? "❌ NOT SELECTED")")
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

        print("✅ Starting Diwali generation...")
        isGenerating = true
        currentTab = .check

        Task {
            do {
                // Get selected element (single element selection)
                let selectedElement = selectedElements.first

                // Generate iPhone background (tall format - no text in AI)
                print("📱 Generating iPhone background...")
                let iPhoneResult = try await chineseNewYearAI.generateDiwaliGift(
                    theme: selectedTheme!,
                    element: selectedElement,
                    colorPalette: selectedColorPalette!,
                    message: "", // No text in AI - will overlay natively
                    contactName: selectedContact.name
                )
                print("✅ iPhone background generated: \(iPhoneResult)")

                // Generate Apple Watch background (square format - no text in AI)
                print("⌚ Generating Apple Watch background...")
                let watchResult = try await chineseNewYearAI.generateDiwaliGift(
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
