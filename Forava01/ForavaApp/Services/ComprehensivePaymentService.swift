import Foundation
import PassKit
import SwiftUI
import Combine

// MARK: - Comprehensive Apple Pay Integration Service

@MainActor
class ComprehensivePaymentService: NSObject, ObservableObject {
    static let shared = ComprehensivePaymentService()
    
    // MARK: - Published Properties
    @Published var isProcessingPayment = false
    @Published var paymentProgress: Float = 0.0
    @Published var paymentHistory: [PaymentRecord] = []
    @Published var suggestedAmounts: [PaymentSuggestion] = []
    @Published var culturalPaymentEnabled = true
    @Published var paymentPreferences: PaymentPreferences
    
    // MARK: - Payment Configuration
    private let merchantIdentifier = "merchant.com.forava.app"
    private let supportedNetworks: [PKPaymentNetwork] = [
        .visa, .masterCard, .amex, .discover, .rupay
    ]
    private let merchantCapabilities: PKMerchantCapability = [.threeDSecure, .debit, .credit]
    
    // MARK: - Cultural Intelligence
    @Published var culturalPaymentAnalyzer: CulturalPaymentAnalyzer
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        self.paymentPreferences = PaymentPreferences()
        self.culturalPaymentAnalyzer = CulturalPaymentAnalyzer()
        
        super.init()
        
