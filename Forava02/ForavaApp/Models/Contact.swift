import Foundation

struct Contact: Identifiable, Codable {
    let id: UUID
    let name: String
    let phoneNumber: String
    let email: String?
    let relationship: String?

    init(name: String, phoneNumber: String = "", email: String? = nil, relationship: String? = nil) {
        self.id = UUID()
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.relationship = relationship
    }
}
