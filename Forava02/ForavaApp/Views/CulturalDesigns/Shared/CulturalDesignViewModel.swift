import SwiftUI
import Foundation
import Combine

class CulturalDesignViewModel: ObservableObject {
    @Published var currentTab: GiftDesignTab = .style
    @Published var selectedGift: CulturalGift?
    @Published var showingGiftSelection: Bool = false

    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    init(selectedContact: Contact, selectedEvent: CulturalEvent) {
        self.selectedContact = selectedContact
        self.selectedEvent = selectedEvent
    }

    var culturalColor: Color {
        return selectedEvent.category.primaryColor
    }

    var culturalIcon: String {
        return selectedEvent.category.icon
    }

    var culturalTitle: String {
        return selectedEvent.selectionTitle
    }

    var availableGifts: [CulturalGift] {
        return CulturalGift.gifts(for: selectedEvent.category)
    }

    func nextTab() {
        guard let currentIndex = GiftDesignTab.allCases.firstIndex(of: currentTab),
              currentIndex < GiftDesignTab.allCases.count - 1 else {
            return
        }

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentTab = GiftDesignTab.allCases[currentIndex + 1]
        }
    }

    func previousTab() {
        guard let currentIndex = GiftDesignTab.allCases.firstIndex(of: currentTab),
              currentIndex > 0 else {
            return
        }

        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            currentTab = GiftDesignTab.allCases[currentIndex - 1]
        }
    }
}

extension CulturalSelectionState {
    var canProceedToNextStep: Bool {
        return isComplete
    }
}
