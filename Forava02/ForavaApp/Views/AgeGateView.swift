//
//  AgeGateView.swift
//  Forava
//
//  Created for App Store Compliance
//  Age gate UI for AI-generated content (per Apple Guideline 1.2.1)
//
//  REQUIREMENT: Users must be 12+ to access AI features
//  COMPLIANCE: Age Rating Justification.md (12+ rating)
//

import SwiftUI

/// Age verification screen shown on first app launch
/// Blocks access to AI generation features until age is verified
struct AgeGateView: View {
    @EnvironmentObject var ageVerification: AgeVerification
    @State private var birthdate = Date()
    @State private var showDatePicker = false
    @State private var isVerifying = false
    @State private var showUnderageAlert = false

    // Date picker bounds (12-120 years old)
    private var dateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let now = Date()
        let minDate = calendar.date(byAdding: .year, value: -120, to: now) ?? now
        let maxDate = calendar.date(byAdding: .year, value: -AgeVerification.minimumAge, to: now) ?? now
        return minDate...maxDate
    }

    var body: some View {
        ZStack {
            // MARK: Background gradient (matches ContentView)
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#FF8A00"), location: 0.00),  // vivid orange (top)
                    .init(color: Color(hex: "#FFC170"), location: 0.52),  // light amber (middle)
                    .init(color: Color(hex: "#E05A00"), location: 1.00)   // deeper orange (bottom)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // MARK: App Icon/Logo Section
                VStack(spacing: 16) {
                    // Infinity symbol (matches landing page)
                    InfinityLoopView()
                        .frame(width: 80, height: 80)

                    Text("Forava")
                        .font(.system(size: 72, weight: .semibold, design: .serif))
                        .kerning(0.5)
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.15), radius: 8, y: 3)
                }

                // MARK: Age Verification Section
                VStack(spacing: 24) {
                    // Title
                    VStack(spacing: 8) {
                        Text("Age Verification Required")
                            .font(.system(.title2, design: .rounded).weight(.bold))
                            .foregroundStyle(.white)
                            .shadow(color: .black.opacity(0.3), radius: 4, y: 2)

                        Text("To access AI-generated content, you must be 12 or older")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                            .shadow(color: .black.opacity(0.2), radius: 3, y: 1)
                    }

                    // Birthday Input Card
                    VStack(spacing: 20) {
                        // Birthdate Display/Button
                        Button {
                            showDatePicker.toggle()
                        } label: {
                            HStack {
                                Image(systemName: "calendar")
                                    .font(.headline)
                                    .foregroundStyle(.orange)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Date of Birth")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)

                                    Text(birthdate, style: .date)
                                        .font(.headline)
                                        .foregroundStyle(.primary)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal, 32)

                        // Date Picker (shown when tapped)
                        if showDatePicker {
                            DatePicker(
                                "Select Birthdate",
                                selection: $birthdate,
                                in: dateRange,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            )
                            .padding(.horizontal, 32)
                            .transition(.opacity.combined(with: .scale))
                        }

                        // Error Message
                        if let errorMessage = ageVerification.errorMessage {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.caption)
                                Text(errorMessage)
                                    .font(.caption)
                            }
                            .foregroundStyle(.red)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.red.opacity(0.15))
                            )
                            .padding(.horizontal, 32)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }

                        // Verify Button
                        Button {
                            verifyAge()
                        } label: {
                            HStack {
                                if isVerifying {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.headline)
                                    Text("Verify Age")
                                        .font(.system(.headline, design: .rounded).weight(.semibold))
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "#FF8A00"), Color(hex: "#E05A00")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.white)
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.18), radius: 14, y: 8)
                        }
                        .disabled(isVerifying)
                        .padding(.horizontal, 32)
                    }
                    .padding(.vertical, 24)
                }

                // MARK: Privacy Notice
                VStack(spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "lock.shield.fill")
                            .font(.caption)
                        Text("Your privacy is protected")
                            .font(.caption.weight(.medium))
                    }
                    .foregroundStyle(.white.opacity(0.8))

                    Text("Your birthdate is stored locally on your device and never shared")
                        .font(.caption2)
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 48)
                }

                Spacer()
            }
        }
        .alert("Age Requirement Not Met", isPresented: $showUnderageAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You must be \(AgeVerification.minimumAge) or older to use Forava. If you believe this is an error, please contact support.")
        }
    }

    // MARK: - Functions

    private func verifyAge() {
        withAnimation {
            isVerifying = true
        }

        // Validate birthdate first
        guard ageVerification.validateBirthdate(birthdate) else {
            isVerifying = false
            return
        }

        // Verify age requirement
        let isVerified = ageVerification.verifyAge(birthdate: birthdate)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                isVerifying = false
            }

            if !isVerified {
                // Show alert if user is underage
                showUnderageAlert = true
            }
            // If verified, the @EnvironmentObject will automatically update
            // and App.swift will show the main app
        }
    }
}

// MARK: - Preview

#Preview("Age Gate - Unverified") {
    AgeGateView()
        .environmentObject(AgeVerification.previewUnverified())
}

#Preview("Age Gate - Date Picker Open") {
    struct PreviewWrapper: View {
        @StateObject private var verification = AgeVerification.previewUnverified()
        @State private var showPicker = true

        var body: some View {
            AgeGateView()
                .environmentObject(verification)
        }
    }

    return PreviewWrapper()
}
