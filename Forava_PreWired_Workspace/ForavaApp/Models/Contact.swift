import Foundation

struct Contact: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let phoneNumber: String
    let relationship: RelationType
    
    init(name: String, phoneNumber: String, relationship: RelationType) {
        self.name = name
        self.phoneNumber = phoneNumber
        self.relationship = relationship
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        lhs.id == rhs.id
    }
}

enum RelationType: String, Codable {
    case sister = "Sister"
    case brother = "Brother"
    case cousin = "Cousin"
    case friend = "Friend"
    case other = "Other"
    
    var displayName: String {
        self.rawValue
    }
}

// Extension for test data
extension Contact {
    static var sampleContacts: [Contact] {
        [
            Contact(name: "Priya", phoneNumber: "+1234567890", relationship: .sister),
            Contact(name: "Raj", phoneNumber: "+0987654321", relationship: .brother),
            Contact(name: "Meera", phoneNumber: "+1122334455", relationship: .cousin),
            Contact(name: "Anita", phoneNumber: "+5544332211", relationship: .friend)
        ]
    }
}