        loadPaymentHistory()
        setupPaymentIntelligence()
        generateInitialSuggestions()
    }
    
    // MARK: - Apple Pay Availability & Setup
    
    func checkApplePayAvailability() -> ApplePayAvailability {
        guard PKPaymentAuthorizationViewController.canMakePayments() else {
            return .notAvailable
        }
        
        guard PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: supportedNetworks) else {
            return .noCardsSetup
        }
        
        return .available
    }
    
    func setupApplePayForCulturalGifts() -> PKPaymentRequest {
        let request = PKPaymentRequest()
        request.merchantIdentifier = merchantIdentifier
        request.supportedNetworks = supportedNetworks
        request.merchantCapabilities = merchantCapabilities
        request.countryCode = "IN"
        request.currencyCode = "INR"
        
        // Cultural payment configuration
        request.supportedCountries = Set(["IN", "US", "CA", "GB", "AU"])
        
        return request
    }
    
    // MARK: - Intelligent Payment Processing
    
    func processRakhiPayment(
        amount: Decimal,
        recipient: PaymentRecipient,
        rakhi: GeneratedRakhi,
        culturalContext: CulturalPaymentContext? = nil
    ) async throws -> PaymentResult {
        
        guard checkApplePayAvailability() == .available else {
            throw PaymentError.applePayNotAvailable
        }
        
        isProcessingPayment = true
        paymentProgress = 0.0
        
        defer {
            isProcessingPayment = false
            paymentProgress = 0.0
        }
        
        do {
            // Step 1: Validate and enhance amount with cultural intelligence
            paymentProgress = 0.2
            let enhancedAmount = try await enhanceAmountWithCulturalIntelligence(
                amount: amount,
                context: culturalContext
            )
            
            // Step 2: Create payment request
            paymentProgress = 0.4
            let paymentRequest = createCulturalPaymentRequest(
                amount: enhancedAmount,
                recipient: recipient,
                rakhi: rakhi
            )
            
            // Step 3: Process payment
            paymentProgress = 0.6
            let authorizationResult = try await presentPaymentAuthorization(paymentRequest)
            
            // Step 4: Complete transaction
            paymentProgress = 0.8
            let paymentResult = try await completePaymentTransaction(
                authorization: authorizationResult,
                originalAmount: amount,
                enhancedAmount: enhancedAmount
            )
            
            // Step 5: Record and analyze
            paymentProgress = 1.0
            recordPayment(paymentResult, rakhi: rakhi, recipient: recipient)
            updatePaymentIntelligence(paymentResult)
            
            return paymentResult
            
        } catch {
            recordFailedPayment(amount: amount, recipient: recipient, error: error)
            throw error
        }
    }
    
    // MARK: - Cultural Payment Intelligence
    
    private func enhanceAmountWithCulturalIntelligence(
        amount: Decimal,
        context: CulturalPaymentContext?
    ) async throws -> CulturallyEnhancedAmount {
        
        let analyzer = culturalPaymentAnalyzer
        
        // Analyze cultural appropriateness
        let culturalAnalysis = analyzer.analyzeCulturalAppropriateAmount(
            baseAmount: amount,
            context: context
        )
        
        // Generate suggestions
        let suggestions = analyzer.generateCulturalAmountSuggestions(
            baseAmount: amount,
            analysis: culturalAnalysis
        )
        
        // Apply cultural enhancement if enabled
        let finalAmount: Decimal
        if culturalPaymentEnabled && culturalAnalysis.shouldEnhance {
            finalAmount = suggestions.recommendedAmount
        } else {
            finalAmount = amount
        }
        
        return CulturallyEnhancedAmount(
            originalAmount: amount,
            enhancedAmount: finalAmount,
            culturalReasoning: culturalAnalysis.reasoning,
            suggestions: suggestions,
            enhancementApplied: culturalPaymentEnabled && culturalAnalysis.shouldEnhance
        )
    }
    
    private func createCulturalPaymentRequest(
        amount: CulturallyEnhancedAmount,
        recipient: PaymentRecipient,
        rakhi: GeneratedRakhi
    ) -> PKPaymentRequest {
        
        let request = setupApplePayForCulturalGifts()
        
        // Create payment summary items with cultural context
        var summaryItems: [PKPaymentSummaryItem] = []
        
        // Base Rakhi item
        summaryItems.append(PKPaymentSummaryItem(
            label: "🎊 \(rakhi.designSpec.genre.displayName) Rakhi Gift",
            amount: NSDecimalNumber(decimal: amount.originalAmount)
        ))
        
        // Cultural enhancement (if applicable)
        if amount.enhancementApplied {
            let enhancementAmount = amount.enhancedAmount - amount.originalAmount
            summaryItems.append(PKPaymentSummaryItem(
                label: "✨ Cultural Blessing Enhancement",
                amount: NSDecimalNumber(decimal: enhancementAmount)
            ))
        }
        
        // Total with cultural blessing
        let totalLabel = culturalPaymentEnabled ? 
            "🙏 Total Rakhi Gift with Blessings" : 
            "💝 Total Rakhi Gift"
        
        summaryItems.append(PKPaymentSummaryItem(
            label: totalLabel,
            amount: NSDecimalNumber(decimal: amount.enhancedAmount),
            type: .final
        ))
        
        request.paymentSummaryItems = summaryItems
        
        // Cultural shipping configuration
        configureCulturalShipping(request, recipient: recipient)
        
        return request
    }
    
    private func configureCulturalShipping(_ request: PKPaymentRequest, recipient: PaymentRecipient) {
        // Configure shipping for cultural appropriateness
        request.requiredShippingContactFields = [.name, .postalAddress]
        
        // Cultural shipping methods
        let standardShipping = PKShippingMethod(
            label: "🚚 Standard Delivery",
            amount: NSDecimalNumber(string: "0.00")
        )
        standardShipping.identifier = "standard"
        standardShipping.detail = "3-5 business days"
        
        let festivalShipping = PKShippingMethod(
            label: "🎊 Festival Express",
            amount: NSDecimalNumber(string: "50.00")
        )
        festivalShipping.identifier = "festival"
        festivalShipping.detail = "Next day delivery for festivals"
        
        let blessedDelivery = PKShippingMethod(
            label: "🙏 Blessed Delivery",
            amount: NSDecimalNumber(string: "25.00")
        )
        blessedDelivery.identifier = "blessed"
        blessedDelivery.detail = "Hand-delivered with blessings"
        
        request.shippingMethods = [standardShipping, festivalShipping, blessedDelivery]
    }
    
    // MARK: - Payment Authorization
    
    private func presentPaymentAuthorization(_ request: PKPaymentRequest) async throws -> PKPaymentAuthorization {
        return try await withCheckedThrowingContinuation { continuation in
            guard let viewController = PKPaymentAuthorizationViewController(paymentRequest: request) else {
                continuation.resume(throwing: PaymentError.failedToCreatePaymentViewController)
                return
            }
            
            viewController.delegate = self
            
            // Store continuation for delegate callbacks
            self.paymentContinuation = continuation
            
            // Present the payment authorization
            if let presentingViewController = UIApplication.shared.windows.first?.rootViewController {
                presentingViewController.present(viewController, animated: true)
            } else {
                continuation.resume(throwing: PaymentError.noPresentingViewController)
            }
        }
    }
    
    private var paymentContinuation: CheckedContinuation<PKPaymentAuthorization, Error>?
    
    private func completePaymentTransaction(
        authorization: PKPaymentAuthorization,
        originalAmount: Decimal,
        enhancedAmount: CulturallyEnhancedAmount
    ) async throws -> PaymentResult {
        
        // In production, this would process the payment with your payment processor
        // Simulate processing delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        let transactionId = generateTransactionId()
        
        return PaymentResult(
            transactionId: transactionId,
            originalAmount: originalAmount,
            processedAmount: enhancedAmount.enhancedAmount,
            culturalEnhancement: enhancedAmount,
            timestamp: Date(),
            status: .completed,
            paymentMethod: .applePay,
            culturalContext: generateCulturalContext(authorization)
        )
    }
    
    // MARK: - Payment Intelligence & Analytics
    
    private func setupPaymentIntelligence() {
        // Monitor payment patterns for cultural intelligence
        $paymentHistory
            .sink { [weak self] history in
                self?.analyzePaymentPatterns(history)
            }
            .store(in: &cancellables)
    }
    
    private func analyzePaymentPatterns(_ history: [PaymentRecord]) {
        culturalPaymentAnalyzer.updateAnalysisFromHistory(history)
        generateSmartSuggestions()
    }
    
    private func generateSmartSuggestions() {
        let analyzer = culturalPaymentAnalyzer
        
        suggestedAmounts = [
            PaymentSuggestion(
                amount: 101,
                reasoning: "Traditional auspicious amount (₹100 + ₹1 for blessing)",
                culturalSignificance: .high,
                category: .traditional
            ),
            PaymentSuggestion(
                amount: 251,
                reasoning: "Classic gift amount with cultural blessing",
                culturalSignificance: .medium,
                category: .balanced
            ),
            PaymentSuggestion(
                amount: 501,
                reasoning: "Generous amount for special relationships",
                culturalSignificance: .high,
                category: .generous
            ),
            PaymentSuggestion(
                amount: 1001,
                reasoning: "Premium blessing amount for close family",
                culturalSignificance: .highest,
                category: .premium
            )
        ]
        
        // Add personalized suggestions based on history
        let personalizedSuggestions = analyzer.generatePersonalizedSuggestions(from: paymentHistory)
        suggestedAmounts.append(contentsOf: personalizedSuggestions)
        
        // Sort by cultural significance and relevance
        suggestedAmounts.sort { $0.culturalSignificance.rawValue > $1.culturalSignificance.rawValue }
    }
    
    private func generateInitialSuggestions() {
        generateSmartSuggestions()
    }
    
    // MARK: - Payment Recording & History
    
    private func recordPayment(_ result: PaymentResult, rakhi: GeneratedRakhi, recipient: PaymentRecipient) {
        let record = PaymentRecord(
            id: UUID(),
            transactionId: result.transactionId,
            amount: result.processedAmount,
            originalAmount: result.originalAmount,
            recipient: recipient,
            rakhiId: rakhi.id,
            timestamp: result.timestamp,
            status: result.status,
            culturalEnhancement: result.culturalEnhancement.enhancementApplied,
            enhancementAmount: result.culturalEnhancement.enhancedAmount - result.culturalEnhancement.originalAmount
        )
        
        paymentHistory.append(record)
        savePaymentHistory()
        
        // Limit history size for performance
        if paymentHistory.count > 100 {
            paymentHistory = Array(paymentHistory.suffix(100))
        }
    }
    
    private func recordFailedPayment(amount: Decimal, recipient: PaymentRecipient, error: Error) {
        let record = PaymentRecord(
            id: UUID(),
            transactionId: "FAILED_\(UUID().uuidString.prefix(8))",
            amount: amount,
            originalAmount: amount,
            recipient: recipient,
            rakhiId: nil,
            timestamp: Date(),
            status: .failed,
            culturalEnhancement: false,
            enhancementAmount: 0,
            errorMessage: error.localizedDescription
        )
        
        paymentHistory.append(record)
        savePaymentHistory()
    }
    
    private func updatePaymentIntelligence(_ result: PaymentResult) {
        // Update cultural analyzer with successful payment data
        culturalPaymentAnalyzer.recordSuccessfulPayment(result)
        
        // Update user preferences based on choices
        if result.culturalEnhancement.enhancementApplied {
            paymentPreferences.prefersCulturalEnhancement = true
        }
        
        savePaymentPreferences()
    }
    
    // MARK: - Cultural Payment Features
    
    func getAuspiciousAmountForRelationship(_ relationship: FamilyRelationship) -> [PaymentSuggestion] {
        return culturalPaymentAnalyzer.getAuspiciousAmounts(for: relationship)
    }
    
    func validateCulturalAmountAppropriatenesss(_ amount: Decimal, context: CulturalPaymentContext) -> CulturalValidation {
        return culturalPaymentAnalyzer.validateAmount(amount, context: context)
    }
    
    func getCulturalPaymentTips() -> [CulturalPaymentTip] {
        return [
            CulturalPaymentTip(
                title: "Auspicious Numbers",
                description: "Adding ₹1 to round amounts brings good fortune",
                icon: "star.circle"
            ),
            CulturalPaymentTip(
                title: "Festival Timing",
                description: "Gifts during festivals carry extra blessings",
                icon: "calendar.circle"
            ),
            CulturalPaymentTip(
                title: "Odd Number Blessing",
                description: "Odd amounts (₹101, ₹251) are considered most auspicious",
                icon: "leaf.circle"
            )
        ]
    }
    
    // MARK: - Helper Methods
    
    private func generateTransactionId() -> String {
        let timestamp = Int(Date().timeIntervalSince1970)
        let randomSuffix = String(Int.random(in: 1000...9999))
        return "FORAVA_\(timestamp)_\(randomSuffix)"
    }
    
    private func generateCulturalContext(_ authorization: PKPaymentAuthorization) -> CulturalPaymentContext {
        return CulturalPaymentContext(
            festival: getCurrentFestival(),
            relationship: .sibling, // Would be determined from user input
            regionPreference: SimpleLocalizationService.shared.currentLanguage == .hindi ? .indian : .global,
            auspiciousTiming: isAuspiciousTime()
        )
    }
    
    private func getCurrentFestival() -> Festival? {
        let calendar = Calendar.current
        let now = Date()
        
        // Simple festival detection (would be more sophisticated in production)
        let month = calendar.component(.month, from: now)
        let day = calendar.component(.day, from: now)
        
        // Approximate Raksha Bandhan timing (varies yearly)
        if month == 8 && day >= 10 && day <= 25 {
            return .rakshaBandhan
        }
        
        return nil
    }
    
    private func isAuspiciousTime() -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        
        // Traditional auspicious times
        return (hour >= 6 && hour <= 10) || (hour >= 16 && hour <= 19)
    }
    
    // MARK: - Data Persistence
    
    private func loadPaymentHistory() {
        if let data = UserDefaults.standard.data(forKey: "payment_history"),
           let history = try? JSONDecoder().decode([PaymentRecord].self, from: data) {
            paymentHistory = history
        }
    }
    
    private func savePaymentHistory() {
        if let data = try? JSONEncoder().encode(paymentHistory) {
            UserDefaults.standard.set(data, forKey: "payment_history")
        }
    }
    
    private func savePaymentPreferences() {
        if let data = try? JSONEncoder().encode(paymentPreferences) {
            UserDefaults.standard.set(data, forKey: "payment_preferences")
        }
    }
}

