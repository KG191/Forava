import SwiftUI
import Foundation

struct RakshaBandhanDesignView: View, CulturalDesignViewProtocol {
    // MARK: - Protocol Requirements
    typealias CulturalTheme = RakshaBandhanTheme
    typealias CulturalElement = RakshaBandhanElement
    typealias CulturalColorPalette = RakshaBandhanColorPalette
    typealias CulturalPersonalTouch = RakshaBandhanPersonalTouch

    // MARK: - Content View Types
    typealias StyleContent = RakshaBandhanStyleSelectionView
    typealias ElementsContent = RakshaBandhanElementsSelectionView
    typealias ColorContent = RakshaBandhanColorPaletteView
    typealias TouchContent = RakshaBandhanPersonalTouchView
    typealias CreateContent = RakshaBandhanCreateSummaryView
    typealias CheckContent = RakshaBandhanCheckImageView
    typealias SendContent = RakshaBandhanSendShareView
    typealias ConnectContent = RakshaBandhanConnectView

    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    // MARK: - State Management
    @State var currentTab: GiftDesignTab = .style
    @State var selectedTheme: RakshaBandhanTheme?
    @State var selectedElements: [RakshaBandhanElement] = []
    @State var selectedColorPalette: RakshaBandhanColorPalette?
    @State var selectedMessage: RakshaBandhanPersonalTouch?
    @State var personalMessage: String = ""

    // MARK: - Additional State
    @State private var isGenerating = false
    @State private var generatedImages: [String: String] = [:] // Keys: "iPhone", "Apple Watch"
    @State private var showingShareSheet = false
    @StateObject private var rakshaBandhanAI = RakshaBandhanAIService.shared

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
        .navigationTitle("Raksha Bandhan Design")
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
extension RakshaBandhanDesignView {
    @ViewBuilder func styleContent() -> StyleContent {
        RakshaBandhanStyleSelectionView(
            selectedTheme: $selectedTheme,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func elementsContent() -> ElementsContent {
        RakshaBandhanElementsSelectionView(
            selectedElements: $selectedElements,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func colorContent() -> ColorContent {
        RakshaBandhanColorPaletteView(
            selectedColorPalette: $selectedColorPalette,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func touchContent() -> TouchContent {
        RakshaBandhanPersonalTouchView(
            selectedMessage: $selectedMessage,
            personalMessage: $personalMessage,
            culturalColor: culturalColor
        )
    }

    @ViewBuilder func createContent() -> CreateContent {
        RakshaBandhanCreateSummaryView(
            selectedTheme: selectedTheme,
            selectedElements: selectedElements,
            selectedColorPalette: selectedColorPalette,
            finalMessage: finalMessage,
            isReadyToGenerate: isReadyToGenerate,
            culturalColor: culturalColor,
            onGenerate: {
                generateRakshaBandhanGift()
            }
        )
    }

    @ViewBuilder func checkContent() -> CheckContent {
        RakshaBandhanCheckImageView(
            generatedImages: generatedImages,
            personalMessage: finalMessage,
            isGenerating: $isGenerating,
            culturalColor: culturalColor,
            onRegenerate: {
                generateRakshaBandhanGift()
            }
        )
    }

    @ViewBuilder func sendContent() -> SendContent {
        RakshaBandhanSendShareView(
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
        RakshaBandhanConnectView(
            selectedContact: selectedContact,
            culturalColor: culturalColor
        )
    }

    // MARK: - Generation Logic
    private func generateRakshaBandhanGift() {
        print("🎯 Generate Raksha Bandhan Gift button tapped")
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
                print("🎨 Starting Raksha Bandhan AI generation...")
                print("   Theme: \(theme.rawValue)")
                print("   Primary Element: \(primaryElement.name)")
                print("   Color Palette: \(colorPalette.name)")
                print("   Message: \(finalMessage)")
                print("   Contact: \(selectedContact.name)")

                // Generate iPhone version
                let iPhoneURL = try await rakshaBandhanAI.generateRakshaBandhanGift(
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
                let watchURL = try await rakshaBandhanAI.generateRakshaBandhanGift(
                    theme: theme,
                    element: primaryElement,
                    colorPalette: colorPalette,
                    message: finalMessage,
                    contactName: selectedContact.name,
                    format: .appleWatch
                )

                await MainActor.run {
                    generatedImages["Apple Watch"] = watchURL
                    print("✅ Apple Watch image generated: \(watchURL)")
                    isGenerating = false
                }

                print("🎉 All Raksha Bandhan images generated successfully!")

            } catch {
                print("❌ Raksha Bandhan generation failed: \(error.localizedDescription)")
                await MainActor.run {
                    isGenerating = false
                    // TODO: Show error alert to user
                }
            }
        }
    }
}
