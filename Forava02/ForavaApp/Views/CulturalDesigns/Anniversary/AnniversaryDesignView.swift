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
    @State var selectedElements: [AnniversaryElement] = []
    @State var selectedColorPalette: AnniversaryColorPalette?
    @State var selectedMessage: AnniversaryPersonalTouch?
    @State var personalMessage: String = ""

    // MARK: - Additional State
    @State private var isGenerating = false
    @State private var generatedImage: String?
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

            // Tab Content
            TabView(selection: $currentTab) {
                styleContent()
                    .tag(GiftDesignTab.style)

                elementsContent()
                    .tag(GiftDesignTab.elements)

                colorContent()
                    .tag(GiftDesignTab.colour)

                touchContent()
                    .tag(GiftDesignTab.touch)

                createContent()
                    .tag(GiftDesignTab.create)

                checkContent()
                    .tag(GiftDesignTab.check)

                sendContent()
                    .tag(GiftDesignTab.send)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: currentTab)
        }
        .navigationTitle("Anniversary Design")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Computed Properties
    private var isReadyToGenerate: Bool {
        selectedTheme != nil &&
        !selectedElements.isEmpty &&
        selectedColorPalette != nil &&
        (selectedMessage != nil || !personalMessage.isEmpty)
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
            generatedImage: generatedImage,
            isGenerating: $isGenerating,
            culturalColor: culturalColor,
            onRegenerate: {
                generateAnniversaryGift()
            }
        )
    }

    @ViewBuilder func sendContent() -> SendContent {
        AnniversarySendShareView(
            generatedImage: generatedImage,
            selectedContact: selectedContact,
            culturalColor: culturalColor,
            showingShareSheet: $showingShareSheet
        )
    }

    // MARK: - Generation Logic
    private func generateAnniversaryGift() {
        guard isReadyToGenerate else { return }

        isGenerating = true
        currentTab = .check

        Task {
            do {
                let result = try await anniversaryAI.generateAnniversaryGift(
                    theme: selectedTheme!,
                    elements: selectedElements,
                    colorPalette: selectedColorPalette!,
                    message: finalMessage,
                    contactName: selectedContact.name
                )

                await MainActor.run {
                    self.generatedImage = result
                    self.isGenerating = false
                }
            } catch {
                await MainActor.run {
                    self.isGenerating = false
                    // Handle error appropriately
                    print("Generation failed: \(error)")
                }
            }
        }
    }
}