// MARK: - PKPaymentAuthorizationViewControllerDelegate

extension ComprehensivePaymentService: PKPaymentAuthorizationViewControllerDelegate {
    nonisolated func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        // Process the payment
        Task { @MainActor in
            do {
                // Create authorization object
                let authorization = PKPaymentAuthorization(payment: payment)
                
                // Resume the continuation
                self.paymentContinuation?.resume(returning: authorization)
                self.paymentContinuation = nil
                
                // Complete with success
                completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
                
            } catch {
                self.paymentContinuation?.resume(throwing: error)
                self.paymentContinuation = nil
                
                completion(PKPaymentAuthorizationResult(status: .failure, errors: [error]))
            }
        }
    }
    
    nonisolated func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Supporting Types

struct PKPaymentAuthorization {
    let payment: PKPayment
    
    init(payment: PKPayment) {
        self.payment = payment
    }
}

enum ApplePayAvailability {
    case available
    case notAvailable
    case noCardsSetup
    
    var canProcess: Bool {
        return self == .available
    }
}

struct PaymentRecipient {
    let name: String
    let relationship: FamilyRelationship
    let address: PaymentAddress?
    let preferences: RecipientPreferences
}

struct PaymentAddress {
    let street: String
    let city: String
    let state: String
    let country: String
    let postalCode: String
}

