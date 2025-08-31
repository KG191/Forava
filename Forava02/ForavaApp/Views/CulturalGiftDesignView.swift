import SwiftUI
import Foundation

// MARK: - Type References for Swift Compiler
// Force compiler to recognize all cultural model types to prevent scope errors
private let _typeReferences: Void = {
    _ = EidAlFitrTheme.self
    _ = EidAlFitrElement.self
    _ = EidAlFitrColorPalette.self
    _ = EidAlFitrPersonalTouch.self
    _ = EidAlFitrSelectionState.self
    _ = EidAlAdhaTheme.self
    _ = EidAlAdhaElement.self
    _ = EidAlAdhaColorPalette.self
    _ = EidAlAdhaPersonalTouch.self
    _ = EidAlAdhaSelectionState.self
    _ = HanukkahTheme.self
    _ = HanukkahElement.self
    _ = HanukkahColorPalette.self
    _ = HanukkahPersonalTouch.self
    _ = HanukkahSelectionState.self
    _ = MidAutumnFestivalTheme.self
    _ = MidAutumnFestivalElement.self
    _ = MidAutumnFestivalColorPalette.self
    _ = MidAutumnFestivalPersonalTouch.self
    _ = MidAutumnFestivalSelectionState.self
    _ = RakshaBandhanTheme.self
    _ = RakshaBandhanElement.self
    _ = RakshaBandhanColorPalette.self
    _ = RakshaBandhanPersonalTouch.self
    _ = RakshaBandhanSelectionState.self
    _ = VesakDayTheme.self
    _ = VesakDayElement.self
    _ = VesakDayColorPalette.self
    _ = VesakDayPersonalTouch.self
    _ = VesakDaySelectionState.self
    _ = RoshHashanahTheme.self
    _ = RoshHashanahElement.self
    _ = RoshHashanahColorPalette.self
    _ = RoshHashanahPersonalTouch.self
    _ = RoshHashanahSelectionState.self
}()

enum GiftDesignTab: String, CaseIterable {
    case style = "Style"
    case elements = "Elements"
    case colour = "Colour"
    case touch = "Touch"
    case create = "Create"
    case check = "Check"
    case send = "Send"

    var icon: String {
        switch self {
        case .style: return "paintbrush.fill"
        case .elements: return "square.stack.3d.up.fill"
        case .colour: return "paintpalette.fill"
        case .touch: return "hand.tap.fill"
        case .create: return "wand.and.stars"
        case .check: return "checkmark.circle.fill"
        case .send: return "paperplane.fill"
        }
    }

    var tabNumber: Int {
        switch self {
        case .style: return 1
        case .elements: return 2
        case .colour: return 3
        case .touch: return 4
        case .create: return 5
        case .check: return 6
        case .send: return 7
        }
    }
}

struct CulturalGiftDesignView: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    @State private var currentTab: GiftDesignTab = .style
    @State private var selectedGift: CulturalGift?
    @State private var selectedChristmasTheme: ChristmasTheme?
    @State private var selectedAnniversaryTheme: AnniversaryTheme?
    @State private var selectedBirthdayTheme: BirthdayTheme?
    @State private var selectedChineseNewYearTheme: ChineseNewYearTheme?
    @State private var selectedDiwaliTheme: DiwaliTheme?
    @State private var selectedEasterTheme: EasterTheme?
    @State private var selectedEidAlAdhaTheme: EidAlAdhaTheme?
    @State private var selectedEidAlFitrTheme: EidAlFitrTheme?
    @State private var selectedHanukkahTheme: HanukkahTheme?
    @State private var selectedMidAutumnFestivalTheme: MidAutumnFestivalTheme?
    @State private var selectedRakshaBandhanTheme: RakshaBandhanTheme?
    @State private var selectedVesakDayTheme: VesakDayTheme?
    @State private var selectedRoshHashanahTheme: RoshHashanahTheme?
    @State private var showingGiftSelection = false
    @State private var selectedChristmasElements: [ChristmasElement] = []
    @State private var selectedAnniversaryElements: [AnniversaryElement] = []
    @State private var selectedBirthdayElements: [BirthdayElement] = []
    @State private var selectedChineseNewYearElements: [ChineseNewYearElement] = []
    @State private var selectedDiwaliElements: [DiwaliElement] = []
    @State private var selectedEasterElements: [EasterElement] = []
    @State private var selectedEidAlAdhaElements: [EidAlAdhaElement] = []
    @State private var selectedEidAlFitrElements: [EidAlFitrElement] = []
    @State private var selectedHanukkahElements: [HanukkahElement] = []
    @State private var selectedMidAutumnFestivalElements: [MidAutumnFestivalElement] = []
    @State private var selectedRakshaBandhanElements: [RakshaBandhanElement] = []
    @State private var selectedVesakDayElements: [VesakDayElement] = []
    @State private var selectedRoshHashanahElements: [RoshHashanahElement] = []
    @State private var selectedChristmasColorPalette: ChristmasColorPalette?
    @State private var selectedAnniversaryColorPalette: AnniversaryColorPalette?
    @State private var selectedBirthdayColorPalette: BirthdayColorPalette?
    @State private var selectedChineseNewYearColorPalette: ChineseNewYearColorPalette?
    @State private var selectedDiwaliColorPalette: DiwaliColorPalette?
    @State private var selectedEasterColorPalette: EasterColorPalette?
    @State private var selectedEidAlAdhaColorPalette: EidAlAdhaColorPalette?
    @State private var selectedEidAlFitrColorPalette: EidAlFitrColorPalette?
    @State private var selectedHanukkahColorPalette: HanukkahColorPalette?
    @State private var selectedMidAutumnFestivalColorPalette: MidAutumnFestivalColorPalette?
    @State private var selectedRakshaBandhanColorPalette: RakshaBandhanColorPalette?
    @State private var selectedVesakDayColorPalette: VesakDayColorPalette?
    @State private var selectedRoshHashanahColorPalette: RoshHashanahColorPalette?
    @State private var selectedChristmasMessage: ChristmasPersonalTouch?
    @State private var selectedAnniversaryMessage: AnniversaryPersonalTouch?
    @State private var selectedBirthdayMessage: BirthdayPersonalTouch?
    @State private var selectedChineseNewYearMessage: ChineseNewYearPersonalTouch?
    @State private var selectedDiwaliMessage: DiwaliPersonalTouch?
    @State private var selectedEasterMessage: EasterPersonalTouch?
    @State private var selectedEidAlAdhaMessage: EidAlAdhaPersonalTouch?
    @State private var selectedEidAlFitrMessage: EidAlFitrPersonalTouch?
    @State private var selectedHanukkahMessage: HanukkahPersonalTouch?
    @State private var selectedMidAutumnFestivalMessage: MidAutumnFestivalPersonalTouch?
    @State private var selectedRakshaBandhanMessage: RakshaBandhanPersonalTouch?
    @State private var selectedVesakDayMessage: VesakDayPersonalTouch?
    @State private var selectedRoshHashanahMessage: RoshHashanahPersonalTouch?
    @State private var personalChristmasMessage: String = ""
    @State private var personalAnniversaryMessage: String = ""
    @State private var personalBirthdayMessage: String = ""
    @State private var personalChineseNewYearMessage: String = ""
    @State private var personalDiwaliMessage: String = ""
    @State private var personalEasterMessage: String = ""
    @State private var personalEidAlAdhaMessage: String = ""
    @State private var personalEidAlFitrMessage: String = ""
    @State private var personalHanukkahMessage: String = ""
    @State private var personalMidAutumnFestivalMessage: String = ""
    @State private var personalRakshaBandhanMessage: String = ""
    @State private var personalVesakDayMessage: String = ""
    @State private var personalRoshHashanahMessage: String = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header - Centered
                VStack(spacing: 12) {
                    // Main title centered with icon
                    HStack(spacing: 8) {
                        Image(systemName: selectedEvent.category.icon)
                            .foregroundStyle(selectedEvent.category.primaryColor)
                            .font(.title2)

                        Text(selectedEvent.selectionTitle)
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)

                    Text("for \(selectedContact.name)")
                        .font(.system(.body, design: .rounded).weight(.medium))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Tab Navigation
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(GiftDesignTab.allCases, id: \.self) { tab in
                            TabButton(
                                tab: tab,
                                isSelected: currentTab == tab,
                                culturalColor: selectedEvent.category.primaryColor
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    currentTab = tab
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12) // Add vertical padding to prevent cutoff
                }
                .padding(.top, 20)

                // Tab Content
                TabView(selection: $currentTab) {
                    ForEach(GiftDesignTab.allCases, id: \.self) { tab in
                        Group {
                            if selectedEvent.isComingSoon {
                                ComingSoonView(selectedEvent: selectedEvent)
                            } else {
                                TabContentView(
                                    tab: tab,
                                    selectedEvent: selectedEvent,
                                    selectedContact: selectedContact,
                                    selectedGift: $selectedGift,
                                    selectedChristmasTheme: $selectedChristmasTheme,
                                    selectedAnniversaryTheme: $selectedAnniversaryTheme,
                                    selectedBirthdayTheme: $selectedBirthdayTheme,
                                    selectedChineseNewYearTheme: $selectedChineseNewYearTheme,
                                    selectedDiwaliTheme: $selectedDiwaliTheme,
                                    selectedEasterTheme: $selectedEasterTheme,
                                    selectedEidAlAdhaTheme: $selectedEidAlAdhaTheme,
                                    selectedEidAlFitrTheme: $selectedEidAlFitrTheme,
                                    selectedHanukkahTheme: $selectedHanukkahTheme,
                                    selectedMidAutumnFestivalTheme: $selectedMidAutumnFestivalTheme,
                                    selectedRakshaBandhanTheme: $selectedRakshaBandhanTheme,
                                    selectedVesakDayTheme: $selectedVesakDayTheme,
                                    selectedRoshHashanahTheme: $selectedRoshHashanahTheme,
                                    showingGiftSelection: $showingGiftSelection,
                                    selectedChristmasElements: $selectedChristmasElements,
                                    selectedAnniversaryElements: $selectedAnniversaryElements,
                                    selectedBirthdayElements: $selectedBirthdayElements,
                                    selectedChineseNewYearElements: $selectedChineseNewYearElements,
                                    selectedDiwaliElements: $selectedDiwaliElements,
                                    selectedEasterElements: $selectedEasterElements,
                                    selectedEidAlAdhaElements: $selectedEidAlAdhaElements,
                                    selectedEidAlFitrElements: $selectedEidAlFitrElements,
                                    selectedHanukkahElements: $selectedHanukkahElements,
                                    selectedMidAutumnFestivalElements: $selectedMidAutumnFestivalElements,
                                    selectedRakshaBandhanElements: $selectedRakshaBandhanElements,
                                    selectedVesakDayElements: $selectedVesakDayElements,
                                    selectedRoshHashanahElements: $selectedRoshHashanahElements,
                                    selectedChristmasColorPalette: $selectedChristmasColorPalette,
                                    selectedAnniversaryColorPalette: $selectedAnniversaryColorPalette,
                                    selectedBirthdayColorPalette: $selectedBirthdayColorPalette,
                                    selectedChineseNewYearColorPalette: $selectedChineseNewYearColorPalette,
                                    selectedDiwaliColorPalette: $selectedDiwaliColorPalette,
                                    selectedEasterColorPalette: $selectedEasterColorPalette,
                                    selectedEidAlAdhaColorPalette: $selectedEidAlAdhaColorPalette,
                                    selectedEidAlFitrColorPalette: $selectedEidAlFitrColorPalette,
                                    selectedHanukkahColorPalette: $selectedHanukkahColorPalette,
                                    selectedMidAutumnFestivalColorPalette: $selectedMidAutumnFestivalColorPalette,
                                    selectedRakshaBandhanColorPalette: $selectedRakshaBandhanColorPalette,
                                    selectedVesakDayColorPalette: $selectedVesakDayColorPalette,
                                    selectedRoshHashanahColorPalette: $selectedRoshHashanahColorPalette,
                                    selectedChristmasMessage: $selectedChristmasMessage,
                                    selectedAnniversaryMessage: $selectedAnniversaryMessage,
                                    selectedBirthdayMessage: $selectedBirthdayMessage,
                                    selectedChineseNewYearMessage: $selectedChineseNewYearMessage,
                                    selectedDiwaliMessage: $selectedDiwaliMessage,
                                    selectedEasterMessage: $selectedEasterMessage,
                                    selectedEidAlAdhaMessage: $selectedEidAlAdhaMessage,
                                    selectedEidAlFitrMessage: $selectedEidAlFitrMessage,
                                    selectedHanukkahMessage: $selectedHanukkahMessage,
                                    selectedMidAutumnFestivalMessage: $selectedMidAutumnFestivalMessage,
                                    selectedRakshaBandhanMessage: $selectedRakshaBandhanMessage,
                                    selectedVesakDayMessage: $selectedVesakDayMessage,
                                    selectedRoshHashanahMessage: $selectedRoshHashanahMessage,
                                    personalChristmasMessage: $personalChristmasMessage,
                                    personalAnniversaryMessage: $personalAnniversaryMessage,
                                    personalBirthdayMessage: $personalBirthdayMessage,
                                    personalChineseNewYearMessage: $personalChineseNewYearMessage,
                                    personalDiwaliMessage: $personalDiwaliMessage,
                                    personalEasterMessage: $personalEasterMessage,
                                    personalEidAlAdhaMessage: $personalEidAlAdhaMessage,
                                    personalEidAlFitrMessage: $personalEidAlFitrMessage,
                                    personalHanukkahMessage: $personalHanukkahMessage,
                                    personalMidAutumnFestivalMessage: $personalMidAutumnFestivalMessage,
                                    personalRakshaBandhanMessage: $personalRakshaBandhanMessage,
                                    personalVesakDayMessage: $personalVesakDayMessage,
                                    personalRoshHashanahMessage: $personalRoshHashanahMessage
                                )
                            }
                        }
                        .tag(tab)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentTab)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct TabButton: View {
    let tab: GiftDesignTab
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    // Light orange color for unselected tabs (matching landing page)
    private let unselectedColor = Color(hex: "#FFC170")

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                // Tab number indicator
                ZStack {
                    Circle()
                        .fill(isSelected ? culturalColor : unselectedColor.opacity(0.6))
                        .frame(width: 24, height: 24)

                    Text("\(tab.tabNumber)")
                        .font(.system(.caption, design: .rounded).weight(.bold))
                        .foregroundStyle(isSelected ? .white : .white.opacity(0.8))
                }

                // Tab icon and label
                VStack(spacing: 4) {
                    Image(systemName: tab.icon)
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(isSelected ? culturalColor : unselectedColor)

                    Text(tab.rawValue)
                        .font(.system(.caption2, design: .rounded).weight(.medium))
                        .foregroundStyle(isSelected ? culturalColor : unselectedColor)
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
            .background {
                if isSelected {
                    // Apple Liquid Glass effect for selected tab
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(culturalColor.opacity(0.15))
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(culturalColor.opacity(0.3), lineWidth: 1)
                        }
                        .shadow(color: culturalColor.opacity(0.2), radius: 8, x: 0, y: 4)
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 16)) // Ensure proper clipping
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3), value: isSelected)
    }
}

struct TabContentView: View {
    let tab: GiftDesignTab
    let selectedEvent: CulturalEvent
    let selectedContact: Contact
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedChristmasTheme: ChristmasTheme?
    @Binding var selectedAnniversaryTheme: AnniversaryTheme?
    @Binding var selectedBirthdayTheme: BirthdayTheme?
    @Binding var selectedChineseNewYearTheme: ChineseNewYearTheme?
    @Binding var selectedDiwaliTheme: DiwaliTheme?
    @Binding var selectedEasterTheme: EasterTheme?
    @Binding var selectedEidAlAdhaTheme: EidAlAdhaTheme?
    @Binding var selectedEidAlFitrTheme: EidAlFitrTheme?
    @Binding var selectedHanukkahTheme: HanukkahTheme?
    @Binding var selectedMidAutumnFestivalTheme: MidAutumnFestivalTheme?
    @Binding var selectedRakshaBandhanTheme: RakshaBandhanTheme?
    @Binding var selectedVesakDayTheme: VesakDayTheme?
    @Binding var selectedRoshHashanahTheme: RoshHashanahTheme?
    @Binding var showingGiftSelection: Bool
    @Binding var selectedChristmasElements: [ChristmasElement]
    @Binding var selectedAnniversaryElements: [AnniversaryElement]
    @Binding var selectedBirthdayElements: [BirthdayElement]
    @Binding var selectedChineseNewYearElements: [ChineseNewYearElement]
    @Binding var selectedDiwaliElements: [DiwaliElement]
    @Binding var selectedEasterElements: [EasterElement]
    @Binding var selectedEidAlAdhaElements: [EidAlAdhaElement]
    @Binding var selectedEidAlFitrElements: [EidAlFitrElement]
    @Binding var selectedHanukkahElements: [HanukkahElement]
    @Binding var selectedMidAutumnFestivalElements: [MidAutumnFestivalElement]
    @Binding var selectedRakshaBandhanElements: [RakshaBandhanElement]
    @Binding var selectedVesakDayElements: [VesakDayElement]
    @Binding var selectedRoshHashanahElements: [RoshHashanahElement]
    @Binding var selectedChristmasColorPalette: ChristmasColorPalette?
    @Binding var selectedAnniversaryColorPalette: AnniversaryColorPalette?
    @Binding var selectedBirthdayColorPalette: BirthdayColorPalette?
    @Binding var selectedChineseNewYearColorPalette: ChineseNewYearColorPalette?
    @Binding var selectedDiwaliColorPalette: DiwaliColorPalette?
    @Binding var selectedEasterColorPalette: EasterColorPalette?
    @Binding var selectedEidAlAdhaColorPalette: EidAlAdhaColorPalette?
    @Binding var selectedEidAlFitrColorPalette: EidAlFitrColorPalette?
    @Binding var selectedHanukkahColorPalette: HanukkahColorPalette?
    @Binding var selectedMidAutumnFestivalColorPalette: MidAutumnFestivalColorPalette?
    @Binding var selectedRakshaBandhanColorPalette: RakshaBandhanColorPalette?
    @Binding var selectedVesakDayColorPalette: VesakDayColorPalette?
    @Binding var selectedRoshHashanahColorPalette: RoshHashanahColorPalette?
    @Binding var selectedChristmasMessage: ChristmasPersonalTouch?
    @Binding var selectedAnniversaryMessage: AnniversaryPersonalTouch?
    @Binding var selectedBirthdayMessage: BirthdayPersonalTouch?
    @Binding var selectedChineseNewYearMessage: ChineseNewYearPersonalTouch?
    @Binding var selectedDiwaliMessage: DiwaliPersonalTouch?
    @Binding var selectedEasterMessage: EasterPersonalTouch?
    @Binding var selectedEidAlAdhaMessage: EidAlAdhaPersonalTouch?
    @Binding var selectedEidAlFitrMessage: EidAlFitrPersonalTouch?
    @Binding var selectedHanukkahMessage: HanukkahPersonalTouch?
    @Binding var selectedMidAutumnFestivalMessage: MidAutumnFestivalPersonalTouch?
    @Binding var selectedRakshaBandhanMessage: RakshaBandhanPersonalTouch?
    @Binding var selectedVesakDayMessage: VesakDayPersonalTouch?
    @Binding var selectedRoshHashanahMessage: RoshHashanahPersonalTouch?
    @Binding var personalChristmasMessage: String
    @Binding var personalAnniversaryMessage: String
    @Binding var personalBirthdayMessage: String
    @Binding var personalChineseNewYearMessage: String
    @Binding var personalDiwaliMessage: String
    @Binding var personalEasterMessage: String
    @Binding var personalEidAlAdhaMessage: String
    @Binding var personalEidAlFitrMessage: String
    @Binding var personalHanukkahMessage: String
    @Binding var personalMidAutumnFestivalMessage: String
    @Binding var personalRakshaBandhanMessage: String
    @Binding var personalVesakDayMessage: String
    @Binding var personalRoshHashanahMessage: String

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Tab-specific content
                switch tab {
                case .style:
                    StyleTabContent(
                        selectedEvent: selectedEvent,
                        selectedGift: $selectedGift,
                        selectedChristmasTheme: $selectedChristmasTheme,
                        selectedAnniversaryTheme: $selectedAnniversaryTheme,
                        selectedBirthdayTheme: $selectedBirthdayTheme,
                        selectedChineseNewYearTheme: $selectedChineseNewYearTheme,
                        selectedDiwaliTheme: $selectedDiwaliTheme,
                        selectedEasterTheme: $selectedEasterTheme,
                        selectedEidAlAdhaTheme: $selectedEidAlAdhaTheme,
                        selectedVesakDayTheme: $selectedVesakDayTheme,
                        showingGiftSelection: $showingGiftSelection
                    )
                case .elements:
                    ElementsTabContent(
                        selectedEvent: selectedEvent,
                        selectedChristmasElements: $selectedChristmasElements,
                        selectedAnniversaryElements: $selectedAnniversaryElements,
                        selectedBirthdayElements: $selectedBirthdayElements,
                        selectedChineseNewYearElements: $selectedChineseNewYearElements,
                        selectedDiwaliElements: $selectedDiwaliElements,
                        selectedEasterElements: $selectedEasterElements,
                        selectedEidAlAdhaElements: $selectedEidAlAdhaElements
                    )
                case .colour:
                    ColourTabContent(
                        selectedEvent: selectedEvent,
                        selectedChristmasColorPalette: $selectedChristmasColorPalette,
                        selectedAnniversaryColorPalette: $selectedAnniversaryColorPalette,
                        selectedBirthdayColorPalette: $selectedBirthdayColorPalette,
                        selectedChineseNewYearColorPalette: $selectedChineseNewYearColorPalette,
                        selectedDiwaliColorPalette: $selectedDiwaliColorPalette,
                        selectedEasterColorPalette: $selectedEasterColorPalette,
                        selectedEidAlAdhaColorPalette: $selectedEidAlAdhaColorPalette
                    )
                case .touch:
                    TouchTabContent(
                        selectedEvent: selectedEvent,
                        selectedChristmasMessage: $selectedChristmasMessage,
                        personalChristmasMessage: $personalChristmasMessage,
                        selectedAnniversaryMessage: $selectedAnniversaryMessage,
                        personalAnniversaryMessage: $personalAnniversaryMessage,
                        selectedBirthdayMessage: $selectedBirthdayMessage,
                        personalBirthdayMessage: $personalBirthdayMessage,
                        selectedChineseNewYearMessage: $selectedChineseNewYearMessage,
                        personalChineseNewYearMessage: $personalChineseNewYearMessage,
                        selectedDiwaliMessage: $selectedDiwaliMessage,
                        personalDiwaliMessage: $personalDiwaliMessage,
                        selectedEasterMessage: $selectedEasterMessage,
                        personalEasterMessage: $personalEasterMessage,
                        selectedEidAlAdhaMessage: $selectedEidAlAdhaMessage,
                        personalEidAlAdhaMessage: $personalEidAlAdhaMessage
                    )
                case .create:
                    CreateTabContent(
                        selectedEvent: selectedEvent,
                        selectedGift: selectedGift,
                        selectedChristmasTheme: selectedChristmasTheme,
                        selectedChristmasElements: selectedChristmasElements,
                        selectedChristmasColorPalette: selectedChristmasColorPalette,
                        selectedChristmasMessage: selectedChristmasMessage,
                        personalChristmasMessage: personalChristmasMessage,
                        selectedAnniversaryTheme: selectedAnniversaryTheme,
                        selectedAnniversaryElements: selectedAnniversaryElements,
                        selectedAnniversaryColorPalette: selectedAnniversaryColorPalette,
                        selectedAnniversaryMessage: selectedAnniversaryMessage,
                        personalAnniversaryMessage: personalAnniversaryMessage,
                        selectedBirthdayTheme: selectedBirthdayTheme,
                        selectedBirthdayElements: selectedBirthdayElements,
                        selectedBirthdayColorPalette: selectedBirthdayColorPalette,
                        selectedBirthdayMessage: selectedBirthdayMessage,
                        personalBirthdayMessage: personalBirthdayMessage,
                        selectedChineseNewYearTheme: selectedChineseNewYearTheme,
                        selectedChineseNewYearElements: selectedChineseNewYearElements,
                        selectedChineseNewYearColorPalette: selectedChineseNewYearColorPalette,
                        selectedChineseNewYearMessage: selectedChineseNewYearMessage,
                        personalChineseNewYearMessage: personalChineseNewYearMessage,
                        selectedDiwaliTheme: selectedDiwaliTheme,
                        selectedDiwaliElements: selectedDiwaliElements,
                        selectedDiwaliColorPalette: selectedDiwaliColorPalette,
                        selectedDiwaliMessage: selectedDiwaliMessage,
                        personalDiwaliMessage: personalDiwaliMessage,
                        selectedEasterTheme: selectedEasterTheme,
                        selectedEasterElements: selectedEasterElements,
                        selectedEasterColorPalette: selectedEasterColorPalette,
                        selectedEasterMessage: selectedEasterMessage,
                        personalEasterMessage: personalEasterMessage,
                        selectedEidAlAdhaTheme: selectedEidAlAdhaTheme,
                        selectedEidAlAdhaElements: selectedEidAlAdhaElements,
                        selectedEidAlAdhaColorPalette: selectedEidAlAdhaColorPalette,
                        selectedEidAlAdhaMessage: selectedEidAlAdhaMessage,
                        personalEidAlAdhaMessage: personalEidAlAdhaMessage
                    )
                case .check:
                    CheckTabContent(selectedEvent: selectedEvent, selectedContact: selectedContact)
                case .send:
                    SendTabContent(selectedEvent: selectedEvent, selectedContact: selectedContact)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)
        }
    }
}

