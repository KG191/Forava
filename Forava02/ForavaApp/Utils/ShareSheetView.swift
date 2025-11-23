//
//  ShareSheetView.swift
//  Forava
//
//  Helper view that downloads image and presents ShareSheet
//

import SwiftUI

/// Helper view that downloads the generated image and presents the iOS share sheet
struct ShareSheetView: View {
    let generatedImages: [String: String]
    let personalMessage: String

    @State private var isLoading = true
    @State private var downloadedImage: UIImage?
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            if isLoading {
                VStack(spacing: 20) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Preparing image...")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = errorMessage {
                VStack(spacing: 20) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.system(size: 60))
                        .foregroundStyle(.red)

                    Text("Failed to Load Image")
                        .font(.system(.title3, design: .rounded).weight(.bold))

                    Text(error)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)

                    Button("Close") {
                        dismiss()
                    }
                    .font(.system(.headline, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 12)
                    .background(Color.red)
                    .cornerRadius(12)
                }
                .padding()
            } else if let image = downloadedImage {
                ShareSheet(activityItems: [image, personalMessage])
            }
        }
        .onAppear {
            downloadImage()
        }
    }

    private func downloadImage() {
        // Get the iPhone image URL (preferably) or first available
        guard let imageURLString = generatedImages["iPhone"] ?? generatedImages.values.first else {
            errorMessage = "No image available to share"
            isLoading = false
            return
        }

        guard let url = URL(string: imageURLString) else {
            errorMessage = "Invalid image URL"
            isLoading = false
            return
        }

        // Download image
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    await MainActor.run {
                        errorMessage = "Failed to decode image"
                        isLoading = false
                    }
                    return
                }

                await MainActor.run {
                    downloadedImage = image
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Failed to download image: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }
    }
}
