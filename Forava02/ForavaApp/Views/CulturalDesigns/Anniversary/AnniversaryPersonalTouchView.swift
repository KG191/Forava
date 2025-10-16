import SwiftUI
import Foundation

struct AnniversaryPersonalTouchView: View {
    @Binding var selectedMessage: AnniversaryPersonalTouch?
    @Binding var personalMessage: String
    let culturalColor: Color

    @State private var showingCustomInput = false
    @FocusState private var isTextFieldFocused: Bool

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Text("Add Personal Touch")
                        .font(.system(.title2, design: .rounded).weight(.bold))
                        .foregroundStyle(.primary)

                    Text("Choose a heartfelt message or write your own personal note")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                // Glass Morphism Content Container
                VStack(spacing: 24) {
                    // Pre-written Messages Section
                    prewrittenMessagesSection()

                    Divider()
                        .padding(.horizontal, 20)

                    // Custom Message Section
                    customMessageSection()

                    // Message Preview
                    if hasSelectedMessage {
                        messagePreview()
                    }
                }
                .padding(.vertical, 24)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(culturalColor.opacity(0.3), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 16)

                Spacer(minLength: 100)
            }
        }
        .background(Color(.systemGroupedBackground))
    }

    @ViewBuilder
    private func prewrittenMessagesSection() -> some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                Image(systemName: "quote.bubble.fill")
                    .foregroundStyle(culturalColor)
                    .font(.title2)

                Text("Pre-written Messages")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()
            }
            .padding(.horizontal, 20)

            // Messages Grid
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(AnniversaryPersonalTouch.optionalMessages) { message in
                    messageCard(
                        message: message,
                        isSelected: selectedMessage?.id == message.id && personalMessage.isEmpty
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }

    @ViewBuilder
    private func messageCard(message: AnniversaryPersonalTouch, isSelected: Bool) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                if selectedMessage?.id == message.id {
                    selectedMessage = nil
                } else {
                    selectedMessage = message
                    personalMessage = ""
                    showingCustomInput = false
                }
            }
        } label: {
            VStack(spacing: 12) {
                // Tone Color Badge
                HStack {
                    Circle()
                        .fill(message.tone.color)
                        .frame(width: 12, height: 12)

                    Text(message.tone.rawValue)
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(isSelected ? .white : message.tone.color)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundStyle(.white)
                    }
                }

                // Message Text
                Text(message.message)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()
            }
            .padding()
            .frame(minHeight: 100)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? message.tone.color.gradient : Color(.systemGray6).gradient)
            )
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func customMessageSection() -> some View {
        VStack(spacing: 16) {
            // Section Header
            HStack {
                Image(systemName: "pencil.and.outline")
                    .foregroundStyle(culturalColor)
                    .font(.title2)

                Text("Custom Message")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showingCustomInput.toggle()
                        if showingCustomInput {
                            selectedMessage = nil
                            isTextFieldFocused = true
                        } else {
                            personalMessage = ""
                        }
                    }
                } label: {
                    Text(showingCustomInput ? "Cancel" : "Write Your Own")
                        .font(.system(.caption, design: .rounded).weight(.medium))
                        .foregroundStyle(showingCustomInput ? .secondary : culturalColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(showingCustomInput ? Color(.systemGray5) : culturalColor.opacity(0.1))
                        )
                }
            }
            .padding(.horizontal, 20)

            // Custom Input Field
            if showingCustomInput {
                VStack(spacing: 12) {
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray6))
                            .frame(minHeight: 100)

                        TextEditor(text: $personalMessage)
                            .font(.system(.body, design: .rounded))
                            .padding(12)
                            .background(Color.clear)
                            .focused($isTextFieldFocused)
                            .onChange(of: personalMessage) { newValue in
                                let maxLength = AnniversaryPersonalTouch.maxPersonalMessageLength
                                if newValue.count > maxLength {
                                    personalMessage = String(newValue.prefix(maxLength))
                                }
                            }

                        if personalMessage.isEmpty {
                            Text(AnniversaryPersonalTouch.personalMessagePlaceholder)
                                .font(.system(.body, design: .rounded))
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 20)
                                .allowsHitTesting(false)
                        }
                    }

                    // Character Counter
                    HStack {
                        Spacer()
                        let maxLength = AnniversaryPersonalTouch.maxPersonalMessageLength
                        let warningThreshold = maxLength * 9 / 10
                        Text("\(personalMessage.count)/\(maxLength)")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(personalMessage.count > warningThreshold ? .red : .secondary)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    @ViewBuilder
    private func messagePreview() -> some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "eye.fill")
                    .foregroundStyle(culturalColor)
                Text("Message Preview")
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                Spacer()
            }

            // Preview Card
            VStack(spacing: 12) {
                if let selectedMessage = selectedMessage, personalMessage.isEmpty {
                    HStack {
                        Circle()
                            .fill(selectedMessage.tone.color)
                            .frame(width: 8, height: 8)
                        Text(selectedMessage.tone.rawValue.uppercased())
                            .font(.system(.caption2, design: .rounded).weight(.bold))
                            .foregroundStyle(selectedMessage.tone.color)
                        Spacer()
                    }

                    Text(selectedMessage.message)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                } else if !personalMessage.isEmpty {
                    HStack {
                        Circle()
                            .fill(culturalColor)
                            .frame(width: 8, height: 8)
                        Text("CUSTOM MESSAGE")
                            .font(.system(.caption2, design: .rounded).weight(.bold))
                            .foregroundStyle(culturalColor)
                        Spacer()
                    }

                    Text(personalMessage)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
            )
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(culturalColor.opacity(0.05))
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Computed Properties
    private var hasSelectedMessage: Bool {
        selectedMessage != nil || !personalMessage.isEmpty
    }
}

#Preview {
    AnniversaryPersonalTouchView(
        selectedMessage: .constant(AnniversaryPersonalTouch.optionalMessages[0]),
        personalMessage: .constant(""),
        culturalColor: Color(hex: "#DC143C")
    )
}
