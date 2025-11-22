import SwiftUI
import Foundation

struct RoshHashanahPersonalTouchView: View {
    @Binding var selectedMessage: RoshHashanahPersonalTouch?
    @Binding var personalMessage: String
    let culturalColor: Color

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                contentContainer
            }
        }
        .background(backgroundGradient)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Text("Add a Personal Touch")
                .font(.system(.title2, design: .rounded).weight(.bold))
                .foregroundStyle(.primary)

            Text("Choose a heartfelt message or write your own for Rosh Hashanah")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }

    private var contentContainer: some View {
        VStack(spacing: 20) {
            // Pre-written Messages
            VStack(spacing: 12) {
                ForEach(RoshHashanahPersonalTouch.allTouches) { touch in
                    messageCard(message: touch)
                }
            }

            Divider()
                .padding(.vertical, 8)

            customMessageInput
        }
        .padding(.vertical, 24)
        .background(glassMorphismBackground)
        .padding(.horizontal, 16)
    }

    private var customMessageInput: some View {
        VStack(spacing: 12) {
            Text("Or Write Your Own Message")
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            TextField(
                RoshHashanahPersonalTouch.personalMessagePlaceholder,
                text: $personalMessage,
                axis: .vertical
            )
            .lineLimit(3...5)
            .textFieldStyle(.plain)
            .padding(16)
            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(personalMessage.isEmpty ? .clear : culturalColor, lineWidth: 2)
            )
            .onChange(of: personalMessage) { _, newValue in
                if !newValue.isEmpty {
                    selectedMessage = nil
                }
            }

            Text("\(personalMessage.count)/\(RoshHashanahPersonalTouch.maxMessageLength)")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 20)
    }

    private var glassMorphismBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(.thinMaterial)
            .background(RoundedRectangle(cornerRadius: 20).fill(culturalColor.opacity(0.03)))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(culturalColor.opacity(0.3), lineWidth: 1)
            )
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [culturalColor.opacity(0.08), .white],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    @ViewBuilder
    private func messageCard(message: RoshHashanahPersonalTouch) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                selectedMessage = message
                personalMessage = ""
            }
        } label: {
            HStack(spacing: 16) {
                // Tone Color Indicator
                RoundedRectangle(cornerRadius: 8)
                    .fill(message.tone.color.gradient)
                    .frame(width: 4, height: 60)

                VStack(alignment: .leading, spacing: 6) {
                    // Message
                    Text(message.message)
                        .font(.system(.body, design: .rounded).weight(.semibold))
                        .foregroundStyle(.primary)
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
            .padding(.horizontal, 20)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RoshHashanahPersonalTouchView(
        selectedMessage: .constant(RoshHashanahPersonalTouch.allTouches[0]),
        personalMessage: .constant(""),
        culturalColor: Color(hex: "#4169E1")
    )
}
