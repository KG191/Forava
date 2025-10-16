import SwiftUI
import Contacts
import ContactsUI

struct ContactSelectionView: View {
    let selectedEvent: CulturalEvent?
    let onContactSelected: ((Contact) -> Void)?

    @State private var selectedContact: Contact?
    @State private var showingContactPicker = false
    @State private var contacts: [Contact] = []
    @State private var showingPermissionAlert = false
    @Environment(\.dismiss) private var dismiss

    init(selectedEvent: CulturalEvent? = nil, onContactSelected: ((Contact) -> Void)? = nil) {
        self.selectedEvent = selectedEvent
        self.onContactSelected = onContactSelected
    }

    // Extracted background view to avoid type-checking timeout
    @ViewBuilder
    private var backgroundImage: some View {
        if let event = selectedEvent {
            Image(event.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(0.8)
                .opacity(0.3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                .ignoresSafeArea(.all)
                .clipped()
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background Image
                backgroundImage

                VStack(spacing: 0) {

                // Cultural Event Header
                if let event = selectedEvent {
                    VStack(spacing: 12) {
                        // Event indicator
                        HStack(spacing: 8) {
                            Image(systemName: event.category.icon)
                                .foregroundStyle(event.category.primaryColor)
                            Text(event.name)
                                .font(.system(.title2, design: .rounded).weight(.bold))
                                .foregroundStyle(.primary)
                        }

                        Text("Select a loved one to share this \(event.name) celebration")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                } else {
                    // Fallback header
                    VStack(spacing: 12) {
                        Text("Choose Your Connection")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.primary)

                        Text("Select a loved one to send a beautiful gift")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }

                // Contact List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(contacts) { contact in
                            ContactRow(
                                contact: contact,
                                isSelected: selectedContact?.id == contact.id
                            ) {
                                selectedContact = contact
                                if let onContactSelected = onContactSelected {
                                    onContactSelected(contact)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                }

                Spacer()

                // Bottom Actions
                VStack(spacing: 16) {
                    // Empty State when no contacts
                    if contacts.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 48))
                                .foregroundStyle(.orange)

                            VStack(spacing: 8) {
                                Text("No Contacts Added")
                                    .font(.system(.title3, design: .rounded).weight(.semibold))
                                    .foregroundStyle(.primary)

                                Text("Add contacts from your device to get started")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.vertical, 32)
                    }

                    Button {
                        requestContactAccess()
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Add from Contacts")
                        }
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(.orange.opacity(0.1), in: RoundedRectangle(cornerRadius: 16))
                        .foregroundStyle(.orange)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.orange, lineWidth: 1.5)
                        }
                    }
                    .buttonStyle(.plain)

                    if let selectedContact = selectedContact {
                        if onContactSelected != nil {
                            Button {
                                onContactSelected?(selectedContact)
                            } label: {
                                Text("Continue with \(selectedContact.name)")
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            }
                            .buttonStyle(ForavaPrimaryButton())
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else {
                            NavigationLink {
                                if let event = selectedEvent {
                                    TempCulturalGiftDesignView(selectedContact: selectedContact, selectedEvent: event)
                                } else {
                                    RakhiSelectionView(selectedContact: selectedContact, selectedEvent: selectedEvent)
                                }
                            } label: {
                                Text("Continue with \(selectedContact.name)")
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            }
                            .buttonStyle(ForavaPrimaryButton())
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                }
            }
            .background(Color(.systemGroupedBackground).opacity(selectedEvent != nil ? 0.7 : 1.0))
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingContactPicker) {
            ContactPickerView { pickedContact in
                if let contact = pickedContact {
                    contacts.append(contact)
                    selectedContact = contact
                }
            }
        }
        .alert("Contacts Permission Required", isPresented: $showingPermissionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Settings") {
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        } message: {
            Text("To add contacts, please allow access to your contacts in Settings. " +
                 "This helps you select recipients for your gifts.")
        }
    }

    private func requestContactAccess() {
        let store = CNContactStore()

        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            showingContactPicker = true
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, _ in
                DispatchQueue.main.async {
                    if granted {
                        showingContactPicker = true
                    }
                }
            }
        case .denied, .restricted, .limited:
            showingPermissionAlert = true
        @unknown default:
            break
        }
    }
}

struct ContactRow: View {
    let contact: Contact
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                // Avatar
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.orange.opacity(0.8), Color.red.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 50, height: 50)
                    .overlay {
                        Text(contact.name.prefix(1))
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.white)
                    }

                VStack(alignment: .leading, spacing: 4) {
                    Text(contact.name)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(contact.relationship ?? "")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.orange)
                        .font(.title2)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(.regularMaterial.opacity(0.5), in: RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? .orange : .clear, lineWidth: 2)
            }
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct ContactPickerView: UIViewControllerRepresentable {
    let onContactSelected: (Contact?) -> Void

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let picker = CNContactPickerViewController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onContactSelected: onContactSelected)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        let onContactSelected: (Contact?) -> Void

        init(onContactSelected: @escaping (Contact?) -> Void) {
            self.onContactSelected = onContactSelected
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            let forava = Contact(
                name: "\(contact.givenName) \(contact.familyName)",
                phoneNumber: contact.phoneNumbers.first?.value.stringValue ?? "",
                relationship: "Friend"
            )
            onContactSelected(forava)
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
            onContactSelected(nil)
        }
    }
}


#Preview {
    ContactSelectionView()
}