struct RecipientPreferences {
    let preferredCurrency: String
    let culturalConsiderations: [String]
    let deliveryPreference: DeliveryPreference
}

enum DeliveryPreference {
    case standard
    case express
    case blessed
    case festival
}

enum FamilyRelationship: String, CaseIterable, Codable {
    case brother = "Brother"
    case sister = "Sister"
    case cousin = "Cousin"
    case friend = "Friend"
    case elderBrother = "Elder Brother"
    case youngerBrother = "Younger Brother"
    case elderSister = "Elder Sister"
    case youngerSister = "Younger Sister"
    case sibling = "Sibling"
    
    var traditionalAmount: Decimal {
        switch self {
        case .elderBrother, .elderSister: return 501
        case .brother, .sister: return 251
        case .youngerBrother, .youngerSister: return 101
        case .cousin: return 151
        case .friend: return 101
        case .sibling: return 251
        }
    }
}

// CulturalPaymentContext moved to EnhancedPaymentService.swift to avoid duplication

enum Festival: String, Codable {
    case rakshaBandhan = "Raksha Bandhan"
    case diwali = "Diwali"
    case holi = "Holi"
    case navratri = "Navratri"
    
    var blessingMultiplier: Decimal {
        switch self {
        case .rakshaBandhan: return 1.0
        case .diwali: return 1.1
        case .holi: return 1.05
        case .navratri: return 1.08
        }
    }
}