// MARK: - Style Tab Content
struct StyleTabContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedChristmasTheme: ChristmasTheme?
    @Binding var selectedAnniversaryTheme: AnniversaryTheme?
    @Binding var selectedBirthdayTheme: BirthdayTheme?
    @Binding var selectedChineseNewYearTheme: ChineseNewYearTheme?
    @Binding var selectedDiwaliTheme: DiwaliTheme?
    @Binding var selectedEasterTheme: EasterTheme?
    @Binding var selectedEidAlAdhaTheme: EidAlAdhaTheme?
    @Binding var selectedVesakDayTheme: VesakDayTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        let culturalGifts = CulturalGift.gifts(for: selectedEvent.category)

        // If no gifts available for this culture, fall back to Rakhi gifts converted to CulturalGift
        if culturalGifts.isEmpty && selectedEvent.category == .hindu {
            return Rakhi.sampleRakhis.map { $0.toCulturalGift() }
        }

        return culturalGifts
    }

    var body: some View {
        VStack(spacing: 20) {
            // Christmas-specific implementation
            if selectedEvent.name == "Christmas" {
                ChristmasStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedChristmasTheme: $selectedChristmasTheme,
                    showingGiftSelection: $showingGiftSelection
                )
            } else if selectedEvent.name == "Easter" {
                EasterStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedEasterTheme: $selectedEasterTheme,
                    showingGiftSelection: $showingGiftSelection
                )
            } else if selectedEvent.name == "Anniversaries" {
                // Anniversary-specific implementation
                AnniversaryStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedAnniversaryTheme: $selectedAnniversaryTheme,
                    showingGiftSelection: $showingGiftSelection
                )
            } else if selectedEvent.name == "Rosh Hashanah" {
                // Rosh Hashanah-specific implementation
                RoshHashanahStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedRoshHashanahTheme: $selectedRoshHashanahTheme,
                    showingGiftSelection: $showingGiftSelection,
                    selectedRoshHashanahElements: $selectedRoshHashanahElements,
                    selectedRoshHashanahColorPalette: $selectedRoshHashanahColorPalette,
                    selectedRoshHashanahMessage: $selectedRoshHashanahMessage,
                    personalRoshHashanahMessage: $personalRoshHashanahMessage
                )
            } else if selectedEvent.name == "Vesak Day" {
                // Vesak Day-specific implementation
                VesakDayStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedVesakDayTheme: $selectedVesakDayTheme,
                    showingGiftSelection: $showingGiftSelection,
                    selectedVesakDayElements: $selectedVesakDayElements,
                    selectedVesakDayColorPalette: $selectedVesakDayColorPalette,
                    selectedVesakDayMessage: $selectedVesakDayMessage,
                    personalVesakDayMessage: $personalVesakDayMessage
                )
            } else if selectedEvent.name == "Mid-Autumn Festival" {
                // Mid-Autumn Festival-specific implementation
                MidAutumnFestivalStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedMidAutumnFestivalTheme: $selectedMidAutumnFestivalTheme,
                    showingGiftSelection: $showingGiftSelection,
                    selectedMidAutumnFestivalElements: $selectedMidAutumnFestivalElements,
                    selectedMidAutumnFestivalColorPalette: $selectedMidAutumnFestivalColorPalette,
                    selectedMidAutumnFestivalMessage: $selectedMidAutumnFestivalMessage,
                    personalMidAutumnFestivalMessage: $personalMidAutumnFestivalMessage
                )
            } else if selectedEvent.name == "Raksha Bandhan" {
                // Raksha Bandhan-specific implementation
                RakshaBandhanStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedRakshaBandhanTheme: $selectedRakshaBandhanTheme,
                    showingGiftSelection: $showingGiftSelection
                )
            } else if selectedEvent.name == "Hanukkah" {
                // Hanukkah-specific implementation
                HanukkahStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedHanukkahTheme: $selectedHanukkahTheme,
                    showingGiftSelection: $showingGiftSelection,
                    selectedHanukkahElements: $selectedHanukkahElements,
                    selectedHanukkahColorPalette: $selectedHanukkahColorPalette,
                    selectedHanukkahMessage: $selectedHanukkahMessage,
                    personalHanukkahMessage: $personalHanukkahMessage
                )
            } else if selectedEvent.name == "Birthdays" {
                // Birthday-specific implementation
                BirthdayStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedBirthdayTheme: $selectedBirthdayTheme,
                    showingGiftSelection: $showingGiftSelection
                )
            } else if selectedEvent.name == "Chinese New Year" {
                // Chinese New Year-specific implementation
                ChineseNewYearStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedChineseNewYearTheme: $selectedChineseNewYearTheme,
                    showingGiftSelection: $showingGiftSelection
                )
            } else if selectedEvent.name == "Diwali" {
                // Diwali-specific implementation
                DiwaliStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedDiwaliTheme: $selectedDiwaliTheme,
                    showingGiftSelection: $showingGiftSelection
                )
            } else if selectedEvent.name == "Eid al-Adha" {
                // Eid al-Adha-specific implementation
                EidAlAdhaStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift,
                    selectedEidAlAdhaTheme: $selectedEidAlAdhaTheme,
                    showingGiftSelection: $showingGiftSelection
                )
            } else {
                // Default implementation for other cultures
                DefaultStyleContent(
                    selectedEvent: selectedEvent,
                    selectedGift: $selectedGift
                )
            }
        }
    }
}

struct StyleCard: View {
    let gift: CulturalGift
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Style preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 120)

                    // Cultural icon placeholder
                    VStack(spacing: 6) {
                        Image(systemName: gift.category.icon)
                            .font(.system(size: 30))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [culturalColor, culturalColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(gift.name)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 6 : 2
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Christmas Style Content
struct ChristmasStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedChristmasTheme: ChristmasTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Christmas Themes
                Text("Select a Christmas Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(ChristmasTheme.allCases, id: \.self) { theme in
                        ChristmasThemeCard(
                            theme: theme,
                            isSelected: selectedChristmasTheme == theme,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedChristmasTheme = theme
                                showingGiftSelection = true
                            }
                        }
                    }
                }
            } else {
                // Show Gift Options for Selected Theme
                VStack(spacing: 16) {
                    // Back button and theme info
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showingGiftSelection = false
                                selectedGift = nil
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Back to Themes")
                            }
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        }
                        Spacer()
                    }

                    if let theme = selectedChristmasTheme {
                        VStack(spacing: 8) {
                            Text("\(theme.rawValue) Christmas Gifts")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text(theme.description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        // Show available gifts (all Christmas gifts for now)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(availableGifts) { gift in
                                StyleCard(
                                    gift: gift,
                                    isSelected: selectedGift?.id == gift.id,
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedGift = gift
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Chinese New Year Style Content
struct ChineseNewYearStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedChineseNewYearTheme: ChineseNewYearTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Chinese New Year Themes
                Text("Select a Chinese New Year Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(ChineseNewYearTheme.allCases, id: \.self) { theme in
                        ChineseNewYearThemeCard(
                            theme: theme,
                            isSelected: selectedChineseNewYearTheme == theme,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedChineseNewYearTheme = theme
                                showingGiftSelection = true
                            }
                        }
                    }
                }
            } else {
                // Show Gift Options for Selected Theme
                VStack(spacing: 16) {
                    // Back button and theme info
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showingGiftSelection = false
                                selectedGift = nil
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(.caption, design: .rounded).weight(.semibold))
                                Text("Back to Themes")
                                    .font(.system(.caption, design: .rounded).weight(.semibold))
                            }
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        }

                        Spacer()
                    }

                    if let theme = selectedChineseNewYearTheme {
                        VStack(spacing: 8) {
                            Text("\(theme.rawValue) Chinese New Year Gifts")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text(theme.description)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        // Show available gifts for this theme
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(theme.giftOptions, id: \.self) { giftName in
                                if let gift = availableGifts.first(where: { $0.name == giftName }) {
                                    StyleCard(
                                        gift: gift,
                                        isSelected: selectedGift?.id == gift.id,
                                        culturalColor: selectedEvent.category.primaryColor
                                    ) {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            selectedGift = gift
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Chinese New Year Theme Card
struct ChineseNewYearThemeCard: View {
    let theme: ChineseNewYearTheme
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Theme icon
                ZStack {
                    Circle()
                        .fill(
                            isSelected ?
                            culturalColor.opacity(0.2) :
                            Color(.systemGray6)
                        )
                        .frame(width: 60, height: 60)

                    Text(themeEmoji)
                        .font(.title)
                }

                VStack(spacing: 4) {
                    Text(theme.rawValue)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(theme.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .stroke(
                        isSelected ? culturalColor : Color(.systemGray5),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
    }

    private var themeEmoji: String {
        switch theme {
        case .traditional: return "🏮"
        case .zodiac: return "🐉"
        case .prosperity: return "💰"
        case .modern: return "🎆"
        }
    }
}

// MARK: - Christmas Theme Card
struct ChristmasThemeCard: View {
    let theme: ChristmasTheme
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Theme preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 120)

                    VStack(spacing: 8) {
                        // Theme-specific icon
                        Image(systemName: themeIcon)
                            .font(.system(size: 30))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [theme.primaryColor, theme.primaryColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(theme.rawValue)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(theme.description)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 6 : 2
            )
        }
        .buttonStyle(.plain)
    }

    private var themeIcon: String {
        switch theme {
        case .traditional:
            return "house.fill"
        case .modern:
            return "sparkles"
        case .elegant:
            return "crown.fill"
        case .spiritual:
            return "star.fill"
        }
    }
}

// MARK: - Diwali Theme Card
struct DiwaliThemeCard: View {
    let theme: DiwaliTheme
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Theme preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 120)

                    VStack(spacing: 8) {
                        // Theme-specific icon
                        Image(systemName: themeIcon)
                            .font(.system(size: 30))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [theme.primaryColor, theme.primaryColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(theme.rawValue)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(theme.description)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 6 : 2
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
    }

    private var themeIcon: String {
        switch theme {
        case .traditional:
            return "flame.fill"
        case .rangoli:
            return "circle.hexagonpath.fill"
        case .lakshmi:
            return "sparkles"
        case .modern:
            return "lightbulb.fill"
        }
    }
}

// MARK: - Diwali Gift Option Card
struct DiwaliGiftOptionCard: View {
    let giftName: String
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Gift preview area
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                        .frame(height: 100)

                    VStack(spacing: 8) {
                        Image(systemName: giftIcon)
                            .font(.system(size: 24))
                            .foregroundStyle(culturalColor)

                        Text(giftName)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.2) : .black.opacity(0.1),
                radius: isSelected ? 6 : 3,
                y: isSelected ? 4 : 1
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
    }

    private var giftIcon: String {
        // Map gift names to appropriate SF Symbols
        if giftName.lowercased().contains("diya") || giftName.lowercased().contains("lamp") {
            return "flame.fill"
        } else if giftName.lowercased().contains("rangoli") || giftName.lowercased().contains("pattern") {
            return "circle.hexagonpath.fill"
        } else if giftName.lowercased().contains("lakshmi") || giftName.lowercased().contains("goddess") {
            return "sparkles"
        } else if giftName.lowercased().contains("lotus") {
            return "leaf.fill"
        } else if giftName.lowercased().contains("om") {
            return "circle.fill"
        } else if giftName.lowercased().contains("gold") || giftName.lowercased().contains("coin") {
            return "dollarsign.circle.fill"
        } else if giftName.lowercased().contains("modern") || giftName.lowercased().contains("contemporary") {
            return "lightbulb.fill"
        } else if giftName.lowercased().contains("mandala") || giftName.lowercased().contains("circle") {
            return "circle.dotted"
        } else {
            return "gift.fill" // Default gift icon
        }
    }
}

// MARK: - Diwali Style Content
struct DiwaliStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedDiwaliTheme: DiwaliTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Diwali Themes
                Text("Select a Diwali Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(DiwaliTheme.allCases, id: \.self) { theme in
                        DiwaliThemeCard(
                            theme: theme,
                            isSelected: selectedDiwaliTheme == theme,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedDiwaliTheme = theme
                                showingGiftSelection = true
                            }
                        }
                    }
                }
            } else {
                // Show Gift Options for Selected Theme
                VStack(spacing: 16) {
                    // Back button and theme info
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showingGiftSelection = false
                                selectedGift = nil
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Back to Themes")
                            }
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        }

                        Spacer()

                        if let theme = selectedDiwaliTheme {
                            Text(theme.rawValue)
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                        }
                    }

                    if let theme = selectedDiwaliTheme {
                        Text(theme.description)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        // Gift Options Grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                            ForEach(theme.giftOptions, id: \.self) { giftOption in
                                DiwaliGiftOptionCard(
                                    giftName: giftOption,
                                    isSelected: selectedGift?.name == giftOption,
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    // Create a CulturalGift for this option
                                    let culturalGift = CulturalGift(
                                        name: giftOption,
                                        imageName: "diwali_\(giftOption.replacingOccurrences(of: " ", with: "_").lowercased())",
                                        description: "Beautiful \(giftOption.lowercased()) design",
                                        price: 2.99,
                                        category: .traditional,
                                        culturalContext: selectedEvent.category,
                                        colors: selectedEvent.colors
                                    )
                                    selectedGift = culturalGift
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Anniversary Style Content
struct AnniversaryStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedAnniversaryTheme: AnniversaryTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Anniversary Themes
                Text("Select an Anniversary Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(AnniversaryTheme.allCases, id: \.self) { theme in
                        AnniversaryThemeCard(
                            theme: theme,
                            isSelected: selectedAnniversaryTheme == theme,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedAnniversaryTheme = theme
                                showingGiftSelection = true
                            }
                        }
                    }
                }
            } else {
                // Show Gift Options for Selected Theme
                VStack(spacing: 16) {
                    // Back button and theme info
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showingGiftSelection = false
                                selectedGift = nil
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Back to Themes")
                            }
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        }
                        Spacer()
                    }

                    if let theme = selectedAnniversaryTheme {
                        VStack(spacing: 8) {
                            Text(theme.rawValue)
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text(theme.description)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        Text("Choose your Anniversary gift style")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(theme.giftOptions, id: \.self) { giftOption in
                                // Create a mock CulturalGift for Anniversary
                                let gift = CulturalGift(
                                    name: giftOption,
                                    imageName: "anniversary_placeholder",
                                    description: "Beautiful \(giftOption.lowercased())",
                                    price: 4.99,
                                    category: .traditional,
                                    culturalContext: .universal,
                                    colors: ["#DC143C", "#FFD700", "#FF69B4"]
                                )

                                StyleCard(
                                    gift: gift,
                                    isSelected: selectedGift?.name == giftOption,
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedGift = gift
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Anniversary Theme Card
struct AnniversaryThemeCard: View {
    let theme: AnniversaryTheme
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Theme preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 120)

                    VStack(spacing: 8) {
                        // Theme-specific icon
                        Image(systemName: themeIcon)
                            .font(.system(size: 30))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [theme.primaryColor, theme.primaryColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(theme.rawValue)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(theme.description)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 6 : 2
            )
        }
        .buttonStyle(.plain)
    }

    private var themeIcon: String {
        switch theme {
        case .romantic:
            return "heart.fill"
        case .milestone:
            return "calendar.badge.plus"
        case .family:
            return "house.fill"
        case .achievement:
            return "trophy.fill"
        }
    }
}

// MARK: - Default Style Content (Non-Christmas)
struct DefaultStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?

    private var availableGifts: [CulturalGift] {
        let culturalGifts = CulturalGift.gifts(for: selectedEvent.category)

        // If no gifts available for this culture, fall back to Rakhi gifts converted to CulturalGift
        if culturalGifts.isEmpty && selectedEvent.category == .hindu {
            return Rakhi.sampleRakhis.map { $0.toCulturalGift() }
        }

        return culturalGifts
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if availableGifts.isEmpty {
                // Empty state
                VStack(spacing: 20) {
                    Text(selectedEvent.category.icon)
                        .font(.system(size: 60))
                        .foregroundStyle(selectedEvent.category.primaryColor.opacity(0.6))

                    VStack(spacing: 8) {
                        Text("Coming Soon!")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)

                        Text("\(selectedEvent.name) styles are being carefully curated with cultural authenticity in mind.")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.vertical, 40)
            } else {
                // Gift styles grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(availableGifts) { gift in
                        StyleCard(
                            gift: gift,
                            isSelected: selectedGift?.id == gift.id,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedGift = gift
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Elements Tab Content
struct ElementsTabContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedChristmasElements: [ChristmasElement]
    @Binding var selectedAnniversaryElements: [AnniversaryElement]
    @Binding var selectedBirthdayElements: [BirthdayElement]
    @Binding var selectedChineseNewYearElements: [ChineseNewYearElement]
    @Binding var selectedDiwaliElements: [DiwaliElement]
    @Binding var selectedEasterElements: [EasterElement]
    @Binding var selectedEidAlAdhaElements: [EidAlAdhaElement]

    var body: some View {
        VStack(spacing: 20) {
            if selectedEvent.name == "Christmas" {
                ChristmasElementsContent(
                    selectedEvent: selectedEvent,
                    selectedChristmasElements: $selectedChristmasElements
                )
            } else if selectedEvent.name == "Easter" {
                EasterElementsContent(
                    selectedEvent: selectedEvent,
                    selectedEasterElements: $selectedEasterElements
                )
            } else if selectedEvent.name == "Anniversaries" {
                AnniversaryElementsContent(
                    selectedEvent: selectedEvent,
                    selectedAnniversaryElements: $selectedAnniversaryElements
                )
            } else if selectedEvent.name == "Rosh Hashanah" {
                RoshHashanahElementsContent(
                    selectedEvent: selectedEvent,
                    selectedRoshHashanahElements: $selectedRoshHashanahElements
                )
            } else if selectedEvent.name == "Vesak Day" {
                VesakDayElementsContent(
                    selectedEvent: selectedEvent,
                    selectedVesakDayElements: $selectedVesakDayElements
                )
            } else if selectedEvent.name == "Mid-Autumn Festival" {
                MidAutumnFestivalElementsContent(
                    selectedEvent: selectedEvent,
                    selectedMidAutumnFestivalElements: $selectedMidAutumnFestivalElements
                )
            } else if selectedEvent.name == "Hanukkah" {
                HanukkahElementsContent(
                    selectedEvent: selectedEvent,
                    selectedHanukkahElements: $selectedHanukkahElements
                )
            } else if selectedEvent.name == "Birthdays" {
                BirthdayElementsContent(
                    selectedEvent: selectedEvent,
                    selectedBirthdayElements: $selectedBirthdayElements
                )
            } else if selectedEvent.name == "Chinese New Year" {
                ChineseNewYearElementsContent(
                    selectedEvent: selectedEvent,
                    selectedChineseNewYearElements: $selectedChineseNewYearElements
                )
            } else if selectedEvent.name == "Diwali" {
                DiwaliElementsContent(
                    selectedEvent: selectedEvent,
                    selectedDiwaliElements: $selectedDiwaliElements
                )
            } else if selectedEvent.name == "Eid al-Adha" {
                EidAlAdhaElementsContent(
                    selectedEvent: selectedEvent,
                    selectedEidAlAdhaElements: $selectedEidAlAdhaElements
                )
            } else {
                DefaultElementsContent(selectedEvent: selectedEvent)
            }
        }
    }
}

// MARK: - Christmas Elements Content
struct ChristmasElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedChristmasElements: [ChristmasElement]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Design Elements")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select elements to enhance your Christmas gift design")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Centre Pieces Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Centre Pieces")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Text("Choose 1 primary element")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(ChristmasElement.centrePieces) { element in
                        ChristmasElementCard(
                            element: element,
                            isSelected: selectedChristmasElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleCentrePieceSelection(element)
                        }
                    }
                }
            }

            // Supporting Elements Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Supporting Elements")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Text("Optional decorative accents")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(ChristmasElement.supportingElements) { element in
                        ChristmasElementCard(
                            element: element,
                            isSelected: selectedChristmasElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleSupportingElementSelection(element)
                        }
                    }
                }
            }

            // Selection Summary
            if !selectedChristmasElements.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Elements:")
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    ForEach(selectedChristmasElements.sorted { $0.priority > $1.priority }) { element in
                        HStack {
                            Text("• \(element.name)")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)

                            Spacer()

                            Text(element.category.rawValue)
                                .font(.system(.caption2, design: .rounded))
                                .foregroundStyle(element.category == ChristmasElement.ElementCategory.centrePiece ? selectedEvent.category.primaryColor : .secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    element.category == ChristmasElement.ElementCategory.centrePiece ?
                                    selectedEvent.category.primaryColor.opacity(0.1) :
                                    .secondary.opacity(0.1),
                                    in: RoundedRectangle(cornerRadius: 4)
                                )
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
    }

    private func toggleCentrePieceSelection(_ element: ChristmasElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            // Remove any existing centre pieces
            selectedChristmasElements.removeAll { $0.category == ChristmasElement.ElementCategory.centrePiece }

            // Add the new centre piece
            if !selectedChristmasElements.contains(where: { $0.id == element.id }) {
                selectedChristmasElements.append(element)
            }
        }
    }

    private func toggleSupportingElementSelection(_ element: ChristmasElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let index = selectedChristmasElements.firstIndex(where: { $0.id == element.id }) {
                selectedChristmasElements.remove(at: index)
            } else {
                selectedChristmasElements.append(element)
            }
        }
    }
}

