import SwiftUI
import Contacts
import ContactsUI

struct ContactSelectionView: View {
    let onContactSelected: ((Contact) -> Void)?
    
    @State private var selectedContact: Contact?
    @State private var showingContactPicker = false
    @State private var contacts: [Contact] = Contact.sampleContacts
    @State private var searchText = ""
    @Environment(\.dismiss) private var dismiss
    
    init(onContactSelected: ((Contact) -> Void)? = nil) {
        self.onContactSelected = onContactSelected
    }
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contacts
        } else {
            return contacts.filter { contact in
                contact.name.localizedCaseInsensitiveContains(searchText) ||
                contact.relationship.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 12) {
                    Text("Choose Your Connection")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)
                    
                    Text("Select a loved one to send a beautiful Rakhi")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.secondary)
                    
                    TextField("Search contacts...", text: $searchText)
                        .textFieldStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Contact List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredContacts) { contact in
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
                    Button("Add from Contacts") {
                        requestContactAccess()
                    }
                    .buttonStyle(ForavaSecondaryButtonStyle())
                    
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
                            .buttonStyle(ForavaPrimaryButtonStyle())
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        } else {
                            NavigationLink {
                                RakhiSelectionView(selectedContact: selectedContact)
                            } label: {
                                Text("Continue with \(selectedContact.name)")
                                    .font(.system(.body, design: .rounded).weight(.semibold))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                            }
                            .buttonStyle(ForavaPrimaryButtonStyle())
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.orange)
                }
            }
        }
        .sheet(isPresented: $showingContactPicker) {
            ContactPickerView { pickedContact in
                if let contact = pickedContact {
                    contacts.append(contact)
                    selectedContact = contact
                }
            }
        }
    }
    
    private func requestContactAccess() {
        let store = CNContactStore()
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            showingContactPicker = true
        case .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        showingContactPicker = true
                    }
                }
            }
        case .denied, .restricted, .limited:
            // Show alert to go to settings
            break
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
                    
                    Text(contact.relationship)
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
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
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