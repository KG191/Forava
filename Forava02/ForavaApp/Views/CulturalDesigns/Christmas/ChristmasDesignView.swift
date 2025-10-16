import SwiftUI
import Foundation

struct ChristmasDesignView: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    var body: some View {
        PlaceholderCulturalView(
            selectedContact: selectedContact,
            selectedEvent: selectedEvent,
            cultureName: selectedEvent.name
        )
    }
}
