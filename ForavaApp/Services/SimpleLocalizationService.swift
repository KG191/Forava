import Foundation
import SwiftUI

// MARK: - Simple Localization Service (English + Hindi + Cultural Elements)

@MainActor
class SimpleLocalizationService: ObservableObject {
    static let shared = SimpleLocalizationService()
    
    // MARK: - Published Properties
    @Published var currentLanguage: AppLanguage = .english
    @Published var showHindiGreetings: Bool = false
    @Published var useCulturalContext: Bool = true
    
    private init() {
        loadUserPreferences()
    }
    
    // MARK: - Core Localization
    
    func getString(_ key: String) -> String {
        return localizedStrings[currentLanguage]?[key] ?? localizedStrings[.english]?[key] ?? key
    }
    
    func changeLanguage(to language: AppLanguage) {
        currentLanguage = language
        saveUserPreferences()
    }
    
    // MARK: - Cultural Greetings
    
    func getCulturalGreeting() -> String {
        if showHindiGreetings || currentLanguage == .hindi {
            return "नमस्ते" // Namaste in Devanagari
        } else {
            return useCulturalContext ? "Namaste" : "Hello"
        }
    }
    
    func getRakhiBlessings() -> [String] {
        switch currentLanguage {
        case .english:
            return [
                "May you be blessed with happiness and prosperity",
                "May this sacred bond grow stronger each year",
                "Wishing you joy, love, and divine protection"
            ]
        case .hindi:
            return [
                "आप खुशियों और समृद्धि से भरे रहें",
                "यह पवित्र बंधन हर साल मजबूत होता रहे",
                "आनंद, प्रेम और दिव्य सुरक्षा की कामना"
            ]
        }
    }
    
    func getFestivalMessage() -> String {
        switch currentLanguage {
        case .english:
            return "Happy Raksha Bandhan! 🎊"
        case .hindi:
            return "रक्षा बंधन की शुभकामनाएं! 🎊"
        }
    }
    
    // MARK: - Cultural Elements
    
    func getCulturalElementName(_ element: String) -> String {
        let culturalElements = getCulturalElements()
        return culturalElements[element] ?? element
    }
    
    private func getCulturalElements() -> [String: String] {
        switch currentLanguage {
        case .english:
            return [
                "om": "Om Symbol",
                "lotus": "Lotus Flower",
                "kalash": "Sacred Kalash",
                "swastik": "Swastika (Good Fortune)",
                "peacock": "Peacock Feather"
            ]
        case .hindi:
            return [
                "om": "ॐ प्रतीक",
                "lotus": "कमल पुष्प",
                "kalash": "पवित्र कलश",
                "swastik": "स्वस्तिक",
                "peacock": "मोर पंख"
            ]
        }
    }
    
    // MARK: - Simple Formatting
    
    func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "INR"
        formatter.locale = currentLanguage == .hindi ? Locale(identifier: "hi_IN") : Locale(identifier: "en_IN")
        
        return formatter.string(from: NSNumber(value: amount)) ?? "$\(amount)"
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = currentLanguage == .hindi ? Locale(identifier: "hi_IN") : Locale(identifier: "en_IN")
        