struct CulturallyEnhancedAmount {
    let originalAmount: Decimal
    let enhancedAmount: Decimal
    let culturalReasoning: String
    let suggestions: CulturalAmountSuggestions
    let enhancementApplied: Bool
}

struct CulturalAmountSuggestions {
    let recommendedAmount: Decimal
    let alternatives: [PaymentSuggestion]
    let reasoning: String
}

struct PaymentSuggestion: Identifiable {
    let id = UUID()
    let amount: Decimal
    let reasoning: String
    let culturalSignificance: CulturalSignificance
    let category: SuggestionCategory
}

enum CulturalSignificance: Int, Codable {
    case low = 1
    case medium = 2
    case high = 3
    case highest = 4
}

enum SuggestionCategory: String, Codable {
    case traditional = "Traditional"
    case balanced = "Balanced"
    case generous = "Generous"
    case premium = "Premium"
    case personalized = "Personalized"
}

struct PaymentResult {
    let transactionId: String
    let originalAmount: Decimal
    let processedAmount: Decimal
    let culturalEnhancement: CulturallyEnhancedAmount
    let timestamp: Date
    let status: PaymentStatus
    let paymentMethod: PaymentMethod
    let culturalContext: CulturalPaymentContext
}

enum PaymentStatus: String, Codable {
    case pending = "Pending"
    case completed = "Completed"
    case failed = "Failed"
    case cancelled = "Cancelled"
}

enum PaymentMethod: String, Codable {
    case applePay = "Apple Pay"
    case card = "Card"
    case bankTransfer = "Bank Transfer"
}

struct PaymentRecord: Identifiable, Codable {
    let id: UUID
    let transactionId: String
    let amount: Decimal
    let originalAmount: Decimal
    let recipient: PaymentRecipient
    let rakhiId: UUID?
    let timestamp: Date
    let status: PaymentStatus
    let culturalEnhancement: Bool
    let enhancementAmount: Decimal
    let errorMessage: String?
    
