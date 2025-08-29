import SwiftUI

struct OnboardingView: View {
    @State private var selectedContact: Contact?
    @State private var showingDesignStudio = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if selectedContact == nil {
                    ContactSelectionView { contact in
                        selectedContact = contact
                        showingDesignStudio = true
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showingDesignStudio) {
            if let contact = selectedContact {
                RakhiDesignStudioView(selectedContact: contact)
            }
        }
    }
}