        return formatter.string(from: date)
    }
    
    // MARK: - Data Storage
    
    private func loadUserPreferences() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "app_language"),
           let language = AppLanguage(rawValue: savedLanguage) {
            currentLanguage = language
        }
        
        showHindiGreetings = UserDefaults.standard.bool(forKey: "show_hindi_greetings")
        useCulturalContext = UserDefaults.standard.object(forKey: "use_cultural_context") as? Bool ?? true
    }
    
    private func saveUserPreferences() {
        UserDefaults.standard.set(currentLanguage.rawValue, forKey: "app_language")
        UserDefaults.standard.set(showHindiGreetings, forKey: "show_hindi_greetings")
        UserDefaults.standard.set(useCulturalContext, forKey: "use_cultural_context")
    }
    
    // MARK: - Localized Strings
    
    private let localizedStrings: [AppLanguage: [String: String]] = [
        .english: [
            // App Core
            "app_name": "Forava",
            "welcome": "Welcome to Forava",
            "get_started": "Get Started",
            
            // Rakhi Creation
            "create_rakhi": "Create Your Rakhi",
            "design_rakhi": "Design Your Rakhi",
            "traditional_designs": "Traditional Designs",
            "modern_designs": "Modern Designs",
            "elegant_designs": "Elegant Designs",
            "spiritual_designs": "Spiritual Designs",
            
            // Colors
            "choose_colors": "Choose Colors",
            "traditional_colors": "Traditional Colors",
            "vibrant_colors": "Vibrant Colors",
            "pastel_colors": "Pastel Colors",
            
            // Actions
            "generate": "Generate",
            "share": "Share",
            "save": "Save",
            "done": "Done",
            "cancel": "Cancel",
            "continue": "Continue",
            
            // Sharing
            "share_rakhi": "Share Your Beautiful Rakhi",
            "send_rakhi": "Send Rakhi",
            "share_message": "I created this beautiful Rakhi for you! 🎊",
            
            // Payment
            "send_gift": "Send Gift",
            "gift_amount": "Gift Amount",
            "pay_with_apple_pay": "Pay with Apple Pay",
            
            // Settings
            "settings": "Settings",
            "language": "Language",
            "cultural_greetings": "Cultural Greetings",
            
            // Messages
            "rakhi_created": "Your Rakhi has been created successfully!",
            "gift_sent": "Gift sent successfully!",
            "loading": "Loading...",
            "error": "Something went wrong. Please try again."
        ],
        
        .hindi: [
            // App Core
            "app_name": "फोरावा",
            "welcome": "फोरावा में आपका स्वागत है",
            "get_started": "शुरू करें",
            
            // Rakhi Creation
            "create_rakhi": "अपनी राखी बनाएं",
            "design_rakhi": "अपनी राखी का डिज़ाइन करें",
            "traditional_designs": "पारंपरिक डिज़ाइन",
            "modern_designs": "आधुनिक डिज़ाइन",
            "elegant_designs": "सुंदर डिज़ाइन",
            "spiritual_designs": "आध्यात्मिक डिज़ाइन",
            
            // Colors
            "choose_colors": "रंग चुनें",
            "traditional_colors": "पारंपरिक रंग",
            "vibrant_colors": "चमकदार रंग",
            "pastel_colors": "हल्के रंग",
            
            // Actions
            "generate": "बनाएं",
            "share": "साझा करें",
            "save": "सेव करें",
            "done": "हो गया",
            "cancel": "रद्द करें",
            "continue": "जारी रखें",
            
            // Sharing
            "share_rakhi": "अपनी सुंदर राखी साझा करें",
            "send_rakhi": "राखी भेजें",
            "share_message": "मैंने आपके लिए यह सुंदर राखी बनाई है! 🎊",
            
            // Payment
            "send_gift": "उपहार भेजें",
            "gift_amount": "उपहार राशि",
            "pay_with_apple_pay": "Apple Pay से भुगतान करें",
            
            // Settings
            "settings": "सेटिंग्स",
            "language": "भाषा",
            "cultural_greetings": "सांस्कृतिक अभिवादन",
            
            // Messages
            "rakhi_created": "आपकी राखी सफलतापूर्वक बन गई है!",
            "gift_sent": "उपहार सफलतापूर्वक भेजा गया!",
            "loading": "लोड हो रहा है...",
            "error": "कुछ गलत हुआ। कृपया पुनः प्रयास करें।"
        ]
    ]
}

// MARK: - Supporting Types

enum AppLanguage: String, CaseIterable {
    case english = "en"
    case hindi = "hi"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .hindi: return "हिंदी"
        }
    }
    
    var flag: String {
        switch self {
        case .english: return "🇺🇸"
        case .hindi: return "🇮🇳"
        }
    }
}

// MARK: - SwiftUI Extensions

extension SimpleLocalizationService {
    func localizedText(_ key: String) -> Text {
        Text(getString(key))
    }
}

// MARK: - Property Wrapper for Easy Use

@propertyWrapper
struct LocalizedString {
    private let key: String
    
    init(_ key: String) {
        self.key = key
    }
    
    var wrappedValue: String {
        return SimpleLocalizationService.shared.getString(key)
    }
}

// MARK: - View Extensions

extension View {
    func localized(_ key: String) -> some View {
        self.accessibilityLabel(SimpleLocalizationService.shared.getString(key))
    }
}