// MARK: - Chinese New Year Elements Content
struct ChineseNewYearElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedChineseNewYearElements: [ChineseNewYearElement]

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text("Design Elements")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select elements to enhance your Chinese New Year gift design")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Centre Pieces Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Centre Piece")
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)

                        Text("Select one main focal point for your design")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(ChineseNewYearElement.centrePieces) { element in
                        ChineseNewYearElementCard(
                            element: element,
                            isSelected: selectedChineseNewYearElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleCentrePieceSelection(element)
                        }
                    }
                }
            }

            // Supporting Elements Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Supporting Elements")
                            .font(.system(.headline, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)

                        Text("Add complementary elements to enhance your design")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(ChineseNewYearElement.supportingElements) { element in
                        ChineseNewYearElementCard(
                            element: element,
                            isSelected: selectedChineseNewYearElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleSupportingElementSelection(element)
                        }
                    }
                }
            }

            // Selection Summary
            if !selectedChineseNewYearElements.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Elements:")
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    ForEach(selectedChineseNewYearElements.sorted { $0.priority > $1.priority }) { element in
                        HStack {
                            Text("• \(element.name)")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.primary)

                            Spacer()

                            Text(element.category.rawValue)
                                .font(.system(.caption2, design: .rounded))
                                .foregroundStyle(element.category == ChineseNewYearElement.ElementCategory.centrePiece ? selectedEvent.category.primaryColor : .secondary)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(
                                    element.category == ChineseNewYearElement.ElementCategory.centrePiece ?
                                    selectedEvent.category.primaryColor.opacity(0.1) :
                                    .secondary.opacity(0.1),
                                    in: RoundedRectangle(cornerRadius: 4)
                                )
                        }
                    }
                }
                .padding(16)
                .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func toggleCentrePieceSelection(_ element: ChineseNewYearElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            // Remove any existing centre pieces
            selectedChineseNewYearElements.removeAll { $0.category == ChineseNewYearElement.ElementCategory.centrePiece }

            // Add the new centre piece
            if !selectedChineseNewYearElements.contains(where: { $0.id == element.id }) {
                selectedChineseNewYearElements.append(element)
            }
        }
    }

    private func toggleSupportingElementSelection(_ element: ChineseNewYearElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let index = selectedChineseNewYearElements.firstIndex(where: { $0.id == element.id }) {
                selectedChineseNewYearElements.remove(at: index)
            } else {
                selectedChineseNewYearElements.append(element)
            }
        }
    }
}

// MARK: - Chinese New Year Element Card
struct ChineseNewYearElementCard: View {
    let element: ChineseNewYearElement
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Element Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            isSelected ?
                            culturalColor.opacity(0.2) :
                            Color(.systemGray6)
                        )
                        .frame(height: 50)

                    Image(systemName: elementIcon)
                        .font(.title2)
                        .foregroundStyle(isSelected ? culturalColor : .secondary)
                }

                VStack(spacing: 4) {
                    Text(element.name)
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)

                    if element.category == ChineseNewYearElement.ElementCategory.centrePiece {
                        VStack {
                            HStack {
                                Spacer()

                                Text("CENTRE")
                                    .font(.system(.caption2, design: .rounded).weight(.bold))
                                    .foregroundStyle(culturalColor)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        culturalColor.opacity(0.1),
                                        in: RoundedRectangle(cornerRadius: 4)
                                    )

                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .stroke(
                        isSelected ? culturalColor : Color(.systemGray5),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
    }

    private var elementIcon: String {
        switch element.name {
        case "Dragon":
            return "flame"
        case "Lion Dance":
            return "theatermasks"
        case "Lanterns":
            return "lightbulb"
        case "Fireworks":
            return "sparkles"
        case "Plum Blossoms":
            return "leaf"
        case "Gold Coins":
            return "dollarsign.circle"
        case "Bamboo":
            return "tree"
        case "Fu Character":
            return "character.book.closed"
        default:
            return "star"
        }
    }
}

// MARK: - Christmas Element Card
struct ChristmasElementCard: View {
    let element: ChristmasElement
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                        .frame(height: 80)

                    VStack(spacing: 4) {
                        Image(systemName: elementIcon)
                            .font(.system(size: 24))
                            .foregroundStyle(
                                isSelected ?
                                culturalColor :
                                culturalColor.opacity(0.6)
                            )

                        Text(element.name)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }

                    if element.category == ChristmasElement.ElementCategory.centrePiece {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundStyle(.orange)
                            }
                            Spacer()
                        }
                        .padding(6)
                    }
                }
            }
            .padding(8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? culturalColor : .clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 4 : 2,
                y: isSelected ? 4 : 1
            )
        }
        .buttonStyle(.plain)
    }

    private var elementIcon: String {
        switch element.name {
        case "Christmas Tree":
            return "tree.fill"
        case "Santa":
            return "figure.wave"
        case "Angel":
            return "figure.arms.open"
        case "Star":
            return "star.fill"
        case "Holly":
            return "leaf.fill"
        case "Bells":
            return "bell.fill"
        case "Candy Canes":
            return "circle.and.line.horizontal.fill"
        case "Ornaments":
            return "circle.fill"
        default:
            return "sparkles"
        }
    }
}

// MARK: - Anniversary Element Card
struct AnniversaryElementCard: View {
    let element: AnniversaryElement
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                        .frame(height: 80)

                    VStack(spacing: 4) {
                        Image(systemName: elementIcon)
                            .font(.system(size: 24))
                            .foregroundStyle(
                                isSelected ?
                                culturalColor :
                                culturalColor.opacity(0.6)
                            )

                        Text(element.name)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }

                    if element.category == AnniversaryElement.ElementCategory.centrePiece {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "star.fill")
                                    .font(.system(size: 8))
                                    .foregroundStyle(.orange)
                            }
                            Spacer()
                        }
                        .padding(6)
                    }
                }
            }
            .padding(8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        isSelected ? culturalColor : .clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 4 : 2,
                y: isSelected ? 4 : 1
            )
        }
        .buttonStyle(.plain)
    }

    private var elementIcon: String {
        switch element.name {
        case "Hearts":
            return "heart.fill"
        case "Rings":
            return "circle.circle"
        case "Calendar":
            return "calendar"
        case "Trophy":
            return "trophy.fill"
        case "Flowers":
            return "leaf.fill"
        case "Champagne":
            return "wineglass"
        case "Confetti":
            return "sparkles"
        case "Ribbon":
            return "gift"
        default:
            return "sparkles"
        }
    }
}

// MARK: - Diwali Elements Content
struct DiwaliElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedDiwaliElements: [DiwaliElement]

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose design elements for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Centre Pieces Section
            VStack(spacing: 16) {
                Text("Centre Piece (takes precedence)")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                    ForEach(DiwaliElement.centrePieces, id: \.id) { element in
                        DiwaliElementCard(
                            element: element,
                            isSelected: selectedDiwaliElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleElement(element)
                        }
                    }
                }
            }

            // Supporting Elements Section
            VStack(spacing: 16) {
                Text("Supporting Elements")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 16) {
                    ForEach(DiwaliElement.supportingElements, id: \.id) { element in
                        DiwaliElementCard(
                            element: element,
                            isSelected: selectedDiwaliElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleElement(element)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }

    private func toggleElement(_ element: DiwaliElement) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if let index = selectedDiwaliElements.firstIndex(where: { $0.id == element.id }) {
                selectedDiwaliElements.remove(at: index)
            } else {
                selectedDiwaliElements.append(element)
            }
        }
    }
}

// MARK: - Diwali Element Card
struct DiwaliElementCard: View {
    let element: DiwaliElement
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Element preview
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                        .frame(height: 80)

                    VStack(spacing: 8) {
                        Image(systemName: elementIcon)
                            .font(.system(size: 20))
                            .foregroundStyle(culturalColor)

                        Text(element.name)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)

                        Text(element.category.rawValue)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(8)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.2) : .black.opacity(0.1),
                radius: isSelected ? 6 : 3,
                y: isSelected ? 4 : 1
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isSelected)
    }

    private var elementIcon: String {
        if element.name.lowercased().contains("diya") || element.name.lowercased().contains("lamp") {
            return "flame.fill"
        } else if element.name.lowercased().contains("lotus") {
            return "leaf.fill"
        } else if element.name.lowercased().contains("lakshmi") {
            return "sparkles"
        } else if element.name.lowercased().contains("fireworks") {
            return "sparkles"
        } else if element.name.lowercased().contains("rangoli") {
            return "circle.hexagonpath.fill"
        } else if element.name.lowercased().contains("marigold") {
            return "circle.fill"
        } else if element.name.lowercased().contains("om") {
            return "circle.fill"
        } else if element.name.lowercased().contains("gold") || element.name.lowercased().contains("coin") {
            return "dollarsign.circle.fill"
        } else {
            return "star.fill"
        }
    }
}

// MARK: - Anniversary Elements Content
struct AnniversaryElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedAnniversaryElements: [AnniversaryElement]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Design Elements")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select elements to enhance your Anniversary gift design")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Centre Pieces Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Centre Pieces")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Text("Choose 1 primary element")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(AnniversaryElement.centrePieces, id: \.id) { element in
                        AnniversaryElementCard(
                            element: element,
                            isSelected: selectedAnniversaryElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleAnniversaryElement(element, in: .centrePiece)
                        }
                    }
                }
            }

            // Supporting Elements Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Supporting Elements")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    Text("Choose up to 2 accents")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(AnniversaryElement.supportingElements, id: \.id) { element in
                        AnniversaryElementCard(
                            element: element,
                            isSelected: selectedAnniversaryElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleAnniversaryElement(element, in: .supportingElement)
                        }
                    }
                }
            }
        }
    }

    private func toggleAnniversaryElement(_ element: AnniversaryElement, in category: AnniversaryElement.ElementCategory) {
        if let index = selectedAnniversaryElements.firstIndex(where: { $0.id == element.id }) {
            // Remove if already selected
            selectedAnniversaryElements.remove(at: index)
        } else {
            // Add with category limits
            if category == .centrePiece {
                // Remove other centre pieces first (only 1 allowed)
                selectedAnniversaryElements.removeAll { $0.category == .centrePiece }
            } else {
                // Remove oldest supporting element if at limit (max 2)
                let supportingElements = selectedAnniversaryElements.filter { $0.category == .supportingElement }
                if supportingElements.count >= 2 {
                    if let oldestIndex = selectedAnniversaryElements.firstIndex(where: { $0.category == .supportingElement }) {
                        selectedAnniversaryElements.remove(at: oldestIndex)
                    }
                }
            }
            selectedAnniversaryElements.append(element)
        }
    }
}

// MARK: - Default Elements Content (Non-Christmas)
struct DefaultElementsContent: View {
    let selectedEvent: CulturalEvent

    var body: some View {
        VStack(spacing: 20) {
            Text("Elements")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            Text("Add cultural elements to your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Placeholder content
            RoundedRectangle(cornerRadius: 16)
                .fill(selectedEvent.category.primaryColor.opacity(0.1))
                .frame(height: 200)
                .overlay {
                    VStack(spacing: 12) {
                        Text(selectedEvent.category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(selectedEvent.category.primaryColor)

                        Text("Elements coming soon")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
        }
    }
}

// MARK: - Colour Tab Content
struct ColourTabContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedChristmasColorPalette: ChristmasColorPalette?
    @Binding var selectedAnniversaryColorPalette: AnniversaryColorPalette?
    @Binding var selectedBirthdayColorPalette: BirthdayColorPalette?
    @Binding var selectedChineseNewYearColorPalette: ChineseNewYearColorPalette?
    @Binding var selectedDiwaliColorPalette: DiwaliColorPalette?
    @Binding var selectedEasterColorPalette: EasterColorPalette?
    @Binding var selectedEidAlAdhaColorPalette: EidAlAdhaColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            if selectedEvent.name == "Christmas" {
                ChristmasColourContent(
                    selectedEvent: selectedEvent,
                    selectedChristmasColorPalette: $selectedChristmasColorPalette
                )
            } else if selectedEvent.name == "Easter" {
                EasterColourContent(
                    selectedEvent: selectedEvent,
                    selectedEasterColorPalette: $selectedEasterColorPalette
                )
            } else if selectedEvent.name == "Anniversaries" {
                AnniversaryColourContent(
                    selectedEvent: selectedEvent,
                    selectedAnniversaryColorPalette: $selectedAnniversaryColorPalette
                )
            } else if selectedEvent.name == "Rosh Hashanah" {
                RoshHashanahColourContent(
                    selectedEvent: selectedEvent,
                    selectedRoshHashanahColorPalette: $selectedRoshHashanahColorPalette
                )
            } else if selectedEvent.name == "Vesak Day" {
                VesakDayColourContent(
                    selectedEvent: selectedEvent,
                    selectedVesakDayColorPalette: $selectedVesakDayColorPalette
                )
            } else if selectedEvent.name == "Mid-Autumn Festival" {
                MidAutumnFestivalColourContent(
                    selectedEvent: selectedEvent,
                    selectedMidAutumnFestivalColorPalette: $selectedMidAutumnFestivalColorPalette
                )
            } else if selectedEvent.name == "Hanukkah" {
                HanukkahColourContent(
                    selectedEvent: selectedEvent,
                    selectedHanukkahColorPalette: $selectedHanukkahColorPalette
                )
            } else if selectedEvent.name == "Birthdays" {
                BirthdayColourContent(
                    selectedEvent: selectedEvent,
                    selectedBirthdayColorPalette: $selectedBirthdayColorPalette
                )
            } else if selectedEvent.name == "Chinese New Year" {
                ChineseNewYearColourContent(
                    selectedEvent: selectedEvent,
                    selectedChineseNewYearColorPalette: $selectedChineseNewYearColorPalette
                )
            } else if selectedEvent.name == "Diwali" {
                DiwaliColourContent(
                    selectedEvent: selectedEvent,
                    selectedDiwaliColorPalette: $selectedDiwaliColorPalette
                )
            } else if selectedEvent.name == "Eid al-Adha" {
                EidAlAdhaColourContent(
                    selectedEvent: selectedEvent,
                    selectedEidAlAdhaColorPalette: $selectedEidAlAdhaColorPalette
                )
            } else {
                DefaultColourContent(selectedEvent: selectedEvent)
            }
        }
    }
}

// MARK: - Christmas Colour Content
struct ChristmasColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedChristmasColorPalette: ChristmasColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Color Palettes")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select a color scheme that matches your Christmas vision")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Color Palettes Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(ChristmasColorPalette.allPalettes, id: \.id) { palette in
                    ChristmasColorPaletteCard(
                        palette: palette,
                        isSelected: selectedChristmasColorPalette?.id == palette.id,
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedChristmasColorPalette = palette
                        }
                    }
                }
            }

            // Selected Palette Info
            if let selectedPalette = selectedChristmasColorPalette {
                VStack(spacing: 12) {
                    Divider()

                    VStack(spacing: 8) {
                        Text("Selected: \(selectedPalette.name)")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(selectedPalette.description)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        // Color preview strip
                        HStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedPalette.swiftUIColors.primary)
                                .frame(height: 24)

                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedPalette.swiftUIColors.secondary)
                                .frame(height: 24)

                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedPalette.swiftUIColors.accent)
                                .frame(height: 24)
                        }
                        .frame(maxWidth: 150)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
    }
}

