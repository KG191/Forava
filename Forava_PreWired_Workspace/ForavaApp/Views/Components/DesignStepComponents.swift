import SwiftUI

// MARK: - Design Steps Enum
enum DesignStep: Int, CaseIterable {
    case genre = 0
    case elements = 1
    case colors = 2
    case personalization = 3
    case preview = 4

    var title: String {
        switch self {
        case .genre: return "Style"
        case .elements: return "Elements"
        case .colors: return "Colors"
        case .personalization: return "Personal"
        case .preview: return "Preview"
        }
    }

    var description: String {
        switch self {
        case .genre: return "Choose the overall style and feel"
        case .elements: return "Select decorative elements"
        case .colors: return "Pick your color palette"
        case .personalization: return "Add personal touches"
        case .preview: return "Review and generate"
        }
    }

    var icon: String {
        switch self {
        case .genre: return "star.circle.fill"
        case .elements: return "circle.grid.2x2.fill"
        case .colors: return "paintpalette.fill"
        case .personalization: return "heart.fill"
        case .preview: return "eye.fill"
        }
    }

    func next() -> DesignStep? {
        let nextRawValue = rawValue + 1
        return DesignStep(rawValue: nextRawValue)
    }

    func previous() -> DesignStep? {
        let prevRawValue = rawValue - 1
        return DesignStep(rawValue: prevRawValue)
    }
}

// MARK: - Progress Header
struct DesignProgressHeader: View {
    let currentStep: DesignStep
    let totalSteps: Int

    var progress: Float {
        Float(currentStep.rawValue + 1) / Float(totalSteps)
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentStep.title)
                        .font(.system(.headline, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(currentStep.description)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Image(systemName: currentStep.icon)
                        .font(.system(.title2))
                        .foregroundStyle(.orange)

                    Text("\(currentStep.rawValue + 1) of \(totalSteps)")
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }

            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .orange))
                .scaleEffect(y: 1.5)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color(.systemGray6))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1)
        }
    }
}

// MARK: - Navigation Footer
struct DesignNavigationFooter: View {
    @Binding var currentStep: DesignStep
    let designSpec: RakhiDesignSpec
    let onGenerate: () -> Void
    let isGenerating: Bool
    let onStepChange: (@escaping () -> Void) -> Void

    var canProceed: Bool {
        switch currentStep {
        case .genre:
            return designSpec.genre != .unknown
        case .elements:
            return !designSpec.elements.isEmpty
        case .colors:
            return true // Color palette always has a default
        case .personalization:
            return true // Optional step
        case .preview:
            return !isGenerating
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            // Back Button
            if currentStep != .genre {
                Button {
                    onStepChange {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if let prevStep = currentStep.previous() {
                                currentStep = prevStep
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .buttonStyle(ForavaSecondaryButtonStyle())
            }

            // Next/Generate Button
            Button {
                if currentStep == .preview {
                    onGenerate()
                } else {
                    onStepChange {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            if let nextStep = currentStep.next() {
                                currentStep = nextStep
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    if isGenerating {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                        Text("Generating...")
                    } else {
                        Text(currentStep == .preview ? "Generate Rakhi" : "Next")
                        if currentStep != .preview {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .font(.system(.body, design: .rounded).weight(.semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
            }
            .buttonStyle(ForavaPrimaryButtonStyle())
            .disabled(!canProceed || isGenerating)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
        .padding(.top, 16)
        .background(
            LinearGradient(
                colors: [.clear, Color(.systemBackground).opacity(0.9)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
