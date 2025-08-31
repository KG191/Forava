import Foundation

struct CustomizationPreset: Codable {
    let name: String
    let description: String
    private let settingsData: Data
    
    var settings: [String: Any] {
        (try? JSONSerialization.jsonObject(with: settingsData) as? [String: Any]) ?? [:]
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case settingsData = "settings"
    }
    
    init(name: String, description: String, settings: [String: Any]) throws {
        self.name = name
        self.description = description
        self.settingsData = try JSONSerialization.data(withJSONObject: settings)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        settingsData = try container.decode(Data.self, forKey: .settingsData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(settingsData, forKey: .settingsData)
    }
}