// MARK: - Christmas Color Palette Card
struct ChristmasColorPaletteCard: View {
    let palette: ChristmasColorPalette
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Color preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 100)

                    // Three color strips
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(palette.swiftUIColors.primary)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(palette.swiftUIColors.secondary)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(palette.swiftUIColors.accent)
                    }
                    .frame(height: 80)
                    .padding(.horizontal, 12)
                }

                // Palette info
                VStack(spacing: 4) {
                    Text(palette.name)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(palette.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 6 : 2
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Chinese New Year Colour Content
struct ChineseNewYearColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedChineseNewYearColorPalette: ChineseNewYearColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Color Palettes")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select a color scheme that matches your Chinese New Year vision")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Color Palettes Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(ChineseNewYearColorPalette.allPalettes, id: \.id) { palette in
                    ChineseNewYearColorPaletteCard(
                        palette: palette,
                        isSelected: selectedChineseNewYearColorPalette?.id == palette.id,
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedChineseNewYearColorPalette = palette
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Diwali Colour Content
struct DiwaliColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedDiwaliColorPalette: DiwaliColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Color Palettes")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select a color scheme that matches your Diwali vision")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Color Palettes Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(DiwaliColorPalette.allPalettes, id: \.id) { palette in
                    DiwaliColorPaletteCard(
                        palette: palette,
                        isSelected: selectedDiwaliColorPalette?.id == palette.id,
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedDiwaliColorPalette = palette
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Anniversary Colour Content
struct AnniversaryColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedAnniversaryColorPalette: AnniversaryColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Color Palettes")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select a color palette for your Anniversary gift")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Anniversary Color Palettes Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(AnniversaryColorPalette.allPalettes, id: \.id) { palette in
                    AnniversaryColorPaletteCard(
                        palette: palette,
                        isSelected: selectedAnniversaryColorPalette?.id == palette.id,
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedAnniversaryColorPalette = palette
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Chinese New Year Color Palette Card
struct ChineseNewYearColorPaletteCard: View {
    let palette: ChineseNewYearColorPalette
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Color preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 100)

                    // Three color strips
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(palette.primarySwiftUIColor)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(palette.secondarySwiftUIColor)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(palette.accentSwiftUIColor)
                    }
                    .frame(height: 80)
                    .padding(.horizontal, 12)
                }

                // Palette info
                VStack(spacing: 4) {
                    Text(palette.name)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(palette.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Diwali Color Palette Card
struct DiwaliColorPaletteCard: View {
    let palette: DiwaliColorPalette
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Color preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 100)

                    // Three color strips
                    HStack(spacing: 2) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(palette.swiftUIColors.primary)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(palette.swiftUIColors.secondary)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(palette.swiftUIColors.accent)
                    }
                    .frame(height: 80)
                    .padding(.horizontal, 12)
                }

                // Palette info
                VStack(spacing: 4) {
                    Text(palette.name)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)

                    Text(palette.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Anniversary Color Palette Card
struct AnniversaryColorPaletteCard: View {
    let palette: AnniversaryColorPalette
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Color preview
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(palette.swiftUIColors.primary)
                        .frame(height: 60)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(palette.swiftUIColors.secondary)
                        .frame(height: 60)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(palette.swiftUIColors.accent)
                        .frame(height: 60)
                }

                // Palette info
                VStack(spacing: 4) {
                    Text(palette.name)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)

                    Text(palette.description)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 6 : 2
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Default Colour Content (Non-Christmas)
struct DefaultColourContent: View {
    let selectedEvent: CulturalEvent

    var body: some View {
        VStack(spacing: 20) {
            Text("Colour")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            Text("Choose colors that represent your \(selectedEvent.name) celebration")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Placeholder content
            RoundedRectangle(cornerRadius: 16)
                .fill(selectedEvent.category.primaryColor.opacity(0.1))
                .frame(height: 200)
                .overlay {
                    VStack(spacing: 12) {
                        Text(selectedEvent.category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(selectedEvent.category.primaryColor)

                        Text("Color picker coming soon")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
        }
    }
}

// MARK: - Touch Tab Content
struct TouchTabContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedChristmasMessage: ChristmasPersonalTouch?
    @Binding var personalChristmasMessage: String
    @Binding var selectedAnniversaryMessage: AnniversaryPersonalTouch?
    @Binding var personalAnniversaryMessage: String
    @Binding var selectedBirthdayMessage: BirthdayPersonalTouch?
    @Binding var personalBirthdayMessage: String
    @Binding var selectedChineseNewYearMessage: ChineseNewYearPersonalTouch?
    @Binding var personalChineseNewYearMessage: String
    @Binding var selectedDiwaliMessage: DiwaliPersonalTouch?
    @Binding var personalDiwaliMessage: String
    @Binding var selectedEasterMessage: EasterPersonalTouch?
    @Binding var personalEasterMessage: String
    @Binding var selectedEidAlAdhaMessage: EidAlAdhaPersonalTouch?
    @Binding var personalEidAlAdhaMessage: String

    var body: some View {
        VStack(spacing: 20) {
            if selectedEvent.name == "Christmas" {
                ChristmasTouchContent(
                    selectedEvent: selectedEvent,
                    selectedChristmasMessage: $selectedChristmasMessage,
                    personalChristmasMessage: $personalChristmasMessage
                )
            } else if selectedEvent.name == "Easter" {
                EasterTouchContent(
                    selectedEvent: selectedEvent,
                    selectedEasterMessage: $selectedEasterMessage,
                    personalEasterMessage: $personalEasterMessage
                )
            } else if selectedEvent.name == "Anniversaries" {
                AnniversaryTouchContent(
                    selectedEvent: selectedEvent,
                    selectedAnniversaryMessage: $selectedAnniversaryMessage,
                    personalAnniversaryMessage: $personalAnniversaryMessage
                )
            } else if selectedEvent.name == "Rosh Hashanah" {
                RoshHashanahTouchContent(
                    selectedEvent: selectedEvent,
                    selectedRoshHashanahMessage: $selectedRoshHashanahMessage,
                    personalRoshHashanahMessage: $personalRoshHashanahMessage
                )
            } else if selectedEvent.name == "Vesak Day" {
                VesakDayTouchContent(
                    selectedEvent: selectedEvent,
                    selectedVesakDayMessage: $selectedVesakDayMessage,
                    personalVesakDayMessage: $personalVesakDayMessage
                )
            } else if selectedEvent.name == "Mid-Autumn Festival" {
                MidAutumnFestivalTouchContent(
                    selectedEvent: selectedEvent,
                    selectedMidAutumnFestivalMessage: $selectedMidAutumnFestivalMessage,
                    personalMidAutumnFestivalMessage: $personalMidAutumnFestivalMessage
                )
            } else if selectedEvent.name == "Hanukkah" {
                HanukkahTouchContent(
                    selectedEvent: selectedEvent,
                    selectedHanukkahMessage: $selectedHanukkahMessage,
                    personalHanukkahMessage: $personalHanukkahMessage
                )
            } else if selectedEvent.name == "Birthdays" {
                BirthdayTouchContent(
                    selectedEvent: selectedEvent,
                    selectedBirthdayMessage: $selectedBirthdayMessage,
                    personalBirthdayMessage: $personalBirthdayMessage
                )
            } else if selectedEvent.name == "Chinese New Year" {
                ChineseNewYearTouchContent(
                    selectedEvent: selectedEvent,
                    selectedChineseNewYearMessage: $selectedChineseNewYearMessage,
                    personalChineseNewYearMessage: $personalChineseNewYearMessage
                )
            } else if selectedEvent.name == "Diwali" {
                DiwaliTouchContent(
                    selectedEvent: selectedEvent,
                    selectedDiwaliMessage: $selectedDiwaliMessage,
                    personalDiwaliMessage: $personalDiwaliMessage
                )
            } else if selectedEvent.name == "Eid al-Adha" {
                EidAlAdhaTouchContent(
                    selectedEvent: selectedEvent,
                    selectedEidAlAdhaMessage: $selectedEidAlAdhaMessage,
                    personalEidAlAdhaMessage: $personalEidAlAdhaMessage
                )
            } else {
                DefaultTouchContent(selectedEvent: selectedEvent)
            }
        }
    }
}

// MARK: - Christmas Touch Content
struct ChristmasTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedChristmasMessage: ChristmasPersonalTouch?
    @Binding var personalChristmasMessage: String

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Personal Touch")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Add a heartfelt message to make your Christmas gift truly personal")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Optional Messages Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Choose a Christmas Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    if selectedChristmasMessage != nil {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedChristmasMessage = nil
                            }
                        }
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 1), spacing: 12) {
                    ForEach(ChristmasPersonalTouch.optionalMessages) { message in
                        ChristmasMessageCard(
                            message: message,
                            isSelected: selectedChristmasMessage?.id == message.id,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedChristmasMessage?.id == message.id {
                                    selectedChristmasMessage = nil
                                } else {
                                    selectedChristmasMessage = message
                                    // Clear personal message if optional message is selected
                                    personalChristmasMessage = ""
                                }
                            }
                        }
                    }
                }
            }

            // Divider with "OR"
            HStack {
                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 1)

                Text("OR")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)

                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 1)
            }

            // Personal Message Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Write Your Own Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    if !personalChristmasMessage.isEmpty {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                personalChristmasMessage = ""
                            }
                        }
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.regularMaterial)
                            .frame(minHeight: 100)

                        if personalChristmasMessage.isEmpty {
                            Text(ChristmasPersonalTouch.personalMessagePlaceholder)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.top, 12)
                        }

                        TextEditor(text: $personalChristmasMessage)
                            .font(.system(.body, design: .rounded))
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .onChange(of: personalChristmasMessage) { _, newValue in
                                // Clear selected optional message if user types
                                if !newValue.isEmpty && selectedChristmasMessage != nil {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedChristmasMessage = nil
                                    }
                                }

                                // Enforce character limit
                                if newValue.count > ChristmasPersonalTouch.maxPersonalMessageLength {
                                    personalChristmasMessage = String(newValue.prefix(ChristmasPersonalTouch.maxPersonalMessageLength))
                                }
                            }
                    }

                    HStack {
                        Spacer()
                        Text("\(personalChristmasMessage.count)/\(ChristmasPersonalTouch.maxPersonalMessageLength)")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // Selection Status
            if selectedChristmasMessage != nil || !personalChristmasMessage.isEmpty {
                VStack(spacing: 8) {
                    Divider()

                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                        Text("Personal message added")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Christmas Message Card
struct ChristmasMessageCard: View {
    let message: ChristmasPersonalTouch
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Tone color indicator
                RoundedRectangle(cornerRadius: 4)
                    .fill(message.tone.color)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(message.tone.rawValue)
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(message.tone.color)

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.system(size: 16))
                        }
                    }

                    Text(message.message)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.05),
                radius: isSelected ? 4 : 2,
                y: isSelected ? 3 : 1
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Chinese New Year Touch Content
struct ChineseNewYearTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedChineseNewYearMessage: ChineseNewYearPersonalTouch?
    @Binding var personalChineseNewYearMessage: String

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Personal Touch")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Add a heartfelt message to make your Chinese New Year gift truly personal")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Optional Messages Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Choose a Chinese New Year Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    if selectedChineseNewYearMessage != nil {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedChineseNewYearMessage = nil
                            }
                        }
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(ChineseNewYearPersonalTouch.optionalMessages, id: \.id) { message in
                        ChineseNewYearMessageCard(
                            message: message,
                            isSelected: selectedChineseNewYearMessage?.id == message.id,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedChineseNewYearMessage = selectedChineseNewYearMessage?.id == message.id ? nil : message
                            }
                        }
                    }
                }
            }

            // Personal Message Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Or Write Your Own Message")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                TextEditor(text: $personalChineseNewYearMessage)
                    .frame(minHeight: 100)
                    .padding(12)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.tertiary, lineWidth: 1)
                    )
                    .overlay(alignment: .topLeading) {
                        if personalChineseNewYearMessage.isEmpty {
                            Text(ChineseNewYearPersonalTouch.personalMessagePlaceholder)
                                .foregroundStyle(.secondary)
                                .font(.system(.body, design: .rounded))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 20)
                                .allowsHitTesting(false)
                        }
                    }

                Text("\(personalChineseNewYearMessage.count)/\(ChineseNewYearPersonalTouch.maxPersonalMessageLength)")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(personalChineseNewYearMessage.count > ChineseNewYearPersonalTouch.maxPersonalMessageLength ? .red : .secondary)
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Diwali Touch Content
struct DiwaliTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedDiwaliMessage: DiwaliPersonalTouch?
    @Binding var personalDiwaliMessage: String

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Personal Touch")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Add a heartfelt message to make your Diwali gift truly personal")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Optional Messages Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Choose a Diwali Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    if selectedDiwaliMessage != nil {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedDiwaliMessage = nil
                            }
                        }
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(DiwaliPersonalTouch.optionalMessages, id: \.id) { message in
                        DiwaliMessageCard(
                            message: message,
                            isSelected: selectedDiwaliMessage?.id == message.id,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedDiwaliMessage = selectedDiwaliMessage?.id == message.id ? nil : message
                            }
                        }
                    }
                }
            }

            // Personal Message Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Or Write Your Own Message")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                TextEditor(text: $personalDiwaliMessage)
                    .frame(minHeight: 100)
                    .padding(12)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.tertiary, lineWidth: 1)
                    )
                    .overlay(alignment: .topLeading) {
                        if personalDiwaliMessage.isEmpty {
                            Text(DiwaliPersonalTouch.personalMessagePlaceholder)
                                .foregroundStyle(.secondary)
                                .font(.system(.body, design: .rounded))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 20)
                                .allowsHitTesting(false)
                        }
                    }

                Text("\(personalDiwaliMessage.count)/\(DiwaliPersonalTouch.maxPersonalMessageLength)")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(personalDiwaliMessage.count > DiwaliPersonalTouch.maxPersonalMessageLength ? .red : .secondary)
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Anniversary Touch Content
struct AnniversaryTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedAnniversaryMessage: AnniversaryPersonalTouch?
    @Binding var personalAnniversaryMessage: String

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Personal Touch")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Add a heartfelt message to make your Anniversary gift truly personal")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Optional Messages Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Choose an Anniversary Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    if selectedAnniversaryMessage != nil {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedAnniversaryMessage = nil
                            }
                        }
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 1), spacing: 12) {
                    ForEach(AnniversaryPersonalTouch.optionalMessages) { message in
                        AnniversaryMessageCard(
                            message: message,
                            isSelected: selectedAnniversaryMessage?.id == message.id,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedAnniversaryMessage?.id == message.id {
                                    selectedAnniversaryMessage = nil
                                } else {
                                    selectedAnniversaryMessage = message
                                    // Clear personal message if optional message is selected
                                    personalAnniversaryMessage = ""
                                }
                            }
                        }
                    }
                }
            }

            // Divider with "OR"
            HStack {
                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 1)

                Text("OR")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)

                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 1)
            }

            // Personal Message Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Write Your Own Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    if !personalAnniversaryMessage.isEmpty {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                personalAnniversaryMessage = ""
                            }
                        }
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.regularMaterial)
                            .frame(minHeight: 100)

                        if personalAnniversaryMessage.isEmpty {
                            Text(AnniversaryPersonalTouch.personalMessagePlaceholder)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.top, 12)
                        }

                        TextEditor(text: $personalAnniversaryMessage)
                            .font(.system(.body, design: .rounded))
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .onChange(of: personalAnniversaryMessage) { _, newValue in
                                // Clear selected optional message if user types
                                if !newValue.isEmpty && selectedAnniversaryMessage != nil {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedAnniversaryMessage = nil
                                    }
                                }

                                // Enforce character limit
                                if newValue.count > AnniversaryPersonalTouch.maxPersonalMessageLength {
                                    personalAnniversaryMessage = String(newValue.prefix(AnniversaryPersonalTouch.maxPersonalMessageLength))
                                }
                            }
                    }

                    HStack {
                        Spacer()
                        Text("\(personalAnniversaryMessage.count)/\(AnniversaryPersonalTouch.maxPersonalMessageLength)")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // Selection Status
            if selectedAnniversaryMessage != nil || !personalAnniversaryMessage.isEmpty {
                VStack(spacing: 8) {
                    Divider()

                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                        Text("Personal message added")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                }
            }
        }
    }
}

// MARK: - Chinese New Year Message Card
struct ChineseNewYearMessageCard: View {
    let message: ChineseNewYearPersonalTouch
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Tone color indicator
                RoundedRectangle(cornerRadius: 4)
                    .fill(message.tone.color)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(message.tone.rawValue)
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(message.tone.color)

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.system(size: 16))
                        }
                    }

                    Text(message.message)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.05),
                radius: isSelected ? 4 : 2,
                x: 0,
                y: 2
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Diwali Message Card
struct DiwaliMessageCard: View {
    let message: DiwaliPersonalTouch
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Tone color indicator
                RoundedRectangle(cornerRadius: 4)
                    .fill(message.tone.color)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(message.tone.rawValue)
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(message.tone.color)

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.system(size: 16))
                        }
                    }

                    Text(message.message)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.05),
                radius: isSelected ? 4 : 2,
                x: 0,
                y: 2
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Anniversary Message Card
struct AnniversaryMessageCard: View {
    let message: AnniversaryPersonalTouch
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // Tone color indicator
                RoundedRectangle(cornerRadius: 4)
                    .fill(message.tone.color)
                    .frame(width: 4)

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(message.tone.rawValue)
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(message.tone.color)

                        Spacer()

                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.green)
                                .font(.system(size: 16))
                        }
                    }

                    Text(message.message)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.05),
                radius: isSelected ? 4 : 2,
                y: isSelected ? 3 : 1
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Default Touch Content (Non-Christmas)
struct DefaultTouchContent: View {
    let selectedEvent: CulturalEvent

    var body: some View {
        VStack(spacing: 20) {
            Text("Touch")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            Text("Add personal touches to make your \(selectedEvent.name) gift unique")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Placeholder content
            RoundedRectangle(cornerRadius: 16)
                .fill(selectedEvent.category.primaryColor.opacity(0.1))
                .frame(height: 200)
                .overlay {
                    VStack(spacing: 12) {
                        Text(selectedEvent.category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(selectedEvent.category.primaryColor)

                        Text("Personal touches coming soon")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
        }
    }
}

// MARK: - Create Tab Content
struct CreateTabContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedChristmasTheme: ChristmasTheme?
    let selectedChristmasElements: [ChristmasElement]
    let selectedChristmasColorPalette: ChristmasColorPalette?
    let selectedChristmasMessage: ChristmasPersonalTouch?
    let personalChristmasMessage: String
    let selectedAnniversaryTheme: AnniversaryTheme?
    let selectedAnniversaryElements: [AnniversaryElement]
    let selectedAnniversaryColorPalette: AnniversaryColorPalette?
    let selectedAnniversaryMessage: AnniversaryPersonalTouch?
    let personalAnniversaryMessage: String
    let selectedBirthdayTheme: BirthdayTheme?
    let selectedBirthdayElements: [BirthdayElement]
    let selectedBirthdayColorPalette: BirthdayColorPalette?
    let selectedBirthdayMessage: BirthdayPersonalTouch?
    let personalBirthdayMessage: String
    let selectedChineseNewYearTheme: ChineseNewYearTheme?
    let selectedChineseNewYearElements: [ChineseNewYearElement]
    let selectedChineseNewYearColorPalette: ChineseNewYearColorPalette?
    let selectedChineseNewYearMessage: ChineseNewYearPersonalTouch?
    let personalChineseNewYearMessage: String
    let selectedDiwaliTheme: DiwaliTheme?
    let selectedDiwaliElements: [DiwaliElement]
    let selectedDiwaliColorPalette: DiwaliColorPalette?
    let selectedDiwaliMessage: DiwaliPersonalTouch?
    let personalDiwaliMessage: String
    let selectedEasterTheme: EasterTheme?
    let selectedEasterElements: [EasterElement]
    let selectedEasterColorPalette: EasterColorPalette?
    let selectedEasterMessage: EasterPersonalTouch?
    let personalEasterMessage: String
    let selectedEidAlAdhaTheme: EidAlAdhaTheme?
    let selectedEidAlAdhaElements: [EidAlAdhaElement]
    let selectedEidAlAdhaColorPalette: EidAlAdhaColorPalette?
    let selectedEidAlAdhaMessage: EidAlAdhaPersonalTouch?
    let personalEidAlAdhaMessage: String

    var body: some View {
        VStack(spacing: 20) {
            if selectedEvent.name == "Christmas" {
                ChristmasCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedChristmasTheme: selectedChristmasTheme,
                    selectedChristmasElements: selectedChristmasElements,
                    selectedChristmasColorPalette: selectedChristmasColorPalette,
                    selectedChristmasMessage: selectedChristmasMessage,
                    personalChristmasMessage: personalChristmasMessage
                )
            } else if selectedEvent.name == "Easter" {
                EasterCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedEasterTheme: selectedEasterTheme,
                    selectedEasterElements: selectedEasterElements,
                    selectedEasterColorPalette: selectedEasterColorPalette,
                    selectedEasterMessage: selectedEasterMessage,
                    personalEasterMessage: personalEasterMessage
                )
            } else if selectedEvent.name == "Anniversaries" {
                AnniversaryCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedAnniversaryTheme: selectedAnniversaryTheme,
                    selectedAnniversaryElements: selectedAnniversaryElements,
                    selectedAnniversaryColorPalette: selectedAnniversaryColorPalette,
                    selectedAnniversaryMessage: selectedAnniversaryMessage,
                    personalAnniversaryMessage: personalAnniversaryMessage
                )
            } else if selectedEvent.name == "Rosh Hashanah" {
                RoshHashanahCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedRoshHashanahTheme: selectedRoshHashanahTheme,
                    selectedRoshHashanahElements: selectedRoshHashanahElements,
                    selectedRoshHashanahColorPalette: selectedRoshHashanahColorPalette,
                    selectedRoshHashanahMessage: selectedRoshHashanahMessage,
                    personalRoshHashanahMessage: personalRoshHashanahMessage
                )
            } else if selectedEvent.name == "Vesak Day" {
                VesakDayCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedVesakDayTheme: selectedVesakDayTheme,
                    selectedVesakDayElements: selectedVesakDayElements,
                    selectedVesakDayColorPalette: selectedVesakDayColorPalette,
                    selectedVesakDayMessage: selectedVesakDayMessage,
                    personalVesakDayMessage: personalVesakDayMessage
                )
            } else if selectedEvent.name == "Mid-Autumn Festival" {
                MidAutumnFestivalCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedMidAutumnFestivalTheme: selectedMidAutumnFestivalTheme,
                    selectedMidAutumnFestivalElements: selectedMidAutumnFestivalElements,
                    selectedMidAutumnFestivalColorPalette: selectedMidAutumnFestivalColorPalette,
                    selectedMidAutumnFestivalMessage: selectedMidAutumnFestivalMessage,
                    personalMidAutumnFestivalMessage: personalMidAutumnFestivalMessage
                )
            } else if selectedEvent.name == "Hanukkah" {
                HanukkahCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedHanukkahTheme: selectedHanukkahTheme,
                    selectedHanukkahElements: selectedHanukkahElements,
                    selectedHanukkahColorPalette: selectedHanukkahColorPalette,
                    selectedHanukkahMessage: selectedHanukkahMessage,
                    personalHanukkahMessage: personalHanukkahMessage
                )
            } else if selectedEvent.name == "Birthdays" {
                BirthdayCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedBirthdayTheme: selectedBirthdayTheme,
                    selectedBirthdayElements: selectedBirthdayElements,
                    selectedBirthdayColorPalette: selectedBirthdayColorPalette,
                    selectedBirthdayMessage: selectedBirthdayMessage,
                    personalBirthdayMessage: personalBirthdayMessage
                )
            } else if selectedEvent.name == "Chinese New Year" {
                ChineseNewYearCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedChineseNewYearTheme: selectedChineseNewYearTheme,
                    selectedChineseNewYearElements: selectedChineseNewYearElements,
                    selectedChineseNewYearColorPalette: selectedChineseNewYearColorPalette,
                    selectedChineseNewYearMessage: selectedChineseNewYearMessage,
                    personalChineseNewYearMessage: personalChineseNewYearMessage
                )
            } else if selectedEvent.name == "Diwali" {
                DiwaliCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedDiwaliTheme: selectedDiwaliTheme,
                    selectedDiwaliElements: selectedDiwaliElements,
                    selectedDiwaliColorPalette: selectedDiwaliColorPalette,
                    selectedDiwaliMessage: selectedDiwaliMessage,
                    personalDiwaliMessage: personalDiwaliMessage
                )
            } else if selectedEvent.name == "Eid al-Adha" {
                EidAlAdhaCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift,
                    selectedEidAlAdhaTheme: selectedEidAlAdhaTheme,
                    selectedEidAlAdhaElements: selectedEidAlAdhaElements,
                    selectedEidAlAdhaColorPalette: selectedEidAlAdhaColorPalette,
                    selectedEidAlAdhaMessage: selectedEidAlAdhaMessage,
                    personalEidAlAdhaMessage: personalEidAlAdhaMessage
                )
            } else {
                DefaultCreateContent(
                    selectedEvent: selectedEvent,
                    selectedGift: selectedGift
                )
            }
        }
    }
}