    init(id: UUID, transactionId: String, amount: Decimal, originalAmount: Decimal, recipient: PaymentRecipient, rakhiId: UUID?, timestamp: Date, status: PaymentStatus, culturalEnhancement: Bool, enhancementAmount: Decimal, errorMessage: String? = nil) {
        self.id = id
        self.transactionId = transactionId
        self.amount = amount
        self.originalAmount = originalAmount
        self.recipient = recipient
        self.rakhiId = rakhiId
        self.timestamp = timestamp
        self.status = status
        self.culturalEnhancement = culturalEnhancement
        self.enhancementAmount = enhancementAmount
        self.errorMessage = errorMessage
    }
}

struct PaymentPreferences: Codable {
    var prefersCulturalEnhancement: Bool = true
    var defaultCurrency: String = "INR"
    var autoSuggestAmounts: Bool = true
    var includeShippingInTotal: Bool = true
    var enableFestivalBonus: Bool = true
}

struct CulturalValidation {
    let isAppropriate: Bool
    let warnings: [String]
    let suggestions: [String]
    let culturalScore: Double
}

struct CulturalPaymentTip {
    let title: String
    let description: String
    let icon: String
}

// MARK: - Cultural Payment Analyzer

class CulturalPaymentAnalyzer: ObservableObject {
    @Published var analysisData: PaymentAnalysisData
    
    init() {
        self.analysisData = PaymentAnalysisData()
    }
    
    func analyzeCulturalAppropriateAmount(baseAmount: Decimal, context: CulturalPaymentContext?) -> CulturalAnalysis {
        var shouldEnhance = false
        var reasoning = ""
        
        // Check if amount ends in 1 (auspicious)
        let amountInt = Int(truncating: baseAmount as NSNumber)
        let lastDigit = amountInt % 10
        
        if lastDigit != 1 && baseAmount >= 100 {
            shouldEnhance = true
            reasoning = "Adding ₹1 makes the amount auspicious in Indian tradition"
        }
        
        // Festival context
        if let festival = context?.festival {
            shouldEnhance = true
            reasoning += reasoning.isEmpty ? "" : " and "
            reasoning += "festival timing adds extra significance"
        }
        
        return CulturalAnalysis(
            shouldEnhance: shouldEnhance,
            reasoning: reasoning.isEmpty ? "Amount is culturally appropriate" : reasoning,
            confidence: shouldEnhance ? 0.8 : 0.6
        )
    }
    
    func generateCulturalAmountSuggestions(baseAmount: Decimal, analysis: CulturalAnalysis) -> CulturalAmountSuggestions {
        let recommendedAmount = analysis.shouldEnhance ? baseAmount + 1 : baseAmount
        
        let alternatives = [
            PaymentSuggestion(amount: 101, reasoning: "Traditional auspicious starter amount", culturalSignificance: .high, category: .traditional),
            PaymentSuggestion(amount: 251, reasoning: "Balanced blessing amount", culturalSignificance: .medium, category: .balanced),
            PaymentSuggestion(amount: 501, reasoning: "Generous traditional gift", culturalSignificance: .high, category: .generous)
        ]
        
        return CulturalAmountSuggestions(
            recommendedAmount: recommendedAmount,
            alternatives: alternatives,
            reasoning: analysis.reasoning
        )
    }
    
    func getAuspiciousAmounts(for relationship: FamilyRelationship) -> [PaymentSuggestion] {
        let baseAmount = relationship.traditionalAmount
        
        return [
            PaymentSuggestion(amount: baseAmount, reasoning: "Traditional amount for \(relationship.rawValue)", culturalSignificance: .high, category: .traditional),
            PaymentSuggestion(amount: baseAmount + 50, reasoning: "Enhanced blessing", culturalSignificance: .medium, category: .balanced),
            PaymentSuggestion(amount: baseAmount * 2 + 1, reasoning: "Double blessing with auspicious ending", culturalSignificance: .highest, category: .generous)
        ]
    }
    
