import SwiftUI

struct PreviewStep: View {
    let designSpec: RakhiDesignSpec
    let aiService: AIRakhiService
    @State private var showingPaymentSettings = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Your Custom Rakhi")
                    .font(.system(.title3, design: .rounded).weight(.bold))
                    .foregroundStyle(.primary)
                
                Text("Review your design before generation")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 20) {
                // Design Preview Card
                DesignPreviewCard(designSpec: designSpec)
                
                // Generation Progress
                if aiService.isGenerating {
                    GenerationProgressView(
                        progress: aiService.generationProgress,
                        currentStep: getCurrentGenerationStep(aiService.generationProgress)
                    )
                }
                
                // Note: Generated Result now shows on separate page via GeneratedRakhiView
                // Note: Payment Configuration moved to Generated Rakhi page
            }
        }
        .sheet(isPresented: $showingPaymentSettings) {
            PaymentSettingsView(designSpec: designSpec)
        }
    }
    
    private func getCurrentGenerationStep(_ progress: Float) -> String {
        switch progress {
        case 0.0..<0.2:
            return "Preparing design specification..."
        case 0.2..<0.4:
            return "Building AI prompt..."
        case 0.4..<0.8:
            return "Generating Rakhi image..."
        case 0.8..<0.95:
            return "Creating animations..."
        default:
            return "Finalizing your Rakhi..."
        }
    }
}

struct DesignPreviewCard: View {
    let designSpec: RakhiDesignSpec
    
    var body: some View {
        VStack(spacing: 20) {
            // Design Summary Header
            HStack {
                Image(systemName: "paintbrush.pointed.fill")
                    .foregroundStyle(.orange)
                
                Text("Design Summary")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                // Cultural Score
                CulturalScoreIndicator(score: calculateCulturalScore())
            }
            
            // Design Details Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                DesignDetailItem(
                    icon: designSpec.genre.icon,
                    title: "Style",
                    value: designSpec.genre.displayName,
                    color: .orange
                )
                
                DesignDetailItem(
                    icon: "circle.grid.2x2.fill",
                    title: "Elements",
                    value: "\(designSpec.elements.count) selected",
                    color: .blue
                )
                
                DesignDetailItem(
                    icon: "paintpalette.fill",
                    title: "Colors",
                    value: designSpec.colorPalette.rawValue,
                    color: .green
                )
                
                DesignDetailItem(
                    icon: "person.fill",
                    title: "Age Group",
                    value: designSpec.targetAgeGroup.rawValue,
                    color: .purple
                )
            }
            
            // Selected Elements
            if !designSpec.elements.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Design Elements")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
                        ForEach(designSpec.elements, id: \.id) { element in
                            ElementChip(element: element)
                        }
                    }
                }
            }
            
            // Personal Message
            if let message = designSpec.personalMessage, !message.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Personal Message")
                        .font(.system(.subheadline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text("\"\(message)\"")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .italic()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }
    
    private func calculateCulturalScore() -> Double {
        let validator = CulturalValidator.shared
        let result = validator.validateDesignSpec(designSpec)
        return result.culturalScore
    }
}

struct DesignDetailItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(.title2))
                .foregroundStyle(color)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.secondary)
                
                Text(value)
                    .font(.system(.subheadline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
    }
}

struct ElementChip: View {
    let element: DesignElement
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: element.category.icon)
                .font(.system(.caption2))
            
            Text(element.displayName)
                .font(.system(.caption, design: .rounded).weight(.medium))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.orange.opacity(0.1), in: Capsule())
        .foregroundStyle(.orange)
    }
}

struct CulturalScoreIndicator: View {
    let score: Double
    
    var scoreColor: Color {
        switch score {
        case 0.8...: return .green
        case 0.6..<0.8: return .orange
        default: return .red
        }
    }
    
    var scoreLabel: String {
        switch score {
        case 0.8...: return "Excellent"
        case 0.6..<0.8: return "Good"
        default: return "Fair"
        }
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Text("Cultural:")
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.secondary)
            
            Text(scoreLabel)
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .foregroundStyle(scoreColor)
            
            ForEach(0..<5) { index in
                Circle()
                    .fill(index < Int(score * 5) ? scoreColor : .gray.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(.regularMaterial, in: Capsule())
    }
}

struct GenerationProgressView: View {
    let progress: Float
    let currentStep: String
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "wand.and.stars")
                    .foregroundStyle(.orange)
                
                Text("Generating Your Rakhi")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.system(.subheadline, design: .rounded).weight(.bold))
                    .foregroundStyle(.orange)
            }
            
            VStack(spacing: 8) {
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                    .scaleEffect(y: 2)
                
                Text(currentStep)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.orange.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.orange.opacity(0.3), lineWidth: 1)
        }
    }
}


struct PaymentConfigurationSection: View {
    let designSpec: RakhiDesignSpec
    let onConfigurePayment: () -> Void
    
    // @StateObject private var paymentService = EnhancedPaymentService.shared
    // @State private var paymentContext: CulturalPaymentContext?
    
    private var suggestedAmount: Double {
        // AI-suggested amount based on design complexity and cultural context
        let baseAmount = 51.0 // Traditional starting amount
        let complexityMultiplier = 1.0 + (Double(designSpec.elements.count) * 0.1)
        let culturalMultiplier = calculateCulturalScore()
        
        let suggested = baseAmount * complexityMultiplier * culturalMultiplier
        
        // Round to culturally appropriate amounts (ending in 1)
        let rounded = round(suggested / 10) * 10 + 1
        return min(max(rounded, 21), 501) // Keep within reasonable bounds
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "indianrupeesign.circle.fill")
                    .foregroundStyle(.green)
                
                Text("Gift Amount Suggestion")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                HStack {
                    Text("Suggested Amount:")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("₹\(Int(suggestedAmount))")
                        .font(.system(.title3, design: .rounded).weight(.bold))
                        .foregroundStyle(.green)
                }
                
                Text("Based on design complexity and cultural significance")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 12) {
                    Button("Configure Payment Options") {
                        onConfigurePayment()
                    }
                    .font(.system(.subheadline, design: .rounded).weight(.medium))
                    .foregroundStyle(.green)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                    
                    // Enhanced payment options (Phase 2.4 - ready for integration)
                    // if let context = paymentContext {
                    //     EnhancedPaymentOptionsView(context: context)
                    // }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(.green.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(.green.opacity(0.3), lineWidth: 1)
        }
        // .onAppear {
        //     Task {
        //         // Load payment context with relationship detection (Phase 2.4 - ready for integration)
        //         let relationship = RelationshipType.detectFrom(contact: Contact(name: "Sample Contact"))
        //         paymentContext = await paymentService.analyzeCulturalPaymentContext(
        //             designSpec: designSpec,
        //             recipient: Contact(name: "Sample Contact"),
        //             relationship: relationship
        //         )
        //     }
        // }
    }
    
    private func calculateCulturalScore() -> Double {
        let validator = CulturalValidator.shared
        let result = validator.validateDesignSpec(designSpec)
        return result.culturalScore
    }
}

struct PaymentSettingsView: View {
    let designSpec: RakhiDesignSpec
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Payment configuration will be implemented in the next phase")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .navigationTitle("Payment Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    PreviewStep(
        designSpec: RakhiDesignSpec(
            genre: .traditional,
            elements: Array(DesignElementsDatabase.shared.getAllElements().prefix(3)),
            colorPalette: .traditional,
            personalMessage: "Wishing you happiness and prosperity!",
            targetAgeGroup: .adult
        ),
        aiService: AIRakhiService.shared
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}