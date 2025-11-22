import SwiftUI
import Foundation

struct HoliPersonalTouchView: View {
    @Binding var selectedMessage: HoliPersonalTouch?
    @Binding var personalMessage: String
    let culturalColor: Color

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Add Personal Touch")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Choose a message or write your own Holi greeting")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 24) {
                    // Preset Messages
                    VStack(spacing: 16) {
                        Text("Preset Messages")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        ForEach(HoliPersonalTouch.optionalMessages) { message in
                            messageCard(message: message)
                        }
                    }

                    // Custom Message Input
                    VStack(spacing: 12) {
                        Text("Or Write Your Own")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)

                        TextEditor(text: $personalMessage)
                            .frame(height: 120)
                            .padding(12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(personalMessage.isEmpty ? Color.secondary.opacity(0.3) : culturalColor, lineWidth: 2)
                            )
                            .focused($isTextFieldFocused)
                            .padding(.horizontal, 20)
                            .onChange(of: personalMessage) { _, newValue in
                                if !newValue.isEmpty {
                                    // Clear preset selection when typing
                                    selectedMessage = nil
                                }
                            }

                        Text("\(personalMessage.count)/\(HoliPersonalTouch.maxPersonalMessageLength)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 20)
                    }
                }
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.thinMaterial)
                        .background(RoundedRectangle(cornerRadius: 20).fill(culturalColor.opacity(0.03)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(culturalColor.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 16)

                Spacer(minLength: 100)
            }
        }
        .background(
            LinearGradient(
                colors: [culturalColor.opacity(0.08), .white],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .onTapGesture {
            isTextFieldFocused = false
        }
    }

    @ViewBuilder
    private func messageCard(message: HoliPersonalTouch) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedMessage = message
                personalMessage = "" // Clear custom message
                isTextFieldFocused = false
            }
        } label: {
            VStack(spacing: 12) {
                HStack(spacing: 16) {
                    // Tone Color Indicator
                    RoundedRectangle(cornerRadius: 8)
                        .fill(message.tone.color.gradient)
                        .frame(width: 4, height: 60)

                    VStack(alignment: .leading, spacing: 6) {
                        // Hindi Message
                        Text(message.hindiMessage)
                            .font(.system(.body, design: .rounded).weight(.semibold))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // English Message
                        Text(message.message)
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        // Tone Label
                        Text(message.tone.rawValue)
                            .font(.system(.caption, design: .rounded).weight(.medium))
                            .foregroundStyle(message.tone.color)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                Capsule()
                                    .fill(message.tone.color.opacity(0.15))
                            )
                    }

                    // Selection Indicator
                    if selectedMessage?.id == message.id {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(culturalColor)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(selectedMessage?.id == message.id ? culturalColor.opacity(0.15) : culturalColor.opacity(0.05))
                )
            }
            .padding(.horizontal, 20)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HoliPersonalTouchView(
        selectedMessage: .constant(HoliPersonalTouch.optionalMessages[0]),
        personalMessage: .constant(""),
        culturalColor: Color(hex: "#FF6B35")
    )
}