// MARK: - Christmas Create Content
struct ChristmasCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedChristmasTheme: ChristmasTheme?
    let selectedChristmasElements: [ChristmasElement]
    let selectedChristmasColorPalette: ChristmasColorPalette?
    let selectedChristmasMessage: ChristmasPersonalTouch?
    let personalChristmasMessage: String

    private var christmasSelectionState: ChristmasSelectionState {
        ChristmasSelectionState(
            selectedTheme: selectedChristmasTheme,
            selectedGift: selectedGift?.name,
            selectedElements: selectedChristmasElements,
            selectedColorPalette: selectedChristmasColorPalette,
            selectedOptionalMessage: selectedChristmasMessage,
            personalMessage: personalChristmasMessage
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Your Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Review your selections and generate your personalized Christmas gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Selection Summary
                VStack(spacing: 16) {
                    // Style Summary
                    if let theme = selectedChristmasTheme, let gift = selectedGift {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "\(theme.rawValue) - \(gift.name)",
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "Please select a theme and gift style",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Elements Summary
                    if !selectedChristmasElements.isEmpty {
                        let elementNames = selectedChristmasElements.map { $0.name }.joined(separator: ", ")
                        SelectionSummaryCard(
                            title: "Elements",
                            content: elementNames,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Elements",
                            content: "Please select design elements",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Color Summary
                    if let palette = selectedChristmasColorPalette {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: palette.name,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            HStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(palette.swiftUIColors.primary)
                                    .frame(width: 16, height: 16)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(palette.swiftUIColors.secondary)
                                    .frame(width: 16, height: 16)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(palette.swiftUIColors.accent)
                                    .frame(width: 16, height: 16)
                            }
                        }
                    } else {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: "Please select a color palette",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Personal Touch Summary
                    let hasPersonalTouch = selectedChristmasMessage != nil || !personalChristmasMessage.isEmpty
                    if hasPersonalTouch {
                        let message = selectedChristmasMessage?.message ?? personalChristmasMessage
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: message,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: "Please add a personal message",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }
                }

                // Generation Button
                VStack(spacing: 16) {
                    Divider()

                    if christmasSelectionState.isComplete {
                        Button(action: {
                            // TODO: Implement AI generation
                        }) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                    .font(.system(.body, design: .rounded).weight(.semibold))

                                Text("Generate Your Personal Designer Gift")
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(selectedEvent.category.primaryColor, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .scaleEffect(1.0)
                        .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 8, y: 4)

                        Text("AI will create your unique Christmas gift based on your selections")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    } else {
                        VStack(spacing: 12) {
                            Text("Complete Your Selections")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text("Please complete all steps above to generate your Christmas gift")
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            Button("Generate Your Personal Designer Gift") {
                                // Disabled state - no action
                            }
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(.secondary.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))
                            .disabled(true)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Selection Summary Card
struct SelectionSummaryCard<Content: View>: View {
    let title: String
    let content: String
    let isComplete: Bool
    let culturalColor: Color
    let accessory: (() -> Content)?

    init(
        title: String,
        content: String,
        isComplete: Bool,
        culturalColor: Color,
        @ViewBuilder accessory: @escaping () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.content = content
        self.isComplete = isComplete
        self.culturalColor = culturalColor
        self.accessory = accessory
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                if isComplete {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                } else {
                    Image(systemName: "circle")
                        .foregroundStyle(.secondary)
                }
            }

            HStack {
                Text(content)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(isComplete ? .primary : .secondary)
                    .multilineTextAlignment(.leading)

                Spacer()

                if let accessory = accessory {
                    accessory()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(isComplete ? culturalColor.opacity(0.3) : .clear, lineWidth: 1)
        }
    }
}

// MARK: - Chinese New Year Create Content
struct ChineseNewYearCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedChineseNewYearTheme: ChineseNewYearTheme?
    let selectedChineseNewYearElements: [ChineseNewYearElement]
    let selectedChineseNewYearColorPalette: ChineseNewYearColorPalette?
    let selectedChineseNewYearMessage: ChineseNewYearPersonalTouch?
    let personalChineseNewYearMessage: String

    private var chineseNewYearSelectionState: ChineseNewYearSelectionState {
        ChineseNewYearSelectionState(
            selectedTheme: selectedChineseNewYearTheme,
            selectedGift: selectedGift?.name,
            selectedElements: selectedChineseNewYearElements,
            selectedColorPalette: selectedChineseNewYearColorPalette,
            selectedOptionalMessage: selectedChineseNewYearMessage,
            personalMessage: personalChineseNewYearMessage
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Your Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Review your selections and generate your personalized Chinese New Year gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Selection Summary
                if chineseNewYearSelectionState.isComplete {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Selections")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(chineseNewYearSelectionState.summary)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(16)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }

                    // Generate Button
                    Button(action: {
                        // Generate action will be implemented
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "wand.and.stars")
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Generate Your Personal Designer Gift")
                                    .font(.system(.body, design: .rounded).weight(.semibold))

                                Text("Create your unique Chinese New Year greeting")
                                    .font(.system(.caption, design: .rounded))
                                    .opacity(0.8)
                            }

                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [selectedEvent.category.primaryColor, selectedEvent.category.primaryColor.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: RoundedRectangle(cornerRadius: 16)
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    // Incomplete Selection Message
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 40))
                            .foregroundStyle(.orange)

                        Text("Complete Your Selections")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text("Please go back and complete all the previous steps to generate your Chinese New Year gift")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Diwali Create Content
struct DiwaliCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedDiwaliTheme: DiwaliTheme?
    let selectedDiwaliElements: [DiwaliElement]
    let selectedDiwaliColorPalette: DiwaliColorPalette?
    let selectedDiwaliMessage: DiwaliPersonalTouch?
    let personalDiwaliMessage: String

    private var diwaliSelectionState: DiwaliSelectionState {
        DiwaliSelectionState(
            selectedTheme: selectedDiwaliTheme,
            selectedGift: selectedGift?.name,
            selectedElements: selectedDiwaliElements,
            selectedColorPalette: selectedDiwaliColorPalette,
            selectedOptionalMessage: selectedDiwaliMessage,
            personalMessage: personalDiwaliMessage
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Your Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Review your selections and generate your personalized Diwali gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Selection Summary
                if diwaliSelectionState.isComplete {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your Selections")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(diwaliSelectionState.summary)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding(16)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                    }

                    // Generate Button
                    Button(action: {
                        // Generate action will be implemented
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "wand.and.stars")
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 2) {
                                Text("Generate Your Personal Designer Gift")
                                    .font(.system(.body, design: .rounded).weight(.semibold))

                                Text("Create your unique Diwali greeting")
                                    .font(.system(.caption, design: .rounded))
                                    .opacity(0.8)
                            }

                            Spacer()
                        }
                        .foregroundStyle(.white)
                        .padding(20)
                        .background(
                            LinearGradient(
                                colors: [selectedEvent.category.primaryColor, selectedEvent.category.primaryColor.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            in: RoundedRectangle(cornerRadius: 16)
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    // Incomplete Selection Message
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.circle")
                            .font(.system(size: 40))
                            .foregroundStyle(.orange)

                        Text("Complete Your Selections")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text("Please go back and complete all the previous steps to generate your Diwali gift")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(24)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Anniversary Create Content
struct AnniversaryCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedAnniversaryTheme: AnniversaryTheme?
    let selectedAnniversaryElements: [AnniversaryElement]
    let selectedAnniversaryColorPalette: AnniversaryColorPalette?
    let selectedAnniversaryMessage: AnniversaryPersonalTouch?
    let personalAnniversaryMessage: String

    private var anniversarySelectionState: AnniversarySelectionState {
        AnniversarySelectionState(
            selectedTheme: selectedAnniversaryTheme,
            selectedGift: selectedGift?.name,
            selectedElements: selectedAnniversaryElements,
            selectedColorPalette: selectedAnniversaryColorPalette,
            selectedOptionalMessage: selectedAnniversaryMessage,
            personalMessage: personalAnniversaryMessage
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Your Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Review your selections and generate your personalized Anniversary gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Selection Summary
                VStack(spacing: 16) {
                    // Style Summary
                    if let theme = selectedAnniversaryTheme, let gift = selectedGift {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "\(theme.rawValue) - \(gift.name)",
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "Please select a theme and gift style",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Elements Summary
                    if !selectedAnniversaryElements.isEmpty {
                        let elementNames = selectedAnniversaryElements.map { $0.name }.joined(separator: ", ")
                        SelectionSummaryCard(
                            title: "Elements",
                            content: elementNames,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Elements",
                            content: "Please select design elements",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Color Summary
                    if let palette = selectedAnniversaryColorPalette {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: palette.name,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            HStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(palette.swiftUIColors.primary)
                                    .frame(width: 16, height: 16)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(palette.swiftUIColors.secondary)
                                    .frame(width: 16, height: 16)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(palette.swiftUIColors.accent)
                                    .frame(width: 16, height: 16)
                            }
                        }
                    } else {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: "Please select a color palette",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Personal Touch Summary
                    let hasPersonalTouch = selectedAnniversaryMessage != nil || !personalAnniversaryMessage.isEmpty
                    if hasPersonalTouch {
                        let message = selectedAnniversaryMessage?.message ?? personalAnniversaryMessage
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: message,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: "Please add a personal message",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }
                }

                // Generation Button
                VStack(spacing: 16) {
                    Divider()

                    if anniversarySelectionState.isComplete {
                        Button(action: {
                            // TODO: Implement AI generation
                        }) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                    .font(.system(.body, design: .rounded).weight(.semibold))

                                Text("Generate Your Personal Designer Gift")
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(selectedEvent.category.primaryColor, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .scaleEffect(1.0)
                        .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 8, y: 4)

                        Text("AI will create your unique Anniversary gift based on your selections")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    } else {
                        VStack(spacing: 12) {
                            Text("Complete Your Selections")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text("Please complete all steps above to generate your Anniversary gift")
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            Button("Generate Your Personal Designer Gift") {
                                // Disabled state - no action
                            }
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(.secondary.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))
                            .disabled(true)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Default Create Content (Non-Christmas)
struct DefaultCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?

    var body: some View {
        VStack(spacing: 20) {
            Text("Create")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            Text("Generate your personalized \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Placeholder content
            RoundedRectangle(cornerRadius: 16)
                .fill(selectedEvent.category.primaryColor.opacity(0.1))
                .frame(height: 200)
                .overlay {
                    VStack(spacing: 12) {
                        Text(selectedEvent.category.icon)
                            .font(.system(size: 40))
                            .foregroundStyle(selectedEvent.category.primaryColor)

                        Text("AI generation coming soon")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)
                    }
                }
        }
    }
}

// MARK: - Check Tab Content
struct CheckTabContent: View {
    let selectedEvent: CulturalEvent
    let selectedContact: Contact

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Check Your Gift")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Your personalized \(selectedEvent.name) gift is ready!")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Event-specific Image Preview
            if selectedEvent.name == "Christmas" {
                VStack(spacing: 16) {
                    // Dummy Christmas Image
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#C41E3A"),
                                    Color(hex: "#228B22"),
                                    Color(hex: "#FFD700")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 300)
                        .overlay {
                            VStack(spacing: 12) {
                                Text("🎄")
                                    .font(.system(size: 60))

                                Text("Beautiful Christmas Gift")
                                    .font(.system(.title3, design: .rounded).weight(.bold))
                                    .foregroundStyle(.white)

                                Text("Generated with your personal selections")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 12, y: 6)

                    // Personal Message
                    VStack(spacing: 8) {
                        Text("Your Personal Message:")
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(.secondary)

                        Text("Merry Christmas and Happy New Year!")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            } else if selectedEvent.name == "Easter" {
                VStack(spacing: 16) {
                    // Dummy Easter Image
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#FFB6C1"),
                                    Color(hex: "#ADD8E6"),
                                    Color(hex: "#98FB98")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 300)
                        .overlay {
                            VStack(spacing: 12) {
                                Text("✝️")
                                    .font(.system(size: 60))

                                Text("Beautiful Easter Gift")
                                    .font(.system(.title3, design: .rounded).weight(.bold))
                                    .foregroundStyle(.white)

                                Text("Generated with your personal selections")
                                    .font(.system(.caption, design: .rounded))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 12, y: 6)

                    // Personal Message
                    VStack(spacing: 8) {
                        Text("Your Personal Message:")
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(.secondary)

                        Text("He is risen! Wishing you a blessed Easter")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            } else if selectedEvent.name == "Birthdays" {
                VStack(spacing: 16) {
                    // Dummy Birthday Image
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#FF69B4"),
                                    Color(hex: "#FFD700"),
                                    Color(hex: "#FFFFFF")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 250)
                        .overlay {
                            VStack(spacing: 8) {
                                Text("🎂")
                                    .font(.system(size: 40))

                                Text("Birthday Gift")
                                    .font(.system(.title3, design: .rounded).weight(.bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 12, y: 6)

                    // Personal Message
                    VStack(spacing: 8) {
                        Text("Your Personal Message:")
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(.secondary)

                        Text("Wishing you a fantastic birthday filled with joy!")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
            } else {
                // Default preview for other cultures
                RoundedRectangle(cornerRadius: 16)
                    .fill(selectedEvent.category.primaryColor.opacity(0.1))
                    .frame(height: 300)
                    .overlay {
                        VStack(spacing: 12) {
                            Text(selectedEvent.category.icon)
                                .font(.system(size: 40))
                                .foregroundStyle(selectedEvent.category.primaryColor)

                            Text("Preview coming soon")
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .foregroundStyle(.secondary)
                        }
                    }
            }

            // Status
            VStack(spacing: 16) {
                Divider()

                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)

                    Text("Watch and Phone Background Ready")
                        .font(.system(.body, design: .rounded).weight(.medium))
                        .foregroundStyle(.primary)

                    Spacer()
                }

                Text("Your gift is optimized for both Apple Watch and iPhone backgrounds")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Send Tab Content
struct SendTabContent: View {
    let selectedEvent: CulturalEvent
    let selectedContact: Contact

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Send Your Gift")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Share your beautiful \(selectedEvent.name) gift with \(selectedContact.name)")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Event-specific Image Preview (Same as Check tab)
            if selectedEvent.name == "Christmas" {
                VStack(spacing: 16) {
                    // Contact Info
                    HStack {
                        Text("To:")
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(.secondary)

                        Text(selectedContact.name)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Spacer()
                    }

                    // Dummy Christmas Image (smaller version)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#C41E3A"),
                                    Color(hex: "#228B22"),
                                    Color(hex: "#FFD700")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
                        .overlay {
                            VStack(spacing: 8) {
                                Text("🎄")
                                    .font(.system(size: 40))

                                Text("Christmas Gift")
                                    .font(.system(.title3, design: .rounded).weight(.bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 8, y: 4)
                }
            } else if selectedEvent.name == "Easter" {
                VStack(spacing: 16) {
                    // Contact Info
                    HStack {
                        Text("To:")
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(.secondary)

                        Text(selectedContact.name)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Spacer()
                    }

                    // Dummy Easter Image (smaller version)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#FFB6C1"),
                                    Color(hex: "#ADD8E6"),
                                    Color(hex: "#98FB98")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
                        .overlay {
                            VStack(spacing: 8) {
                                Text("✝️")
                                    .font(.system(size: 40))

                                Text("Easter Gift")
                                    .font(.system(.title3, design: .rounded).weight(.bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 8, y: 4)
                }
            } else if selectedEvent.name == "Birthdays" {
                VStack(spacing: 16) {
                    // Contact Info
                    HStack {
                        Text("To:")
                            .font(.system(.caption, design: .rounded).weight(.semibold))
                            .foregroundStyle(.secondary)

                        Text(selectedContact.name)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Spacer()
                    }

                    // Dummy Birthday Image (smaller version)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(hex: "#FF69B4"),
                                    Color(hex: "#FFD700"),
                                    Color(hex: "#FFFFFF")
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 200)
                        .overlay {
                            VStack(spacing: 8) {
                                Text("🎂")
                                    .font(.system(size: 40))

                                Text("Birthday Gift")
                                    .font(.system(.title3, design: .rounded).weight(.bold))
                                    .foregroundStyle(.white)
                            }
                        }
                        .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 8, y: 4)
                }
            } else {
                // Default preview for other cultures
                RoundedRectangle(cornerRadius: 16)
                    .fill(selectedEvent.category.primaryColor.opacity(0.1))
                    .frame(height: 200)
                    .overlay {
                        VStack(spacing: 12) {
                            Text(selectedEvent.category.icon)
                                .font(.system(size: 40))
                                .foregroundStyle(selectedEvent.category.primaryColor)

                            Text("Preview for \(selectedContact.name)")
                                .font(.system(.body, design: .rounded).weight(.medium))
                                .foregroundStyle(.secondary)
                        }
                    }
            }

            // Action Buttons
            VStack(spacing: 16) {
                Divider()

                // Send Button
                Button(action: {
                    // TODO: Implement send functionality
                }) {
                    HStack {
                        Image(systemName: "paperplane.fill")
                        Text("Send your personal designer gift to \(selectedContact.name)")
                    }
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(selectedEvent.category.primaryColor, in: RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 6, y: 3)

                // Re-create Button (Subscription feature)
                Button(action: {
                    // TODO: Implement re-creation with subscription
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Re-create, for $2")
                    }
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundStyle(selectedEvent.category.primaryColor)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(selectedEvent.category.primaryColor.opacity(0.3), lineWidth: 1)
                    }
                }
                .buttonStyle(.plain)

                Text("Re-create with different settings or generate a new variation")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Birthday Elements Content
struct BirthdayElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedBirthdayElements: [BirthdayElement]

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose design elements for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Centre Pieces
            Text("Centre Piece")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(BirthdayElement.centrePieces, id: \.id) { element in
                    BirthdayElementCard(
                        element: element,
                        isSelected: selectedBirthdayElements.contains { $0.id == element.id },
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if selectedBirthdayElements.contains(where: { $0.id == element.id }) {
                                selectedBirthdayElements.removeAll { $0.id == element.id }
                            } else {
                                selectedBirthdayElements.append(element)
                            }
                        }
                    }
                }
            }

            // Supporting Elements
            Text("Supporting Elements")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
                .padding(.top, 16)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(BirthdayElement.supportingElements, id: \.id) { element in
                    BirthdayElementCard(
                        element: element,
                        isSelected: selectedBirthdayElements.contains { $0.id == element.id },
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if selectedBirthdayElements.contains(where: { $0.id == element.id }) {
                                selectedBirthdayElements.removeAll { $0.id == element.id }
                            } else {
                                selectedBirthdayElements.append(element)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Birthday Colour Content
struct BirthdayColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedBirthdayColorPalette: BirthdayColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose a color palette for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Text("Birthday Color Palettes")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(BirthdayColorPalette.allPalettes, id: \.id) { palette in
                    BirthdayColorPaletteCard(
                        palette: palette,
                        isSelected: selectedBirthdayColorPalette?.id == palette.id,
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedBirthdayColorPalette = palette
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Birthday Touch Content
struct BirthdayTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedBirthdayMessage: BirthdayPersonalTouch?
    @Binding var personalBirthdayMessage: String

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Add a personal touch to your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Optional Messages
            Text("Choose a Birthday Message")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                ForEach(BirthdayPersonalTouch.optionalMessages, id: \.id) { message in
                    BirthdayMessageCard(
                        message: message,
                        isSelected: selectedBirthdayMessage?.id == message.id,
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedBirthdayMessage = message
                            personalBirthdayMessage = "" // Clear personal message when selecting optional
                        }
                    }
                }
            }

            // Personal Message
            VStack(alignment: .leading, spacing: 12) {
                Text("Or Write Your Own")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                TextField(
                    BirthdayPersonalTouch.personalMessagePlaceholder,
                    text: $personalBirthdayMessage,
                    axis: .vertical
                )
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
                .onChange(of: personalBirthdayMessage) { _, _ in
                    if !personalBirthdayMessage.isEmpty {
                        selectedBirthdayMessage = nil // Clear optional message when typing personal
                    }
                }

                HStack {
                    Spacer()
                    Text("\(personalBirthdayMessage.count)/\(BirthdayPersonalTouch.maxPersonalMessageLength)")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(personalBirthdayMessage.count > BirthdayPersonalTouch.maxPersonalMessageLength ? .red : .secondary)
                }
            }
        }
    }
}

// MARK: - Birthday Create Content
struct BirthdayCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedBirthdayTheme: BirthdayTheme?
    let selectedBirthdayElements: [BirthdayElement]
    let selectedBirthdayColorPalette: BirthdayColorPalette?
    let selectedBirthdayMessage: BirthdayPersonalTouch?
    let personalBirthdayMessage: String

    private var birthdayState: BirthdaySelectionState {
        var state = BirthdaySelectionState()
        state.selectedTheme = selectedBirthdayTheme
        state.selectedGift = selectedGift?.name
        state.selectedElements = selectedBirthdayElements
        state.selectedColorPalette = selectedBirthdayColorPalette
        state.selectedOptionalMessage = selectedBirthdayMessage
        state.personalMessage = personalBirthdayMessage
        return state
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Review your selections and create your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if birthdayState.isComplete {
                // Summary Card
                SelectionSummaryCard(
                    title: "Your Birthday Gift Summary",
                    content: birthdayState.summary,
                    isComplete: true,
                    culturalColor: selectedEvent.category.primaryColor
                )

                // Generate Button
                Button(action: {
                    // Generate birthday gift action
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "wand.and.stars")
                        Text("Generate your personal designer gift")
                            .fontWeight(.semibold)
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(selectedEvent.category.primaryColor, in: RoundedRectangle(cornerRadius: 12))
                }
                .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 8, y: 4)

            } else {
                // Incomplete selections warning
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.orange)

                    Text("Complete Your Selections")
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Please complete all tabs (Style, Elements, Colour, Touch) to generate your birthday gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.orange.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
}

// MARK: - Birthday Element Card
struct BirthdayElementCard: View {
    let element: BirthdayElement
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Priority indicator and element name
                VStack(spacing: 4) {
                    HStack {
                        Text(element.category.rawValue)
                            .font(.system(.caption2, design: .rounded).weight(.medium))
                            .foregroundStyle(isSelected ? culturalColor : .secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(
                                (isSelected ? culturalColor : Color.secondary).opacity(0.2),
                                in: Capsule()
                            )

                        Spacer()
                    }

                    Text(element.name)
                        .font(.system(.subheadline, design: .rounded).weight(.bold))
                        .foregroundStyle(isSelected ? culturalColor : .primary)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                // Element description
                Text(element.aiPromptModifier)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding(12)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                    .stroke(
                        isSelected ? culturalColor.opacity(0.5) : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3), value: isSelected)
    }
}

// MARK: - Birthday Color Palette Card
struct BirthdayColorPaletteCard: View {
    let palette: BirthdayColorPalette
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Color preview
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(palette.primarySwiftUIColor)
                        .frame(height: 40)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(palette.secondarySwiftUIColor)
                        .frame(height: 40)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(palette.accentSwiftUIColor)
                        .frame(height: 40)
                }
                .shadow(color: .black.opacity(0.1), radius: 2, y: 1)

                VStack(spacing: 4) {
                    Text(palette.name)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundStyle(isSelected ? culturalColor : .primary)

                    Text(palette.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                    .stroke(
                        isSelected ? culturalColor.opacity(0.5) : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3), value: isSelected)
    }
}

// MARK: - Birthday Message Card
struct BirthdayMessageCard: View {
    let message: BirthdayPersonalTouch
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Tone indicator
                HStack {
                    Text(message.tone.rawValue)
                        .font(.system(.caption2, design: .rounded).weight(.medium))
                        .foregroundStyle(isSelected ? culturalColor : message.tone.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            (isSelected ? culturalColor : message.tone.color).opacity(0.2),
                            in: Capsule()
                        )

                    Spacer()
                }

                Text(message.message)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(isSelected ? culturalColor : .primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding(16)
            .frame(height: 120)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                    .stroke(
                        isSelected ? culturalColor.opacity(0.5) : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3), value: isSelected)
    }
}

// MARK: - Birthday Style Content
struct BirthdayStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedBirthdayTheme: BirthdayTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Birthday Themes
                Text("Select a Birthday Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(BirthdayTheme.allCases, id: \.self) { theme in
                        BirthdayThemeCard(
                            theme: theme,
                            isSelected: selectedBirthdayTheme == theme,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedBirthdayTheme = theme
                                showingGiftSelection = true
                            }
                        }
                    }
                }
            } else {
                // Show Gift Options for Selected Theme
                VStack(spacing: 16) {
                    // Back button and theme info
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showingGiftSelection = false
                                selectedGift = nil
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(.body, design: .rounded).weight(.medium))
                                Text("Back to Themes")
                                    .font(.system(.body, design: .rounded).weight(.medium))
                            }
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        }

                        Spacer()

                        if let theme = selectedBirthdayTheme {
                            Text(theme.rawValue)
                                .font(.system(.headline, design: .rounded).weight(.bold))
                                .foregroundStyle(selectedEvent.category.primaryColor)
                        }
                    }

                    if let theme = selectedBirthdayTheme {
                        Text(theme.description)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        // Gift options grid
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(theme.giftOptions, id: \.self) { giftName in
                                let giftOption = CulturalGift(
                                    name: giftName,
                                    imageName: "birthday_celebration",
                                    description: "Birthday gift style: \(giftName)",
                                    price: 4.99,
                                    category: .celebratory,
                                    culturalContext: .universal,
                                    colors: ["#FF69B4", "#FFD700", "#FFFFFF"],
                                    culturalSignificance: 0.9,
                                    ageAppropriate: [.any]
                                )

                                StyleCard(
                                    gift: giftOption,
                                    isSelected: selectedGift?.name == giftName,
                                    culturalColor: selectedEvent.category.primaryColor,
                                    onTap: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            selectedGift = giftOption
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Birthday Theme Card
struct BirthdayThemeCard: View {
    let theme: BirthdayTheme
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Theme icon/symbol
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isSelected
                                ? [culturalColor, culturalColor.opacity(0.7)]
                                : [theme.primaryColor, theme.primaryColor.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 60, height: 60)
                    .overlay {
                        Text(themeEmoji)
                            .font(.system(size: 28))
                    }
                    .shadow(
                        color: isSelected ? culturalColor.opacity(0.3) : theme.primaryColor.opacity(0.2),
                        radius: isSelected ? 8 : 4,
                        y: isSelected ? 4 : 2
                    )

                VStack(spacing: 4) {
                    Text(theme.rawValue)
                        .font(.system(.headline, design: .rounded).weight(.bold))
                        .foregroundStyle(isSelected ? culturalColor : .primary)

                    Text(theme.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                    .stroke(
                        isSelected ? culturalColor.opacity(0.5) : Color.clear,
                        lineWidth: isSelected ? 2 : 0
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.4, dampingFraction: 0.8, blendDuration: 0.3), value: isSelected)
    }

    private var themeEmoji: String {
        switch theme {
        case .celebration: return "🎉"
        case .milestone: return "🎂"
        case .kids: return "🎈"
        case .adult: return "🥂"
        }
    }
}

// MARK: - Easter Style Content
struct EasterStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedEasterTheme: EasterTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Easter Themes
                Text("Select an Easter Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(EasterTheme.allCases, id: \.self) { theme in
                        EasterThemeCard(
                            theme: theme,
                            isSelected: selectedEasterTheme == theme,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedEasterTheme = theme
                                showingGiftSelection = true
                            }
                        }
                    }
                }
            }

            Spacer(minLength: 20)

            // Show Gift Selection if theme is selected
            if showingGiftSelection {
                VStack(spacing: 20) {
                    if let theme = selectedEasterTheme {
                        VStack(spacing: 8) {
                            Text("\(theme.rawValue) Easter Gifts")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text(theme.description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        // Show available gifts (all Easter gifts for now)
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(availableGifts) { gift in
                                StyleCard(
                                    gift: gift,
                                    isSelected: selectedGift?.id == gift.id,
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedGift = gift
                                    }
                                }
                            }
                        }
                    }

                    // Back button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            showingGiftSelection = false
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.left")
                            Text("Back to Themes")
                        }
                        .font(.system(.body, design: .rounded).weight(.medium))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Easter Theme Card
struct EasterThemeCard: View {
    let theme: EasterTheme
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Theme Icon
            Text(themeIcon)
                .font(.system(size: 40))

            VStack(spacing: 4) {
                Text(theme.rawValue)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text(theme.description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 2)
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .onTapGesture {
            onTap()
        }
    }

    private var themeIcon: String {
        switch theme {
        case .resurrection: return "✝️"
        case .spring: return "🌸"
        case .family: return "🐰"
        case .modern: return "🎨"
        }
    }
}

// MARK: - Easter Elements Content
struct EasterElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedEasterElements: [EasterElement]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Choose Your Design Elements")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text("Select elements to enhance your Easter gift design")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            ScrollView {
                VStack(spacing: 24) {
                    // Centre Pieces Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Centre Pieces")
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Spacer()

                            Text("Choose one")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(EasterElement.centrePieces) { element in
                                EasterElementCard(
                                    element: element,
                                    isSelected: selectedEasterElements.contains { $0.id == element.id },
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    toggleCentrePieceSelection(element)
                                }
                            }
                        }
                    }

                    Divider()

                    // Supporting Elements Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Supporting Elements")
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Spacer()

                            Text("Choose any")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(EasterElement.supportingElements) { element in
                                EasterElementCard(
                                    element: element,
                                    isSelected: selectedEasterElements.contains { $0.id == element.id },
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    toggleSupportingElementSelection(element)
                                }
                            }
                        }
                    }

                    // Selected Elements Summary
                    if !selectedEasterElements.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Selected Elements:")
                                .font(.system(.caption, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            ForEach(selectedEasterElements.sorted { $0.priority > $1.priority }) { element in
                                HStack {
                                    Text("• \(element.name)")
                                        .font(.system(.caption, design: .rounded))
                                        .foregroundStyle(.secondary)

                                    Spacer()

                                    Text(element.category.rawValue)
                                        .font(.system(.caption2, design: .rounded).weight(.medium))
                                        .foregroundStyle(element.category == EasterElement.ElementCategory.centrePiece ? selectedEvent.category.primaryColor : .secondary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 2)
                                        .background(
                                            element.category == EasterElement.ElementCategory.centrePiece ?
                                            selectedEvent.category.primaryColor.opacity(0.1) :
                                            .secondary.opacity(0.1),
                                            in: RoundedRectangle(cornerRadius: 4)
                                        )
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    private func toggleCentrePieceSelection(_ element: EasterElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            // Remove any existing centre pieces
            selectedEasterElements.removeAll { $0.category == EasterElement.ElementCategory.centrePiece }

            // Add the new centre piece
            if !selectedEasterElements.contains(where: { $0.id == element.id }) {
                selectedEasterElements.append(element)
            }
        }
    }

    private func toggleSupportingElementSelection(_ element: EasterElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let index = selectedEasterElements.firstIndex(where: { $0.id == element.id }) {
                selectedEasterElements.remove(at: index)
            } else {
                selectedEasterElements.append(element)
            }
        }
    }
}

// MARK: - Easter Element Card
struct EasterElementCard: View {
    let element: EasterElement
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                // Background circle
                Circle()
                    .fill(isSelected ? culturalColor.opacity(0.15) : Color(.systemGray6))
                    .frame(width: 60, height: 60)

                // Element icon
                Image(systemName: elementIcon)
                    .font(.system(size: 24))
                    .foregroundStyle(isSelected ? culturalColor : .secondary)

                // Centre piece indicator
                if element.category == EasterElement.ElementCategory.centrePiece {
                    VStack {
                        HStack {
                            Spacer()
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundStyle(culturalColor)
                        }
                        Spacer()
                    }
                }
            }

            VStack(spacing: 4) {
                Text(element.name)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

                Text(element.category.rawValue)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? culturalColor.opacity(0.05) : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? culturalColor : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .onTapGesture {
            onTap()
        }
    }

    private var elementIcon: String {
        switch element.name {
        case "Cross":
            return "cross.fill"
        case "Easter Eggs":
            return "oval.fill"
        case "Bunny":
            return "hare.fill"
        case "Lily Flowers":
            return "leaf.fill"
        case "Spring Flowers":
            return "camera.macro"
        case "Baby Chicks":
            return "bird.fill"
        case "Butterflies":
            return "ladybug.fill"
        case "Pastel Ribbons":
            return "ribbon"
        default:
            return "star.fill"
        }
    }
}

// MARK: - Easter Colour Content
struct EasterColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedEasterColorPalette: EasterColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Choose Your Color Palette")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text("Select colors that represent your Easter celebration")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Color Palettes Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(EasterColorPalette.allPalettes) { palette in
                    EasterColorPaletteCard(
                        palette: palette,
                        isSelected: selectedEasterColorPalette?.id == palette.id,
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedEasterColorPalette = palette
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Easter Color Palette Card
struct EasterColorPaletteCard: View {
    let palette: EasterColorPalette
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            // Color preview
            HStack(spacing: 4) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(palette.swiftUIColors.primary)
                    .frame(width: 24, height: 40)

                RoundedRectangle(cornerRadius: 6)
                    .fill(palette.swiftUIColors.secondary)
                    .frame(width: 24, height: 40)

                RoundedRectangle(cornerRadius: 6)
                    .fill(palette.swiftUIColors.accent)
                    .frame(width: 24, height: 40)
            }

            VStack(spacing: 4) {
                Text(palette.name)
                    .font(.system(.body, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text(palette.description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 2)
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Easter Touch Content
struct EasterTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedEasterMessage: EasterPersonalTouch?
    @Binding var personalEasterMessage: String

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Add Your Personal Touch")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text("Choose a message or write your own Easter greeting")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            ScrollView {
                VStack(spacing: 20) {
                    // Optional Messages Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Optional Messages")
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 1), spacing: 12) {
                            ForEach(EasterPersonalTouch.optionalMessages) { message in
                                EasterMessageCard(
                                    message: message,
                                    isSelected: selectedEasterMessage?.id == message.id,
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedEasterMessage = selectedEasterMessage?.id == message.id ? nil : message
                                        if selectedEasterMessage != nil {
                                            personalEasterMessage = ""
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Divider()

                    // Personal Message Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Personal Message")
                                .font(.system(.body, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                        }

                        VStack(spacing: 8) {
                            TextField(EasterPersonalTouch.personalMessagePlaceholder, text: $personalEasterMessage, axis: .vertical)
                                .textFieldStyle(.roundedBorder)
                                .lineLimit(3...6)
                                .onChange(of: personalEasterMessage) { _, _ in
                                    if !personalEasterMessage.isEmpty {
                                        selectedEasterMessage = nil
                                    }
                                }

                            HStack {
                                Spacer()
                                Text("\(personalEasterMessage.count)/\(EasterPersonalTouch.maxPersonalMessageLength)")
                                    .font(.system(.caption2, design: .rounded))
                                    .foregroundStyle(personalEasterMessage.count > EasterPersonalTouch.maxPersonalMessageLength ? .red : .secondary)
                            }
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Easter Message Card
struct EasterMessageCard: View {
    let message: EasterPersonalTouch
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Tone indicator
            Circle()
                .fill(message.tone.color)
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 4) {
                Text(message.message)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Text(message.tone.rawValue)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(message.tone.color)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(culturalColor)
                    .font(.system(size: 20))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 1)
                )
        )
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .onTapGesture {
            onTap()
        }
    }
}

// MARK: - Easter Create Content
struct EasterCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedEasterTheme: EasterTheme?
    let selectedEasterElements: [EasterElement]
    let selectedEasterColorPalette: EasterColorPalette?
    let selectedEasterMessage: EasterPersonalTouch?
    let personalEasterMessage: String

    private var easterSelectionState: EasterSelectionState {
        EasterSelectionState(
            selectedTheme: selectedEasterTheme,
            selectedGift: selectedGift?.name,
            selectedElements: selectedEasterElements,
            selectedColorPalette: selectedEasterColorPalette,
            selectedOptionalMessage: selectedEasterMessage,
            personalMessage: personalEasterMessage
        )
    }

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Ready to Create")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text("Review your selections and generate your Easter gift")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Selection Summary
            if easterSelectionState.isComplete {
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Selections:")
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(easterSelectionState.summary)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

                    // Generate Button
                    Button(action: {
                        // TODO: Implement AI generation
                    }) {
                        HStack {
                            Image(systemName: "sparkles")
                            Text("Generate your personal designer gift")
                            Image(systemName: "sparkles")
                        }
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(selectedEvent.category.primaryColor, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 8, y: 4)
                }
            } else {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(.orange)

                    VStack(spacing: 8) {
                        Text("Incomplete Selection")
                            .font(.system(.title3, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text("Please complete all previous tabs to generate your Easter gift")
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.vertical, 40)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Eid al-Adha Style Content
struct EidAlAdhaStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedEidAlAdhaTheme: EidAlAdhaTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Eid al-Adha Themes
                Text("Select an Eid al-Adha Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(EidAlAdhaTheme.allCases, id: \.self) { theme in
                        EidAlAdhaThemeCard(
                            theme: theme,
                            isSelected: selectedEidAlAdhaTheme == theme,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedEidAlAdhaTheme = theme
                                showingGiftSelection = true
                            }
                        }
                    }
                }
            } else {
                // Show Gift Options for Selected Theme
                VStack(spacing: 16) {
                    // Back button and theme info
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showingGiftSelection = false
                                selectedGift = nil
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Back to Themes")
                            }
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        }
                        Spacer()
                    }

                    if let theme = selectedEidAlAdhaTheme {
                        VStack(spacing: 8) {
                            Text("\(theme.rawValue) Eid al-Adha Gifts")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text(theme.description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        // Show available gifts for this theme
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(theme.giftOptions, id: \.self) { giftName in
                                if let gift = availableGifts.first(where: { $0.name == giftName }) {
                                    StyleCard(
                                        gift: gift,
                                        isSelected: selectedGift?.id == gift.id,
                                        culturalColor: selectedEvent.category.primaryColor
                                    ) {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            selectedGift = gift
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Eid al-Fitr Style Content
struct EidAlFitrStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedEidAlFitrTheme: EidAlFitrTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Eid al-Fitr Themes
                Text("Select an Eid al-Fitr Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(EidAlFitrTheme.allCases, id: \.self) { theme in
                        EidAlFitrThemeCard(
                            theme: theme,
                            isSelected: selectedEidAlFitrTheme == theme,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedEidAlFitrTheme = theme
                                showingGiftSelection = true
                            }
                        }
                    }
                }
            } else {
                // Show Gift Options for Selected Theme
                VStack(spacing: 16) {
                    // Back button and theme info
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showingGiftSelection = false
                                selectedGift = nil
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                Text("Back to Themes")
                            }
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        }
                        Spacer()
                    }

                    if let theme = selectedEidAlFitrTheme {
                        VStack(spacing: 8) {
                            Text("\(theme.rawValue) Eid al-Fitr Gifts")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text(theme.description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }

                        // Show available gifts for this theme
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                            ForEach(theme.giftOptions, id: \.self) { giftName in
                                if let gift = availableGifts.first(where: { $0.name == giftName }) {
                                    StyleCard(
                                        gift: gift,
                                        isSelected: selectedGift?.id == gift.id,
                                        culturalColor: selectedEvent.category.primaryColor
                                    ) {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            selectedGift = gift
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Eid al-Adha Elements Content
struct EidAlAdhaElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedEidAlAdhaElements: [EidAlAdhaElement]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Design Elements")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select elements to enhance your Eid al-Adha gift design")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            ScrollView {
                VStack(spacing: 24) {
                    // Centre Pieces Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Centre Pieces")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("Choose 1")
                                .font(.system(.caption, design: .rounded).weight(.medium))
                                .foregroundStyle(.secondary)
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(EidAlAdhaElement.centrePieces) { element in
                                EidAlAdhaElementCard(
                                    element: element,
                                    isSelected: selectedEidAlAdhaElements.contains { $0.id == element.id },
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    toggleCentrePieceSelection(element)
                                }
                            }
                        }
                    }

                    Divider()

                    // Supporting Elements Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Supporting Elements")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("Choose multiple")
                                .font(.system(.caption, design: .rounded).weight(.medium))
                                .foregroundStyle(.secondary)
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(EidAlAdhaElement.supportingElements) { element in
                                EidAlAdhaElementCard(
                                    element: element,
                                    isSelected: selectedEidAlAdhaElements.contains { $0.id == element.id },
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    toggleSupportingElementSelection(element)
                                }
                            }
                        }
                    }
                }
            }

            // Selection Summary
            if !selectedEidAlAdhaElements.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Elements:")
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    ForEach(selectedEidAlAdhaElements.sorted { $0.priority > $1.priority }) { element in
                        HStack {
                            Text("• \(element.name)")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                }
                .padding(16)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func toggleCentrePieceSelection(_ element: EidAlAdhaElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            // Remove any existing centre pieces
            selectedEidAlAdhaElements.removeAll { $0.category == EidAlAdhaElement.ElementCategory.centrePiece }
            // Add the new centre piece
            if !selectedEidAlAdhaElements.contains(where: { $0.id == element.id }) {
                selectedEidAlAdhaElements.append(element)
            }
        }
    }

    private func toggleSupportingElementSelection(_ element: EidAlAdhaElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let index = selectedEidAlAdhaElements.firstIndex(where: { $0.id == element.id }) {
                selectedEidAlAdhaElements.remove(at: index)
            } else {
                selectedEidAlAdhaElements.append(element)
            }
        }
    }
}

// MARK: - Eid al-Fitr Elements Content
struct EidAlFitrElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedEidAlFitrElements: [EidAlFitrElement]

    var body: some View {
        VStack(spacing: 20) {
            // Header
            VStack(spacing: 8) {
                Text("Design Elements")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Select elements to enhance your Eid al-Fitr gift design")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            ScrollView {
                VStack(spacing: 24) {
                    // Centre Pieces Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Centre Pieces")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("Choose 1")
                                .font(.system(.caption, design: .rounded).weight(.medium))
                                .foregroundStyle(.secondary)
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(EidAlFitrElement.centrePieces) { element in
                                EidAlFitrElementCard(
                                    element: element,
                                    isSelected: selectedEidAlFitrElements.contains { $0.id == element.id },
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    toggleCentrePieceSelection(element)
                                }
                            }
                        }
                    }

                    Divider()

                    // Supporting Elements Section
                    VStack(spacing: 16) {
                        HStack {
                            Text("Supporting Elements")
                                .font(.system(.title3, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Text("Choose multiple")
                                .font(.system(.caption, design: .rounded).weight(.medium))
                                .foregroundStyle(.secondary)
                        }

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(EidAlFitrElement.supportingElements) { element in
                                EidAlFitrElementCard(
                                    element: element,
                                    isSelected: selectedEidAlFitrElements.contains { $0.id == element.id },
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    toggleSupportingElementSelection(element)
                                }
                            }
                        }
                    }
                }
            }

            // Selection Summary
            if !selectedEidAlFitrElements.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Selected Elements:")
                        .font(.system(.caption, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    ForEach(selectedEidAlFitrElements.sorted { $0.priority > $1.priority }) { element in
                        HStack {
                            Text("• \(element.name)")
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                            Spacer()
                        }
                    }
                }
                .padding(16)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private func toggleCentrePieceSelection(_ element: EidAlFitrElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            // Remove any existing centre pieces
            selectedEidAlFitrElements.removeAll { $0.category == EidAlFitrElement.ElementCategory.centrePiece }
            // Add the new centre piece
            if !selectedEidAlFitrElements.contains(where: { $0.id == element.id }) {
                selectedEidAlFitrElements.append(element)
            }
        }
    }

    private func toggleSupportingElementSelection(_ element: EidAlFitrElement) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            if let index = selectedEidAlFitrElements.firstIndex(where: { $0.id == element.id }) {
                selectedEidAlFitrElements.remove(at: index)
            } else {
                selectedEidAlFitrElements.append(element)
            }
        }
    }
}

// MARK: - Eid Theme Cards
struct EidAlAdhaThemeCard: View {
    let theme: EidAlAdhaTheme
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Theme preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 120)

                    VStack(spacing: 8) {
                        // Theme-specific icon
                        Image(systemName: themeIcon)
                            .font(.system(size: 30))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [theme.primaryColor, theme.primaryColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(theme.rawValue)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(theme.description)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 6 : 2
            )
        }
        .buttonStyle(.plain)
    }

    private var themeIcon: String {
        switch theme {
        case .traditional: return "building.columns"
        case .family: return "house.fill"
        case .spiritual: return "star.crescent"
        case .celebration: return "party.popper.fill"
        }
    }
}

struct EidAlFitrThemeCard: View {
    let theme: EidAlFitrTheme
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Theme preview
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.regularMaterial)
                        .frame(height: 120)

                    VStack(spacing: 8) {
                        // Theme-specific icon
                        Image(systemName: themeIcon)
                            .font(.system(size: 30))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [theme.primaryColor, theme.primaryColor.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Text(theme.rawValue)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(theme.description)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                y: isSelected ? 6 : 2
            )
        }
        .buttonStyle(.plain)
    }

    private var themeIcon: String {
        switch theme {
        case .traditional: return "building.columns"
        case .family: return "house.fill"
        case .spiritual: return "star.crescent"
        case .celebration: return "party.popper.fill"
        }
    }
}

// MARK: - Eid Element Cards
struct EidAlAdhaElementCard: View {
    let element: EidAlAdhaElement
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Element preview
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                        .frame(height: 80)

                    VStack(spacing: 4) {
                        Image(systemName: elementIcon)
                            .font(.system(size: 24))
                            .foregroundStyle(isSelected ? culturalColor : .secondary)

                        Text(element.name)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                }

                // Priority indicator
                if element.category == .centrePiece {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(.orange)
                        Text("Main")
                            .font(.system(.caption2, design: .rounded).weight(.medium))
                            .foregroundStyle(.orange)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : Color(.systemGray5), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    private var elementIcon: String {
        switch element.name {
        case "Mosque": return "building.columns"
        case "Crescent Moon": return "moon.stars"
        case "Arabic Calligraphy": return "textformat.abc"
        case "Islamic Star": return "star"
        case "Lanterns": return "lamp.ceiling"
        case "Dates": return "leaf"
        case "Islamic Patterns": return "square.grid.3x3"
        case "Prayer Beads": return "circle.grid.cross"
        default: return "star"
        }
    }
}

struct EidAlFitrElementCard: View {
    let element: EidAlFitrElement
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Element preview
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                        .frame(height: 80)

                    VStack(spacing: 4) {
                        Image(systemName: elementIcon)
                            .font(.system(size: 24))
                            .foregroundStyle(isSelected ? culturalColor : .secondary)

                        Text(element.name)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.center)
                            .lineLimit(1)
                    }
                }

                // Priority indicator
                if element.category == .centrePiece {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 8))
                            .foregroundStyle(.orange)
                        Text("Main")
                            .font(.system(.caption2, design: .rounded).weight(.medium))
                            .foregroundStyle(.orange)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : Color(.systemGray5), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }

    private var elementIcon: String {
        switch element.name {
        case "Mosque": return "building.columns"
        case "Crescent Moon": return "moon.stars"
        case "Arabic Calligraphy": return "textformat.abc"
        case "Islamic Star": return "star"
        case "Lanterns": return "lamp.ceiling"
        case "Dates": return "leaf"
        case "Islamic Patterns": return "square.grid.3x3"
        case "Prayer Beads": return "circle.grid.cross"
        default: return "star"
        }
    }
}

// MARK: - Coming Soon View
struct ComingSoonView: View {
    let selectedEvent: CulturalEvent

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Coming Soon Header
                VStack(spacing: 16) {
                    // Event Icon
                    ZStack {
                        Circle()
                            .fill(selectedEvent.category.primaryColor.opacity(0.1))
                            .frame(width: 120, height: 120)

                        Text(selectedEvent.category.icon)
                            .font(.system(size: 60))
                    }

                    // Coming Soon Badge
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.orange)
                        Text("Coming Soon")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.orange)
                        Image(systemName: "star.fill")
                            .foregroundStyle(.orange)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))

                    // Event Name
                    Text(selectedEvent.name)
                        .font(.system(.title, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)
                }

                // Description Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        Text("About This Celebration")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)
                    }

                    Text(selectedEvent.description)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)

                    Text(selectedEvent.culturalContext)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .italic()
                }
                .padding(20)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                // Development Status
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "wrench.and.screwdriver.fill")
                            .foregroundStyle(.blue)
                        Text("Development Status")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        StatusRow(
                            icon: "checkmark.circle.fill",
                            text: "Cultural research completed",
                            isComplete: true
                        )
                        StatusRow(
                            icon: "checkmark.circle.fill",
                            text: "Design patterns identified",
                            isComplete: true
                        )
                        StatusRow(
                            icon: "clock.fill",
                            text: "AI prompt optimization in progress",
                            isComplete: false
                        )
                        StatusRow(
                            icon: "clock.fill",
                            text: "UI implementation pending",
                            isComplete: false
                        )
                        StatusRow(
                            icon: "clock.fill",
                            text: "Cultural validation testing",
                            isComplete: false
                        )
                    }
                }
                .padding(20)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))

                // Call to Action
                VStack(spacing: 16) {
                    Text("We're working hard to bring you authentic \(selectedEvent.name) experiences!")
                        .font(.system(.body, design: .rounded).weight(.medium))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.center)

                    Text("Check back soon for updates")
                        .font(.system(.callout, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(20)
                .background(selectedEvent.category.primaryColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))

                Spacer(minLength: 40)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
    }
}

struct StatusRow: View {
    let icon: String
    let text: String
    let isComplete: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(isComplete ? .green : .orange)
                .font(.system(.body).weight(.semibold))

            Text(text)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.primary)

            Spacer()
        }
    }
}