    func validateAmount(_ amount: Decimal, context: CulturalPaymentContext) -> CulturalValidation {
        var warnings: [String] = []
        var suggestions: [String] = []
        var score: Double = 0.8
        
        let amountInt = Int(truncating: amount as NSNumber)
        
        // Check auspicious ending
        if amountInt % 10 == 1 {
            score += 0.1
        } else if amountInt % 10 == 0 && amountInt >= 100 {
            warnings.append("Round amounts can be enhanced by adding ₹1")
            suggestions.append("Consider ₹\(amountInt + 1) for auspicious value")
        }
        
        // Check relationship appropriateness
        let traditionalAmount = context.relationship.traditionalAmount
        if amount < traditionalAmount * 0.5 {
            warnings.append("Amount may be low for \(context.relationship.rawValue)")
            score -= 0.2
        }
        
        return CulturalValidation(
            isAppropriate: score >= 0.6,
            warnings: warnings,
            suggestions: suggestions,
            culturalScore: score
        )
    }
    
    func updateAnalysisFromHistory(_ history: [PaymentRecord]) {
        // Update analysis based on payment patterns
        analysisData.totalPayments = history.count
        analysisData.averageAmount = calculateAverageAmount(history)
        analysisData.culturalEnhancementRate = calculateEnhancementRate(history)
    }
    
    func recordSuccessfulPayment(_ result: PaymentResult) {
        analysisData.lastSuccessfulPayment = result.timestamp
        if result.culturalEnhancement.enhancementApplied {
            analysisData.successfulEnhancements += 1
        }
    }
    
    func generatePersonalizedSuggestions(from history: [PaymentRecord]) -> [PaymentSuggestion] {
        guard !history.isEmpty else { return [] }
        
        let averageAmount = calculateAverageAmount(history)
        
        return [
            PaymentSuggestion(
                amount: averageAmount,
                reasoning: "Based on your typical gift amount",
                culturalSignificance: .medium,
                category: .personalized
            ),
            PaymentSuggestion(
                amount: averageAmount * 1.2 + 1,
                reasoning: "Slightly higher than usual with blessing",
                culturalSignificance: .high,
                category: .personalized
            )
        ]
    }
    
    private func calculateAverageAmount(_ history: [PaymentRecord]) -> Decimal {
        guard !history.isEmpty else { return 251 }
        
        let total = history.reduce(0) { $0 + $1.amount }
        return total / Decimal(history.count)
    }
    
    private func calculateEnhancementRate(_ history: [PaymentRecord]) -> Double {
        guard !history.isEmpty else { return 0 }
        
        let enhancedCount = history.filter { $0.culturalEnhancement }.count
        return Double(enhancedCount) / Double(history.count)
    }
}

struct PaymentAnalysisData {
    var totalPayments: Int = 0
    var averageAmount: Decimal = 0
    var culturalEnhancementRate: Double = 0
    var lastSuccessfulPayment: Date?
    var successfulEnhancements: Int = 0
}

struct CulturalAnalysis {
    let shouldEnhance: Bool
    let reasoning: String
    let confidence: Double
}

enum PaymentError: LocalizedError {
    case applePayNotAvailable
    case failedToCreatePaymentViewController
    case noPresentingViewController
    case paymentCancelled
    case paymentFailed(String)
    case invalidAmount
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .applePayNotAvailable:
            return "Apple Pay is not available on this device"
        case .failedToCreatePaymentViewController:
            return "Failed to create payment interface"
        case .noPresentingViewController:
            return "No view controller available to present payment"
        case .paymentCancelled:
            return "Payment was cancelled"
        case .paymentFailed(let message):
            return "Payment failed: \(message)"
        case .invalidAmount:
            return "Invalid payment amount"
        case .networkError:
            return "Network error during payment processing"
        }
    }
}

// MARK: - Codable Extensions

extension PaymentRecipient: Codable {}
extension PaymentAddress: Codable {}
extension RecipientPreferences: Codable {}
extension DeliveryPreference: Codable {}

// MARK: - Decimal Codable Extension

extension Decimal: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let doubleValue = try container.decode(Double.self)
        self.init(doubleValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(NSDecimalNumber(decimal: self).doubleValue)
    }
}