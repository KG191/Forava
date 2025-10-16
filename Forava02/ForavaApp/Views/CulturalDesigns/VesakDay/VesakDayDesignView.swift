import SwiftUI
import Foundation

struct VesakDayDesignView: View {
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
