import SwiftUI

// MARK: - Cultural Gift Design Routing
// 🎯 SINGLE SOURCE OF TRUTH for all cultural design routing
// ⚠️ IMPORTANT: When adding a new cultural design:
//    1. Add the case here in the switch statement
//    2. Ensure the corresponding DesignView file exists
//    3. Build and test thoroughly before moving to next culture
//    4. CulturalGiftDesignView is the only router — no legacy duplicates
struct CulturalGiftDesignView: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    var body: some View {
        Group {
            // Route to appropriate cultural design component based on event name
            switch selectedEvent.name.lowercased() {
            case "anniversary":
                AnniversaryDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "chinese new year":
                ChineseNewYearDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "diwali":
                DiwaliDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "vesak day":
                VesakDayDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "rosh hashanah":
                RoshHashanahDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "raksha bandhan":
                RakshaBandhanDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "mid-autumn festival":
                MidAutumnFestivalDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "hanukkah":
                HanukkahDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "easter":
                EasterDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "christmas":
                ChristmasDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "eid al-adha":
                EidAlAdhaDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            case "holi":
                HoliDesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)

            default:
                // Fallback for unrecognized events (should not be reached)
                VStack(spacing: 24) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundStyle(.orange)

                    Text("Event Not Available")
                        .font(.system(.title, design: .rounded).weight(.bold))

                    Text("This cultural event is not currently supported.")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(32)
                .background(Color(.systemGroupedBackground))
            }
        }
        .navigationTitle("Gift Design")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Generic Fallback View
struct GenericCulturalDesignView: View {
    let selectedContact: Contact
    let selectedEvent: CulturalEvent

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "gift.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)

            Text("Cultural Gift Design")
                .font(.title)
                .fontWeight(.semibold)

            Text("Creating personalized \(selectedEvent.name.lowercased()) gifts for \(selectedContact.name)")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            Text("This cultural tradition is being developed.")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
        }
        .padding()
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        CulturalGiftDesignView(
            selectedContact: Contact.sampleContacts.first!,
            selectedEvent: CulturalEvent.allEvents.first!
        )
    }
}
