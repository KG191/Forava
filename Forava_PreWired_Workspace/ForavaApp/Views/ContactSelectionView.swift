import SwiftUI
import Contacts
import ContactsUI

struct ContactSelectionView: View {
    let onContactSelected: ((RakhiModel.Contact) -> Void)?

    // @StateObject private var terminologyService = DynamicCulturalTerminologyService.shared
    private let digitalGiftTerm = "Rakhi"
    @State private var selectedContact: RakhiModel.Contact?
    @State private var showingContactPicker = false
    @State private var contacts: [RakhiModel.Contact] = []
    @Environment(\.dismiss) private var dismiss

    init(onContactSelected: ((RakhiModel.Contact) -> Void)? = nil) {
        self.onContactSelected = onContactSelected
    }

    var body: some View {
        VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    Text("Choose Your Connection")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Select a loved one to send a beautiful \(digitalGiftTerm)")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)

                    // Apple HIG compliant Add from Contacts button
                    Button(action: {
                        print("[DEBUG] Add from Contacts button tapped")
                        requestContactAccess()
                    }) {
                        Text("Add from Contacts")
                            .font(.system(.title3, design: .rounded).weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.orange)
                            .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
                    )
                    .frame(minHeight: 56) // Apple recommended minimum touch target
                    .padding(.horizontal, 4)

                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

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
                            .buttonStyle(.borderedProminent)
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
                            .buttonStyle(.borderedProminent)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingContactPicker, onDismiss: {
            print("[DEBUG] Contact picker sheet dismissed")
        }) {
            ContactPickerView { pickedContact in
                print("[DEBUG] Contact picker callback triggered")
                DispatchQueue.main.async {
                    self.showingContactPicker = false
                }

                if let contact = pickedContact {
                    print("[SUCCESS] Contact selected: \(contact.name)")
                    DispatchQueue.main.async {
                        self.contacts.append(contact)
                        self.selectedContact = contact
                    }

                    // Automatically proceed to next step if onContactSelected is provided
                    if let onContactSelected = self.onContactSelected {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            print("[INFO] Proceeding to next step with contact: \(contact.name)")
                            onContactSelected(contact)
                        }
                    }
                } else {
                    print("[ERROR] Contact picker was cancelled or no contact selected")
                }
            }
        }
    }

    private func requestContactAccess() {
        print("[DEBUG] Starting contact access request...")
        let store = CNContactStore()
        let currentStatus = CNContactStore.authorizationStatus(for: .contacts)
        print("[DEBUG] Current authorization status: \(currentStatus.rawValue)")

        switch currentStatus {
        case .authorized:
            print("[SUCCESS] Contact access already authorized, showing picker")
            DispatchQueue.main.async {
                self.showingContactPicker = true
            }
        case .notDetermined:
            print("[INFO] Contact access not determined, requesting permission")
            store.requestAccess(for: .contacts) { granted, error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("[ERROR] Contact access request failed: \(error.localizedDescription)")
                        return
                    }

                    if granted {
                        print("[SUCCESS] Contact access granted, showing picker")
                        self.showingContactPicker = true
                    } else {
                        print("[ERROR] Contact access denied by user")
                    }
                }
            }
        case .denied:
            print("[ERROR] Contact access denied - should show settings alert")
            // TODO: Show alert directing user to Settings
        case .restricted:
            print("[ERROR] Contact access restricted")
        case .limited:
            print("[WARNING] Contact access limited")
            DispatchQueue.main.async {
                self.showingContactPicker = true
            }
            @unknown default:
            print("[ERROR] Unknown contact authorization status")
        }
    }
}

typealias ContactRow = CommonViews.ContactRow

// Duplicate ContactPickerView removed - using the main one in SocialSharingView.swift

#Preview {
    ContactSelectionView()
}
