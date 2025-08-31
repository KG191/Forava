import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var terminologyService: DynamicCulturalTerminologyService
    @EnvironmentObject var subscriptionManager: SubscriptionManager

    @State private var selectedContact: RakhiModel.Contact?
    @State private var showingDesignStudio = false

    var body: some View {
        NavigationStack {
            VStack {
                if selectedContact == nil {
                    ContactSelectionView { contact in
                        selectedContact = contact
                        showingDesignStudio = true
                    }
                    .environmentObject(terminologyService)
                    .environmentObject(subscriptionManager)
                }
            }
        }
        .fullScreenCover(isPresented: $showingDesignStudio, onDismiss: {
            selectedContact = nil
        }) {
            if let contact = selectedContact {
                CulturalDesignStudioView(selectedContact: contact)
                    .environmentObject(terminologyService)
                    .environmentObject(subscriptionManager)
            }
        }
    }
}