// MARK: - Eid al-Adha Content Components
struct EidAlAdhaColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedEidAlAdhaColorPalette: EidAlAdhaColorPalette?

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Choose Your Eid al-Adha Colors")
                    .font(.title2.bold())
                    .foregroundStyle(.primary)

                Text("Select a color palette that reflects the sacred spirit of sacrifice and devotion for your Eid al-Adha greeting")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 16) {
                ForEach(EidAlAdhaColorPalette.allPalettes) { palette in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            Circle()
                                .fill(Color(hex: palette.primaryColor))
                                .frame(width: 20, height: 20)

                            Circle()
                                .fill(Color(hex: palette.secondaryColor))
                                .frame(width: 20, height: 20)

                            Circle()
                                .fill(Color(hex: palette.accentColor))
                                .frame(width: 20, height: 20)

                            Spacer()
                        }

                        Text(palette.name)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text(palette.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.regularMaterial)
                            .stroke(
                                selectedEidAlAdhaColorPalette?.id == palette.id
                                    ? Color(hex: palette.primaryColor)
                                    : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .onTapGesture {
                        selectedEidAlAdhaColorPalette = palette
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

struct EidAlAdhaTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedEidAlAdhaMessage: EidAlAdhaPersonalTouch?
    @Binding var personalEidAlAdhaMessage: String

    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Personal Touch")
                    .font(.system(.title2, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)

                Text("Add a heartfelt message to make your Eid al-Adha gift truly personal")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            // Optional Messages Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Choose an Eid al-Adha Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    if selectedEidAlAdhaMessage != nil {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedEidAlAdhaMessage = nil
                            }
                        }
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 1), spacing: 12) {
                    ForEach(EidAlAdhaPersonalTouch.optionalMessages) { message in
                        EidAlAdhaMessageCard(
                            message: message,
                            isSelected: selectedEidAlAdhaMessage?.id == message.id,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedEidAlAdhaMessage?.id == message.id {
                                    selectedEidAlAdhaMessage = nil
                                } else {
                                    selectedEidAlAdhaMessage = message
                                    // Clear personal message if optional message is selected
                                    personalEidAlAdhaMessage = ""
                                }
                            }
                        }
                    }
                }
            }

            // Divider with "OR"
            HStack {
                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 1)

                Text("OR")
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)

                Rectangle()
                    .fill(.secondary.opacity(0.3))
                    .frame(height: 1)
            }

            // Personal Message Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Write Your Own Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Spacer()

                    if !personalEidAlAdhaMessage.isEmpty {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                personalEidAlAdhaMessage = ""
                            }
                        }
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.regularMaterial)
                            .frame(minHeight: 100)

                        if personalEidAlAdhaMessage.isEmpty {
                            Text(EidAlAdhaPersonalTouch.personalMessagePlaceholder)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.top, 12)
                        }

                        TextEditor(text: $personalEidAlAdhaMessage)
                            .font(.system(.body, design: .rounded))
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .onChange(of: personalEidAlAdhaMessage) { _, newValue in
                                // Clear selected optional message if user types
                                if !newValue.isEmpty && selectedEidAlAdhaMessage != nil {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedEidAlAdhaMessage = nil
                                    }
                                }

                                // Enforce character limit
                                if newValue.count > EidAlAdhaPersonalTouch.maxPersonalMessageLength {
                                    personalEidAlAdhaMessage = String(newValue.prefix(EidAlAdhaPersonalTouch.maxPersonalMessageLength))
                                }
                            }
                    }

                    HStack {
                        Spacer()
                        Text("\(personalEidAlAdhaMessage.count)/\(EidAlAdhaPersonalTouch.maxPersonalMessageLength)")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                }
            }

            // Selection Status
            if selectedEidAlAdhaMessage != nil || !personalEidAlAdhaMessage.isEmpty {
                VStack(spacing: 8) {
                    Divider()

                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)

                        Text("Personal message added")
                            .font(.system(.body, design: .rounded).weight(.medium))
                            .foregroundStyle(.primary)

                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct EidAlAdhaMessageCard: View {
    let message: EidAlAdhaPersonalTouch
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 4) {
                    Circle()
                        .fill(message.tone.color)
                        .frame(width: 8, height: 8)

                    Text(message.tone.rawValue)
                        .font(.system(.caption2, design: .rounded).weight(.semibold))
                        .foregroundStyle(message.tone.color)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(width: 50)

                VStack(alignment: .leading, spacing: 4) {
                    Text(message.message)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                        .font(.system(.body).weight(.semibold))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? culturalColor.opacity(0.1) : Color(.systemGray6))
                    .stroke(
                        isSelected ? culturalColor : Color.clear,
                        lineWidth: 1.5
                    )
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .shadow(
                color: isSelected ? culturalColor.opacity(0.3) : .clear,
                radius: isSelected ? 8 : 0,
                x: 0,
                y: 2
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct EidAlAdhaCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedEidAlAdhaTheme: EidAlAdhaTheme?
    let selectedEidAlAdhaElements: [EidAlAdhaElement]
    let selectedEidAlAdhaColorPalette: EidAlAdhaColorPalette?
    let selectedEidAlAdhaMessage: EidAlAdhaPersonalTouch?
    let personalEidAlAdhaMessage: String

    private var eidAlAdhaSelectionState: EidAlAdhaSelectionState {
        EidAlAdhaSelectionState(
            selectedTheme: selectedEidAlAdhaTheme,
            selectedGift: selectedGift?.name,
            selectedElements: selectedEidAlAdhaElements,
            selectedColorPalette: selectedEidAlAdhaColorPalette,
            selectedOptionalMessage: selectedEidAlAdhaMessage,
            personalMessage: personalEidAlAdhaMessage
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Your Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Review your selections and generate your personalized Eid al-Adha gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Selection Summary
                VStack(spacing: 16) {
                    // Style Summary
                    if let theme = selectedEidAlAdhaTheme, let gift = selectedGift {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "\(theme.rawValue) - \(gift.name)",
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "Please select a theme and gift style",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Elements Summary
                    if !selectedEidAlAdhaElements.isEmpty {
                        let elementNames = selectedEidAlAdhaElements.map { $0.name }.joined(separator: ", ")
                        SelectionSummaryCard(
                            title: "Elements",
                            content: elementNames,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Elements",
                            content: "Please select design elements",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Color Summary
                    if let palette = selectedEidAlAdhaColorPalette {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: palette.name,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            HStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(palette.swiftUIColors.primary)
                                    .frame(width: 16, height: 16)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(palette.swiftUIColors.secondary)
                                    .frame(width: 16, height: 16)

                                RoundedRectangle(cornerRadius: 4)
                                    .fill(palette.swiftUIColors.accent)
                                    .frame(width: 16, height: 16)
                            }
                        }
                    } else {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: "Please select a color palette",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Personal Touch Summary
                    let hasPersonalTouch = selectedEidAlAdhaMessage != nil || !personalEidAlAdhaMessage.isEmpty
                    if hasPersonalTouch {
                        let message = selectedEidAlAdhaMessage?.message ?? personalEidAlAdhaMessage
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: message,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: "Please add a personal message",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }
                }

                // Generation Button
                VStack(spacing: 16) {
                    Divider()

                    if eidAlAdhaSelectionState.isComplete {
                        Button(action: {
                            // TODO: Implement AI generation
                        }) {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                    .font(.system(.body, design: .rounded).weight(.semibold))

                                Text("Generate Your Personal Designer Gift")
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(selectedEvent.category.primaryColor, in: RoundedRectangle(cornerRadius: 12))
                        }
                        .buttonStyle(.plain)
                        .scaleEffect(1.0)
                        .shadow(color: selectedEvent.category.primaryColor.opacity(0.3), radius: 8, y: 4)

                        Text("AI will create your unique Eid al-Adha gift based on your selections")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    } else {
                        VStack(spacing: 12) {
                            Text("Complete Your Selections")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)

                            Text("Please complete all steps above to generate your Eid al-Adha gift")
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)

                            Button("Generate Your Personal Designer Gift") {
                                // Disabled state - no action
                            }
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(.secondary.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))
                            .disabled(true)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

// MARK: - Hanukkah Style Content
struct HanukkahStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedHanukkahTheme: HanukkahTheme?
    @Binding var showingGiftSelection: Bool
    @Binding var selectedHanukkahElements: [HanukkahElement]
    @Binding var selectedHanukkahColorPalette: HanukkahColorPalette?
    @Binding var selectedHanukkahMessage: HanukkahPersonalTouch?
    @Binding var personalHanukkahMessage: String

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            // Tab description
            Text("Choose the perfect style for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Hanukkah Themes
                Text("Select a Hanukkah Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(HanukkahTheme.allCases, id: \.self) { theme in
                        HanukkahThemeCard(
                            theme: theme,
                            isSelected: selectedHanukkahTheme == theme,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedHanukkahTheme = theme
                                showingGiftSelection = true
                            }
                        }
                    }
                }
            } else {
                // Show Gift Options for Selected Theme
                VStack(spacing: 16) {
                    // Back button and theme info
                    HStack {
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                showingGiftSelection = false
                                selectedGift = nil
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 14, weight: .medium))
                                Text("Back to Themes")
                                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                            }
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        }

                        Spacer()

                        if let theme = selectedHanukkahTheme {
                            Text(theme.rawValue)
                                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                    }

                    // Gift Options Grid
                    if let theme = selectedHanukkahTheme {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(theme.giftOptions, id: \.self) { giftOption in
                                HanukkahGiftOptionCard(
                                    giftName: giftOption,
                                    isSelected: selectedGift?.name == giftOption,
                                    culturalColor: selectedEvent.category.primaryColor
                                ) {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedGift = CulturalGift(
                                            name: giftOption,
                                            imageName: giftOption.lowercased().replacingOccurrences(of: " ", with: "_"),
                                            description: "Hanukkah \(giftOption)",
                                            price: 25.00,
                                            category: .traditional,
                                            culturalContext: .jewish,
                                            colors: ["#0066CC", "#FFD700"]
                                        )
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Hanukkah Theme Card
struct HanukkahThemeCard: View {
    let theme: HanukkahTheme
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Theme icon or visual
                Circle()
                    .fill(isSelected ? culturalColor : culturalColor.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay {
                        Text("✡️")
                            .font(.title)
                    }

                // Theme name
                Text(theme.rawValue)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                // Theme description
                Text(theme.description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Hanukkah Gift Option Card
struct HanukkahGiftOptionCard: View {
    let giftName: String
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Gift preview placeholder
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? culturalColor.opacity(0.2) : .secondary.opacity(0.1))
                    .frame(height: 80)
                    .overlay {
                        Text("🕎")
                            .font(.title2)
                    }

                // Gift name
                Text(giftName)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(8)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Hanukkah Elements Content
struct HanukkahElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedHanukkahElements: [HanukkahElement]

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose design elements for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                // Centre Pieces Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Centre Piece")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Spacer()

                        Text("Takes visual precedence")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(HanukkahElement.centrePieces, id: \.id) { element in
                            HanukkahElementCard(
                                element: element,
                                isSelected: selectedHanukkahElements.contains { $0.id == element.id },
                                culturalColor: selectedEvent.category.primaryColor
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if let index = selectedHanukkahElements.firstIndex(where: { $0.id == element.id }) {
                                        selectedHanukkahElements.remove(at: index)
                                    } else {
                                        selectedHanukkahElements.append(element)
                                    }
                                }
                            }
                        }
                    }
                }

                // Supporting Elements Section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Supporting Elements")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Spacer()

                        Text("Complements the design")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                    }

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(HanukkahElement.supportingElements, id: \.id) { element in
                            HanukkahElementCard(
                                element: element,
                                isSelected: selectedHanukkahElements.contains { $0.id == element.id },
                                culturalColor: selectedEvent.category.primaryColor
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if let index = selectedHanukkahElements.firstIndex(where: { $0.id == element.id }) {
                                        selectedHanukkahElements.remove(at: index)
                                    } else {
                                        selectedHanukkahElements.append(element)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Hanukkah Element Card
struct HanukkahElementCard: View {
    let element: HanukkahElement
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // Element icon
                Circle()
                    .fill(isSelected ? culturalColor : culturalColor.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(elementIcon)
                            .font(.title3)
                    }

                // Element name
                Text(element.name)
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    private var elementIcon: String {
        switch element.name {
        case "Menorah": return "🕎"
        case "Star of David": return "✡️"
        case "Dreidel": return "🎯"
        case "Hanukkah Candles": return "🕯️"
        case "Oil Jug": return "🫗"
        case "Hebrew Letters": return "🔤"
        case "Blue & White Ribbons": return "🎀"
        case "Gelt Coins": return "🪙"
        default: return "✡️"
        }
    }
}

// MARK: - Hanukkah Colour Content
struct HanukkahColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedHanukkahColorPalette: HanukkahColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose colors for your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(HanukkahColorPalette.allPalettes, id: \.id) { palette in
                    HanukkahColorPaletteCard(
                        palette: palette,
                        isSelected: selectedHanukkahColorPalette?.id == palette.id,
                        culturalColor: selectedEvent.category.primaryColor
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedHanukkahColorPalette = palette
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Hanukkah Color Palette Card
struct HanukkahColorPaletteCard: View {
    let palette: HanukkahColorPalette
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                // Color swatches
                HStack(spacing: 4) {
                    let colors = palette.swiftUIColors
                    ForEach([colors.primary, colors.secondary, colors.accent], id: \.self) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 24, height: 24)
                    }
                }

                // Palette name and description
                VStack(spacing: 4) {
                    Text(palette.name)
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(palette.description)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Hanukkah Touch Content
struct HanukkahTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedHanukkahMessage: HanukkahPersonalTouch?
    @Binding var personalHanukkahMessage: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Add a personal touch to your \(selectedEvent.name) gift")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                // Optional Messages
                Text("Choose an Optional Message")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                    ForEach(HanukkahPersonalTouch.optionalMessages, id: \.id) { message in
                        HanukkahMessageCard(
                            message: message,
                            isSelected: selectedHanukkahMessage?.id == message.id,
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if selectedHanukkahMessage?.id == message.id {
                                    selectedHanukkahMessage = nil
                                } else {
                                    selectedHanukkahMessage = message
                                    personalHanukkahMessage = ""
                                }
                            }
                        }
                    }
                }

                // Personal Message Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Or Write Your Own Personal Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    TextField(HanukkahPersonalTouch.personalMessagePlaceholder, text: $personalHanukkahMessage, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...5)
                        .onChange(of: personalHanukkahMessage) { _, newValue in
                            if !newValue.isEmpty {
                                selectedHanukkahMessage = nil
                            }
                        }

                    Text("\(personalHanukkahMessage.count)/\(HanukkahPersonalTouch.maxPersonalMessageLength)")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Hanukkah Message Card
struct HanukkahMessageCard: View {
    let message: HanukkahPersonalTouch
    let isSelected: Bool
    let culturalColor: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Message tone indicator
                Circle()
                    .fill(message.tone.color)
                    .frame(width: 12, height: 12)

                // Message text
                Text(message.message)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Selection indicator
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(isSelected ? culturalColor : .secondary)
            }
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? culturalColor : Color.clear, lineWidth: 2)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Hanukkah Create Content
struct HanukkahCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedHanukkahTheme: HanukkahTheme?
    let selectedHanukkahElements: [HanukkahElement]
    let selectedHanukkahColorPalette: HanukkahColorPalette?
    let selectedHanukkahMessage: HanukkahPersonalTouch?
    let personalHanukkahMessage: String

    private var selectionState: HanukkahSelectionState {
        var state = HanukkahSelectionState()
        state.selectedTheme = selectedHanukkahTheme
        state.selectedGift = selectedGift?.name
        state.selectedElements = selectedHanukkahElements
        state.selectedColorPalette = selectedHanukkahColorPalette
        state.selectedOptionalMessage = selectedHanukkahMessage
        state.personalMessage = personalHanukkahMessage
        return state
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Review your \(selectedEvent.name) gift design")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if selectionState.isComplete {
                VStack(spacing: 16) {
                    // Selection Summary
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Selection Summary")
                            .font(.system(.headline, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        Text(selectionState.summary)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                            .padding()
                            .background(.secondary.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
                    }

                    // Generate Button
                    Button(action: {
                        // Generate gift action
                    }) {
                        HStack {
                            Image(systemName: "wand.and.stars")
                                .font(.system(size: 18, weight: .medium))
                            Text("Generate your personal designer gift")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)
                        .background(selectedEvent.category.primaryColor, in: RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            } else {
                VStack(spacing: 12) {
                    Text("Complete all tabs to generate your gift")
                        .font(.system(.subheadline, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)

                    Button("Complete Selection") {
                        // Navigate back to incomplete tabs
                    }
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(selectedEvent.category.primaryColor)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(.secondary.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))
                    .disabled(true)
                }
                .padding(.vertical)
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Vesak Day Style Content
struct VesakDayStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedVesakDayTheme: VesakDayTheme?
    @Binding var showingGiftSelection: Bool
    @Binding var selectedVesakDayElements: [VesakDayElement]
    @Binding var selectedVesakDayColorPalette: VesakDayColorPalette?
    @Binding var selectedVesakDayMessage: VesakDayPersonalTouch?
    @Binding var personalVesakDayMessage: String

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(selectedEvent.selectionTitle)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            if !showingGiftSelection {
                // Show Vesak Day Themes
                Text("Select a Vesak Day Theme")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(VesakDayTheme.allCases, id: \.self) { theme in
                        VesakDayThemeCard(
                            theme: theme,
                            isSelected: selectedVesakDayTheme == theme,
                            onTap: {
                                selectedVesakDayTheme = theme
                                showingGiftSelection = true
                            }
                        )
                    }
                }
            } else {
                // Show gifts for selected theme
                if let theme = selectedVesakDayTheme {
                    VStack(spacing: 16) {
                        HStack {
                            Button("← Back to Themes") {
                                showingGiftSelection = false
                            }
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(.blue)

                            Spacer()
                        }

                        Text("Choose from \(theme.rawValue) Gifts")
                            .font(.system(.title3, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(theme.giftOptions, id: \.self) { giftName in
                                VesakDayGiftCard(
                                    giftName: giftName,
                                    theme: theme,
                                    isSelected: selectedGift?.name == giftName,
                                    onTap: {
                                        // Create CulturalGift from theme gift
                                        selectedGift = CulturalGift(
                                            name: giftName,
                                            imageName: "VesakDay",
                                            description: "Vesak Day \(giftName)",
                                            price: 25.00,
                                            category: .traditional,
                                            culturalContext: .buddhist,
                                            colors: ["#FFD700", "#FF6B35"]
                                        )
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct VesakDayThemeCard: View {
    let theme: VesakDayTheme
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Theme icon/symbol
                Text("🪷")
                    .font(.system(size: 40))
                    .foregroundStyle(theme.primaryColor)

                Text(theme.rawValue)
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text(theme.description)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(16)
            .frame(maxWidth: .infinity, minHeight: 120)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? theme.primaryColor.opacity(0.1) : Color(.systemBackground))
                    .stroke(isSelected ? theme.primaryColor : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

struct VesakDayGiftCard: View {
    let giftName: String
    let theme: VesakDayTheme
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Gift placeholder
                Image(systemName: "gift.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(theme.primaryColor)

                Text(giftName)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 100)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? theme.primaryColor.opacity(0.1) : Color(.systemGray6))
                    .stroke(isSelected ? theme.primaryColor : Color.clear, lineWidth: isSelected ? 2 : 0)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Vesak Day Elements Content
struct VesakDayElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedVesakDayElements: [VesakDayElement]

    var body: some View {
        VStack(spacing: 24) {
            Text("Choose Design Elements")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            VStack(spacing: 20) {
                // Centre Pieces
                VStack(alignment: .leading, spacing: 12) {
                    Text("Centre Piece (Select One)")
                        .font(.system(.subheadline, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(VesakDayElement.centrePieces) { element in
                            VesakDayElementCard(
                                element: element,
                                isSelected: selectedVesakDayElements.contains { $0.id == element.id },
                                onTap: {
                                    // For centre pieces, only allow one selection
                                    selectedVesakDayElements.removeAll { $0.category == .centrePiece }
                                    selectedVesakDayElements.append(element)
                                }
                            )
                        }
                    }
                }

                Divider()

                // Supporting Elements
                VStack(alignment: .leading, spacing: 12) {
                    Text("Supporting Elements (Select Multiple)")
                        .font(.system(.subheadline, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(VesakDayElement.supportingElements) { element in
                            VesakDayElementCard(
                                element: element,
                                isSelected: selectedVesakDayElements.contains { $0.id == element.id },
                                onTap: {
                                    if let index = selectedVesakDayElements.firstIndex(where: { $0.id == element.id }) {
                                        selectedVesakDayElements.remove(at: index)
                                    } else {
                                        selectedVesakDayElements.append(element)
                                    }
                                }
                            )
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct VesakDayElementCard: View {
    let element: VesakDayElement
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Element symbol
                Text("🪷")
                    .font(.system(size: 24))
                    .foregroundStyle(.orange)

                Text(element.name)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)

                Text(element.category.rawValue)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 80)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.orange.opacity(0.1) : Color(.systemGray6))
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: isSelected ? 2 : 0)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Vesak Day Colour Content
struct VesakDayColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedVesakDayColorPalette: VesakDayColorPalette?

    var body: some View {
        VStack(spacing: 24) {
            Text("Choose Color Palette")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(VesakDayColorPalette.allPalettes) { palette in
                    VesakDayColorPaletteCard(
                        palette: palette,
                        isSelected: selectedVesakDayColorPalette?.id == palette.id,
                        onTap: {
                            selectedVesakDayColorPalette = palette
                        }
                    )
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct VesakDayColorPaletteCard: View {
    let palette: VesakDayColorPalette
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                // Color swatch
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(palette.swiftUIColors.primary)
                        .frame(width: 30, height: 20)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(palette.swiftUIColors.secondary)
                        .frame(width: 30, height: 20)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(palette.swiftUIColors.accent)
                        .frame(width: 30, height: 20)
                }

                Text(palette.name)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.primary)

                Text(palette.description)
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 100)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? palette.swiftUIColors.primary.opacity(0.1) : Color(.systemGray6))
                    .stroke(isSelected ? palette.swiftUIColors.primary : Color.clear, lineWidth: isSelected ? 2 : 0)
            }
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Vesak Day Touch Content
struct VesakDayTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedVesakDayMessage: VesakDayPersonalTouch?
    @Binding var personalVesakDayMessage: String

    var body: some View {
        VStack(spacing: 24) {
            Text("Add Personal Touch")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            VStack(spacing: 16) {
                Text("Choose a pre-written message:")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.secondary)

                LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                    ForEach(VesakDayPersonalTouch.optionalMessages) { message in
                        VesakDayMessageCard(
                            message: message,
                            isSelected: selectedVesakDayMessage?.id == message.id,
                            onTap: {
                                selectedVesakDayMessage = message
                                personalVesakDayMessage = "" // Clear personal message
                            }
                        )
                    }
                }

                Text("OR write your own:")
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)

                TextField(
                    VesakDayPersonalTouch.personalMessagePlaceholder,
                    text: $personalVesakDayMessage,
                    axis: .vertical
                )
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
                .onChange(of: personalVesakDayMessage) { _, newValue in
                    if !newValue.isEmpty {
                        selectedVesakDayMessage = nil // Clear pre-written message
                    }
                }

                Text("\(personalVesakDayMessage.count)/\(VesakDayPersonalTouch.maxPersonalMessageLength)")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 24)
    }
}

struct VesakDayMessageCard: View {
    let message: VesakDayPersonalTouch
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(message.message)
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)

                Spacer()
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? message.tone.color.opacity(0.1) : Color(.systemGray6))
                    .stroke(isSelected ? message.tone.color : Color.clear, lineWidth: isSelected ? 2 : 0)
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Vesak Day Create Content
struct VesakDayCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedVesakDayTheme: VesakDayTheme?
    let selectedVesakDayElements: [VesakDayElement]
    let selectedVesakDayColorPalette: VesakDayColorPalette?
    let selectedVesakDayMessage: VesakDayPersonalTouch?
    let personalVesakDayMessage: String

    var body: some View {
        VStack(spacing: 24) {
            Text("Create Your Vesak Day Gift")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            VStack(alignment: .leading, spacing: 16) {
                if let theme = selectedVesakDayTheme {
                    Label("Theme: \(theme.rawValue)", systemImage: "paintbrush.fill")
                }

                if let gift = selectedGift {
                    Label("Gift: \(gift.name)", systemImage: "gift.fill")
                }

                if !selectedVesakDayElements.isEmpty {
                    Label("Elements: \(selectedVesakDayElements.map { $0.name }.joined(separator: ", "))", systemImage: "square.stack.3d.up.fill")
                }

                if let palette = selectedVesakDayColorPalette {
                    Label("Colors: \(palette.name)", systemImage: "paintpalette.fill")
                }

                if let message = selectedVesakDayMessage {
                    Label("Message: \(message.message)", systemImage: "text.quote")
                } else if !personalVesakDayMessage.isEmpty {
                    Label("Personal Message: \(personalVesakDayMessage)", systemImage: "text.quote")
                }
            }
            .font(.system(.body, design: .rounded))

            Button(action: {
                // Generate gift action
            }) {
                Text("Generate Your Personal Designer Gift")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .disabled(!isSelectionComplete)
        }
        .padding(.horizontal, 24)
    }

    private var isSelectionComplete: Bool {
        return selectedVesakDayTheme != nil &&
               selectedGift != nil &&
               !selectedVesakDayElements.isEmpty &&
               selectedVesakDayColorPalette != nil &&
               (selectedVesakDayMessage != nil || !personalVesakDayMessage.isEmpty)
    }
}

// MARK: - Rosh Hashanah Content Views
struct RoshHashanahStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedRoshHashanahTheme: RoshHashanahTheme?
    @Binding var showingGiftSelection: Bool
    @Binding var selectedRoshHashanahElements: [RoshHashanahElement]
    @Binding var selectedRoshHashanahColorPalette: RoshHashanahColorPalette?
    @Binding var selectedRoshHashanahMessage: RoshHashanahPersonalTouch?
    @Binding var personalRoshHashanahMessage: String

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose a New Year Blessing Style")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            if selectedRoshHashanahTheme == nil {
                // Show theme selection
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(RoshHashanahTheme.allCases, id: \.self) { theme in
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(theme.primaryColor.gradient)
                                .frame(height: 120)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Text(theme.rawValue)
                                            .font(.system(.title3, design: .rounded).weight(.bold))
                                            .foregroundStyle(.white)
                                        Text("\(theme.giftOptions.count) options")
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundStyle(.white.opacity(0.8))
                                    }
                                )
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        selectedRoshHashanahTheme = theme
                                    }
                                }

                            Text(theme.description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            } else if let theme = selectedRoshHashanahTheme {
                // Show gift selection for chosen theme
                VStack(spacing: 16) {
                    HStack {
                        Button("← Back to Themes") {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedRoshHashanahTheme = nil
                                selectedGift = nil
                            }
                        }
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(selectedEvent.category.primaryColor)

                        Spacer()
                    }

                    Text("Choose Your \(theme.rawValue) Gift")
                        .font(.system(.title3, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(theme.giftOptions, id: \.self) { giftOption in
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(theme.primaryColor.opacity(selectedGift?.name == giftOption ? 1.0 : 0.1))
                                    .stroke(theme.primaryColor, lineWidth: selectedGift?.name == giftOption ? 2 : 0)
                                    .frame(height: 80)
                                    .overlay(
                                        Text(giftOption)
                                            .font(.system(.caption, design: .rounded).weight(.medium))
                                            .foregroundStyle(selectedGift?.name == giftOption ? .white : theme.primaryColor)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 8)
                                    )
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedGift = CulturalGift(
                                                name: giftOption,
                                                category: selectedEvent.category,
                                                imageName: "rosh_hashanah_\(giftOption.lowercased().replacingOccurrences(of: " ", with: "_"))",
                                                price: 2.99
                                            )
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct RoshHashanahElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedRoshHashanahElements: [RoshHashanahElement]

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Design Elements")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            // Centre Pieces Section
            VStack(spacing: 16) {
                HStack {
                    Text("Centre Pieces")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("Choose 1-2")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(RoshHashanahElement.centrePieces, id: \.id) { element in
                        ElementSelectionCard(
                            element: element.name,
                            isSelected: selectedRoshHashanahElements.contains(where: { $0.id == element.id }),
                            culturalColor: selectedEvent.category.primaryColor,
                            onTap: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if let index = selectedRoshHashanahElements.firstIndex(where: { $0.id == element.id }) {
                                        selectedRoshHashanahElements.remove(at: index)
                                    } else {
                                        selectedRoshHashanahElements.append(element)
                                    }
                                }
                            }
                        )
                    }
                }
            }

            // Supporting Elements Section
            VStack(spacing: 16) {
                HStack {
                    Text("Supporting Elements")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    Spacer()
                    Text("Choose any")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(RoshHashanahElement.supportingElements, id: \.id) { element in
                        ElementSelectionCard(
                            element: element.name,
                            isSelected: selectedRoshHashanahElements.contains(where: { $0.id == element.id }),
                            culturalColor: selectedEvent.category.primaryColor,
                            onTap: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    if let index = selectedRoshHashanahElements.firstIndex(where: { $0.id == element.id }) {
                                        selectedRoshHashanahElements.remove(at: index)
                                    } else {
                                        selectedRoshHashanahElements.append(element)
                                    }
                                }
                            }
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct RoshHashanahColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedRoshHashanahColorPalette: RoshHashanahColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Color Palette")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(RoshHashanahColorPalette.allPalettes, id: \.id) { palette in
                    VStack(spacing: 12) {
                        // Color Preview
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        palette.swiftUIColors.primary,
                                        palette.swiftUIColors.secondary,
                                        palette.swiftUIColors.accent
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedRoshHashanahColorPalette?.id == palette.id ? selectedEvent.category.primaryColor : Color.clear, lineWidth: 2)
                            )

                        VStack(spacing: 4) {
                            Text(palette.name)
                                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Text(palette.description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedRoshHashanahColorPalette = palette
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct RoshHashanahTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedRoshHashanahMessage: RoshHashanahPersonalTouch?
    @Binding var personalRoshHashanahMessage: String

    var body: some View {
        VStack(spacing: 24) {
            Text("Add Personal Touch")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            // Pre-written Messages
            VStack(spacing: 16) {
                HStack {
                    Text("Choose a Message")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    Spacer()
                    if !personalRoshHashanahMessage.isEmpty {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                personalRoshHashanahMessage = ""
                            }
                        }
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                    ForEach(RoshHashanahPersonalTouch.optionalMessages, id: \.id) { message in
                        MessageSelectionCard(
                            message: message.message,
                            tone: message.tone.rawValue,
                            isSelected: selectedRoshHashanahMessage?.id == message.id,
                            toneColor: message.tone.color,
                            onTap: {
                                selectedRoshHashanahMessage = message
                                personalRoshHashanahMessage = "" // Clear personal message
                            }
                        )
                    }
                }
            }

            // Custom Message Input
            VStack(spacing: 12) {
                HStack {
                    Text("Or Write Your Own")
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    Spacer()
                    if !personalRoshHashanahMessage.isEmpty {
                        Button("Clear") {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                personalRoshHashanahMessage = ""
                            }
                        }
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(selectedEvent.category.primaryColor)
                    }
                }

                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .frame(minHeight: 100)

                    VStack(alignment: .leading, spacing: 0) {
                        if personalRoshHashanahMessage.isEmpty {
                            Text(RoshHashanahPersonalTouch.personalMessagePlaceholder)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.top, 12)
                        }

                        TextEditor(text: $personalRoshHashanahMessage)
                            .font(.system(.body, design: .rounded))
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .onChange(of: personalRoshHashanahMessage) { _, newValue in
                                // Clear selected optional message if user types
                                if !newValue.isEmpty && selectedRoshHashanahMessage != nil {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedRoshHashanahMessage = nil
                                    }
                                }

                                // Limit character count
                                if newValue.count > RoshHashanahPersonalTouch.maxPersonalMessageLength {
                                    personalRoshHashanahMessage = String(newValue.prefix(RoshHashanahPersonalTouch.maxPersonalMessageLength))
                                }
                            }
                    }

                    HStack {
                        Spacer()
                        Text("\(personalRoshHashanahMessage.count)/\(RoshHashanahPersonalTouch.maxPersonalMessageLength)")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.secondary)
                    }
                    .padding(.trailing, 12)
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
            }

            // Selected Message Preview
            if selectedRoshHashanahMessage != nil || !personalRoshHashanahMessage.isEmpty {
                VStack(spacing: 8) {
                    Divider()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(selectedEvent.category.primaryColor)
                        Text("Personal touch added")
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

struct RoshHashanahCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedRoshHashanahTheme: RoshHashanahTheme?
    let selectedRoshHashanahElements: [RoshHashanahElement]
    let selectedRoshHashanahColorPalette: RoshHashanahColorPalette?
    let selectedRoshHashanahMessage: RoshHashanahPersonalTouch?
    let personalRoshHashanahMessage: String

    private var roshHashanahSelectionState: RoshHashanahSelectionState {
        RoshHashanahSelectionState(
            selectedTheme: selectedRoshHashanahTheme,
            selectedGift: selectedGift?.name,
            selectedElements: selectedRoshHashanahElements,
            selectedColorPalette: selectedRoshHashanahColorPalette,
            selectedOptionalMessage: selectedRoshHashanahMessage,
            personalMessage: personalRoshHashanahMessage
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Your Rosh Hashanah Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                    Text("Review your selections and generate your personalized gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Selection Summary
                VStack(spacing: 16) {
                    // Style Summary
                    if let theme = selectedRoshHashanahTheme, let gift = selectedGift {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "\(theme.rawValue) - \(gift.name)",
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "Choose a theme and gift",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Elements Summary
                    if !selectedRoshHashanahElements.isEmpty {
                        let elementNames = selectedRoshHashanahElements.map { $0.name }
                        SelectionSummaryCard(
                            title: "Elements",
                            content: elementNames.joined(separator: ", "),
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Elements",
                            content: "Choose design elements",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Color Summary
                    if let palette = selectedRoshHashanahColorPalette {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: palette.name,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: "Choose a color palette",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Personal Touch Summary
                    let hasPersonalTouch = selectedRoshHashanahMessage != nil || !personalRoshHashanahMessage.isEmpty
                    if hasPersonalTouch {
                        let message = selectedRoshHashanahMessage?.message ?? personalRoshHashanahMessage
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: message,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: "Add a personal message",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }
                }

                // Generate Button
                Button(action: {
                    // TODO: Implement AI generation
                    print("Generating Rosh Hashanah gift...")
                    print(roshHashanahSelectionState.summary)
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Generate Your Personal Designer Gift")
                    }
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(roshHashanahSelectionState.isComplete ? selectedEvent.category.primaryColor : Color(.systemGray4))
                    )
                }
                .disabled(!roshHashanahSelectionState.isComplete)
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Mid-Autumn Festival Style Content
struct MidAutumnFestivalStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedMidAutumnFestivalTheme: MidAutumnFestivalTheme?
    @Binding var showingGiftSelection: Bool
    @Binding var selectedMidAutumnFestivalElements: [MidAutumnFestivalElement]
    @Binding var selectedMidAutumnFestivalColorPalette: MidAutumnFestivalColorPalette?
    @Binding var selectedMidAutumnFestivalMessage: MidAutumnFestivalPersonalTouch?
    @Binding var personalMidAutumnFestivalMessage: String

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose a Mid-Autumn Festival Style")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            if selectedMidAutumnFestivalTheme == nil {
                // Show theme selection
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(MidAutumnFestivalTheme.allCases, id: \.self) { theme in
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(theme.primaryColor.gradient)
                                .frame(height: 120)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Text(theme.rawValue)
                                            .font(.system(.title3, design: .rounded).weight(.bold))
                                            .foregroundStyle(.white)
                                        Text(theme.description)
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundStyle(.white.opacity(0.8))
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding()
                                )
                                .onTapGesture {
                                    selectedMidAutumnFestivalTheme = theme
                                }
                        }
                    }
                }
            } else {
                // Show gift selection for chosen theme
                if let theme = selectedMidAutumnFestivalTheme {
                    VStack(spacing: 16) {
                        // Theme confirmation
                        HStack {
                            Text("Selected Style: \(theme.rawValue)")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Button("Change") {
                                selectedMidAutumnFestivalTheme = nil
                                selectedGift = nil
                            }
                            .font(.system(.subheadline, design: .rounded).weight(.medium))
                            .foregroundStyle(.blue)
                        }

                        // Gift options
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(theme.giftOptions, id: \.self) { giftName in
                                if let gift = availableGifts.first(where: { $0.name == giftName }) {
                                    VStack(spacing: 8) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedGift?.id == gift.id ? theme.primaryColor : Color(.systemGray5))
                                            .frame(height: 80)
                                            .overlay(
                                                Text(gift.name)
                                                    .font(.system(.caption, design: .rounded).weight(.medium))
                                                    .foregroundStyle(selectedGift?.id == gift.id ? .white : .primary)
                                                    .multilineTextAlignment(.center)
                                                    .padding(8)
                                            )
                                            .onTapGesture {
                                                selectedGift = gift
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Mid-Autumn Festival Elements Content
struct MidAutumnFestivalElementsContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedMidAutumnFestivalElements: [MidAutumnFestivalElement]

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Design Elements")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            Text("Select 1-3 elements to include in your design")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            // Centre Pieces
            VStack(alignment: .leading, spacing: 12) {
                Text("Centre Pieces")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(MidAutumnFestivalElement.centrePieces, id: \.id) { element in
                        ElementSelectionCard(
                            element: element.name,
                            isSelected: selectedMidAutumnFestivalElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleElement(element)
                        }
                    }
                }
            }

            // Supporting Elements
            VStack(alignment: .leading, spacing: 12) {
                Text("Supporting Elements")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                    ForEach(MidAutumnFestivalElement.supportingElements, id: \.id) { element in
                        ElementSelectionCard(
                            element: element.name,
                            isSelected: selectedMidAutumnFestivalElements.contains { $0.id == element.id },
                            culturalColor: selectedEvent.category.primaryColor
                        ) {
                            toggleElement(element)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }

    private func toggleElement(_ element: MidAutumnFestivalElement) {
        if let index = selectedMidAutumnFestivalElements.firstIndex(where: { $0.id == element.id }) {
            selectedMidAutumnFestivalElements.remove(at: index)
        } else if selectedMidAutumnFestivalElements.count < 3 {
            selectedMidAutumnFestivalElements.append(element)
        }
    }
}

// MARK: - Mid-Autumn Festival Color Content
struct MidAutumnFestivalColourContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedMidAutumnFestivalColorPalette: MidAutumnFestivalColorPalette?

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Color Palette")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(MidAutumnFestivalColorPalette.allPalettes, id: \.id) { palette in
                    VStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(hex: palette.primaryColor),
                                        Color(hex: palette.secondaryColor),
                                        Color(hex: palette.accentColor)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedMidAutumnFestivalColorPalette?.id == palette.id ? Color.primary : Color.clear, lineWidth: 3)
                            )
                            .onTapGesture {
                                selectedMidAutumnFestivalColorPalette = palette
                            }

                        VStack(spacing: 4) {
                            Text(palette.name)
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Text(palette.description)
                                .font(.system(.caption, design: .rounded))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Mid-Autumn Festival Touch Content
struct MidAutumnFestivalTouchContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedMidAutumnFestivalMessage: MidAutumnFestivalPersonalTouch?
    @Binding var personalMidAutumnFestivalMessage: String

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Personal Touch")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            Text("Choose a message or write your own")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)

            // Preset Messages
            LazyVGrid(columns: [GridItem(.flexible())], spacing: 12) {
                ForEach(MidAutumnFestivalPersonalTouch.optionalMessages, id: \.id) { message in
                    MessageSelectionCard(
                        message: message.message,
                        tone: message.tone.rawValue,
                        isSelected: selectedMidAutumnFestivalMessage?.id == message.id,
                        toneColor: message.tone.color
                    ) {
                        selectedMidAutumnFestivalMessage = selectedMidAutumnFestivalMessage?.id == message.id ? nil : message
                        if selectedMidAutumnFestivalMessage != nil {
                            personalMidAutumnFestivalMessage = ""
                        }
                    }
                }
            }

            // Custom Message
            VStack(alignment: .leading, spacing: 8) {
                Text("Or write your own message:")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                TextEditor(text: $personalMidAutumnFestivalMessage)
                    .frame(minHeight: 80)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .onChange(of: personalMidAutumnFestivalMessage) { _, _ in
                        if !personalMidAutumnFestivalMessage.isEmpty {
                            selectedMidAutumnFestivalMessage = nil
                        }
                    }

                Text("\(personalMidAutumnFestivalMessage.count)/\(MidAutumnFestivalPersonalTouch.maxPersonalMessageLength)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Mid-Autumn Festival Create Content
struct MidAutumnFestivalCreateContent: View {
    let selectedEvent: CulturalEvent
    let selectedGift: CulturalGift?
    let selectedMidAutumnFestivalTheme: MidAutumnFestivalTheme?
    let selectedMidAutumnFestivalElements: [MidAutumnFestivalElement]
    let selectedMidAutumnFestivalColorPalette: MidAutumnFestivalColorPalette?
    let selectedMidAutumnFestivalMessage: MidAutumnFestivalPersonalTouch?
    let personalMidAutumnFestivalMessage: String

    private var midAutumnFestivalSelectionState: MidAutumnFestivalSelectionState {
        MidAutumnFestivalSelectionState(
            selectedTheme: selectedMidAutumnFestivalTheme,
            selectedGift: selectedGift?.name,
            selectedElements: selectedMidAutumnFestivalElements,
            selectedColorPalette: selectedMidAutumnFestivalColorPalette,
            selectedOptionalMessage: selectedMidAutumnFestivalMessage,
            personalMessage: personalMidAutumnFestivalMessage
        )
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Create Your Mid-Autumn Festival Gift")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                    Text("Review your selections and generate your personalized gift")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                // Selection Summary
                VStack(spacing: 16) {
                    // Style Summary
                    if let theme = selectedMidAutumnFestivalTheme, let gift = selectedGift {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "\(theme.rawValue) - \(gift.name)",
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Style",
                            content: "Choose a theme and gift",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Elements Summary
                    if !selectedMidAutumnFestivalElements.isEmpty {
                        let elementNames = selectedMidAutumnFestivalElements.map { $0.name }
                        SelectionSummaryCard(
                            title: "Elements",
                            content: elementNames.joined(separator: ", "),
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Elements",
                            content: "Choose design elements",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Color Summary
                    if let palette = selectedMidAutumnFestivalColorPalette {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: palette.name,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Colors",
                            content: "Choose a color palette",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }

                    // Personal Touch Summary
                    let hasPersonalTouch = selectedMidAutumnFestivalMessage != nil || !personalMidAutumnFestivalMessage.isEmpty
                    if hasPersonalTouch {
                        let message = selectedMidAutumnFestivalMessage?.message ?? personalMidAutumnFestivalMessage
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: message,
                            isComplete: true,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    } else {
                        SelectionSummaryCard(
                            title: "Personal Touch",
                            content: "Add a personal message",
                            isComplete: false,
                            culturalColor: selectedEvent.category.primaryColor
                        )
                    }
                }

                // Generate Button
                Button(action: {
                    // TODO: Implement AI generation
                    print("Generating Mid-Autumn Festival gift...")
                    print(midAutumnFestivalSelectionState.summary)
                }) {
                    HStack {
                        Image(systemName: "wand.and.stars")
                        Text("Generate Your Personal Designer Gift")
                    }
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(midAutumnFestivalSelectionState.isComplete ? selectedEvent.category.primaryColor : Color(.systemGray4))
                    )
                }
                .disabled(!midAutumnFestivalSelectionState.isComplete)
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Raksha Bandhan Style Content
struct RakshaBandhanStyleContent: View {
    let selectedEvent: CulturalEvent
    @Binding var selectedGift: CulturalGift?
    @Binding var selectedRakshaBandhanTheme: RakshaBandhanTheme?
    @Binding var showingGiftSelection: Bool

    private var availableGifts: [CulturalGift] {
        CulturalGift.gifts(for: selectedEvent.category)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("Choose a Raksha Bandhan Style")
                .font(.system(.title3, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            if selectedRakshaBandhanTheme == nil {
                // Show theme selection
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                    ForEach(RakshaBandhanTheme.allCases, id: \.self) { theme in
                        VStack(spacing: 12) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(theme.primaryColor.gradient)
                                .frame(height: 120)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Text(theme.rawValue)
                                            .font(.system(.title3, design: .rounded).weight(.bold))
                                            .foregroundStyle(.white)
                                        Text(theme.description)
                                            .font(.system(.caption, design: .rounded))
                                            .foregroundStyle(.white.opacity(0.8))
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding()
                                )
                                .onTapGesture {
                                    selectedRakshaBandhanTheme = theme
                                }
                        }
                    }
                }
            } else {
                // Show gift selection for chosen theme
                if let theme = selectedRakshaBandhanTheme {
                    VStack(spacing: 16) {
                        // Theme confirmation
                        HStack {
                            Text("Selected Style: \(theme.rawValue)")
                                .font(.system(.headline, design: .rounded).weight(.semibold))
                                .foregroundStyle(.primary)
                            Spacer()
                            Button("Change") {
                                selectedRakshaBandhanTheme = nil
                                selectedGift = nil
                            }
                            .font(.system(.subheadline, design: .rounded).weight(.medium))
                            .foregroundStyle(.blue)
                        }

                        // Gift options
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                            ForEach(theme.giftOptions, id: \.self) { giftName in
                                if let gift = availableGifts.first(where: { $0.name == giftName }) {
                                    VStack(spacing: 8) {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedGift?.id == gift.id ? theme.primaryColor : Color(.systemGray5))
                                            .frame(height: 80)
                                            .overlay(
                                                Text(gift.name)
                                                    .font(.system(.caption, design: .rounded).weight(.medium))
                                                    .foregroundStyle(selectedGift?.id == gift.id ? .white : .primary)
                                                    .multilineTextAlignment(.center)
                                                    .padding(8)
                                            )
                                            .onTapGesture {
                                                selectedGift = gift
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 24)
    }
}

// MARK: - Generic UI Components
struct ElementSelectionCard: View {
    let element: String
    let isSelected: Bool
    let culturalColor: Color
    let onTap: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? culturalColor : Color(.systemGray5))
                .frame(height: 60)
                .overlay(
                    Text(element)
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(isSelected ? .white : .primary)
                        .multilineTextAlignment(.center)
                        .padding(8)
                )
                .onTapGesture(perform: onTap)
        }
    }
}

struct MessageSelectionCard: View {
    let message: String
    let tone: String
    let isSelected: Bool
    let toneColor: Color
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(tone)
                    .font(.system(.caption, design: .rounded).weight(.semibold))
                    .foregroundStyle(toneColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(toneColor.opacity(0.1))
                    .cornerRadius(6)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(toneColor)
                }
            }
            
            Text(message)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.leading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? toneColor.opacity(0.1) : Color(.systemGray6))
                .stroke(isSelected ? toneColor : Color.clear, lineWidth: 2)
        )
        .onTapGesture(perform: onTap)
    }
}

#Preview {
    CulturalGiftDesignView(
        selectedContact: Contact.sampleContacts[0],
        selectedEvent: CulturalEvent.allEvents[13] // Vesak Day
    )
}
