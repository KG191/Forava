import SwiftUI
import Foundation

struct ChristmasDesignView: View, CulturalDesignViewProtocol {
    // MARK: - Protocol Requirements
    typealias CulturalTheme = ChristmasTheme
    typealias CulturalElement = ChristmasElement
    typealias CulturalColorPalette = ChristmasColorPalette
    typealias CulturalPersonalTouch = ChristmasPersonalTouch

    // MARK: - Content View Types
    typealias StyleContent = ChristmasStyleSelectionView
    typealias ElementsContent = ChristmasElementsSelectionView
    typealias ColorContent = ChristmasColorPaletteView
    typealias TouchContent = ChristmasPersonalTouchView
    typealias CreateContent = ChristmasCreateSummaryView
    typealias CheckContent = ChristmasCheckImageView
    typealias SendContent = ChristmasSendShareView
    typealias ConnectContent = ChristmasConnectView

    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    // MARK: - State Management
    @State var currentTab: GiftDesignTab = .style
    @State var selectedTheme: ChristmasTheme?
    @State var selectedElements: [ChristmasElement] = []
    @State var selectedColorPalette: ChristmasColorPalette?
    @State var selectedMessage: ChristmasPersonalTouch?
    @State var personalMessage: String = ""

    // MARK: - Additional State
    @State private var isGenerating = false
    @State private var generatedImages: [String: String] = [:] // Keys: "iPhone", "Apple Watch"
    @State private var showingShareSheet = false
    @StateObject private var christmasAI = ChristmasAIService.shared

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
        .navigationTitle("Christmas Design")
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
extension ChristmasDesignView {
    @ViewBuilder func styleContent() -> StyleContent {
        ChristmasStyleSelectionView(
            selectedTheme: $selectedTheme,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func elementsContent() -> ElementsContent {
        ChristmasElementsSelectionView(
            selectedElements: $selectedElements,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func colorContent() -> ColorContent {
        ChristmasColorPaletteView(
            selectedColorPalette: $selectedColorPalette,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func touchContent() -> TouchContent {
        ChristmasPersonalTouchView(
            selectedMessage: $selectedMessage,
            personalMessage: $personalMessage,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func createContent() -> CreateContent {
        ChristmasCreateSummaryView(
            selectedTheme: selectedTheme,
            selectedElements: selectedElements,
            selectedColorPalette: selectedColorPalette,
            finalMessage: finalMessage,
            isReadyToGenerate: isReadyToGenerate,
            culturalColor: culturalColor,
            onGenerate: {
                generateChristmasGift()
            }
        )
    }

    @ViewBuilder func checkContent() -> CheckContent {
        ChristmasCheckImageView(
            generatedImages: generatedImages,
            personalMessage: finalMessage,
            isGenerating: $isGenerating,
            culturalColor: culturalColor,
            onRegenerate: {
                generateChristmasGift()
            }
        )
    }

    @ViewBuilder func sendContent() -> SendContent {
        ChristmasSendShareView(
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
        ChristmasConnectView(
            selectedContact: selectedContact,
            culturalColor: culturalColor
        )
    }

    // MARK: - Generation Logic
    private func generateChristmasGift() {
        print("🎯 Generate Christmas Gift button tapped")
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
            print("        AI COLOR HINT: \(colors.aiColorHint)")
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
                print("🎨 Starting Christmas AI generation...")
                print("   Theme: \(theme.rawValue)")
                print("   Primary Element: \(primaryElement.name)")
                print("   Color Palette: \(colorPalette.name)")
                print("   Message: \(finalMessage)")
                print("   Contact: \(selectedContact.name)")

                // Generate iPhone version
                let iPhoneURL = try await christmasAI.generateChristmasGift(
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
                let watchURL = try await christmasAI.generateChristmasGift(
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
                }

                print("🎉 All Christmas images generated successfully!")

            } catch {
                print("❌ Christmas generation failed: \(error.localizedDescription)")
                await MainActor.run {
                    isGenerating = false
                    // TODO: Show error alert to user
                }
            }
        }
    }
}
