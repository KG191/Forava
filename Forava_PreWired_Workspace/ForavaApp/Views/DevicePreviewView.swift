import SwiftUI

// MARK: - Device Preview View
struct DevicePreviewView: View {
    let imageSet: DeviceOptimizedImageSet
    @State private var selectedDevice: DeviceType = .watchFace
    @State private var showingFullscreen = false

    var body: some View {
        VStack(spacing: 20) {
            // Device selector
            deviceSelector

            // Main preview
            devicePreviewCard

            // Device specifications
            deviceSpecsCard
        }
        .fullScreenCover(isPresented: $showingFullscreen) {
            FullscreenDevicePreview(
                imageSet: imageSet,
                selectedDevice: $selectedDevice,
                isPresented: $showingFullscreen
            )
        }
    }

    // MARK: - Device Selector

    private var deviceSelector: some View {
        HStack(spacing: 12) {
            ForEach(DeviceType.allCases, id: \.self) { deviceType in
                DeviceTabButton(
                    deviceType: deviceType,
                    isSelected: selectedDevice == deviceType
                ) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedDevice = deviceType
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Device Preview Card

    private var devicePreviewCard: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Image(systemName: selectedDevice.icon)
                    .font(.system(.title2, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Text(selectedDevice.displayName)
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .foregroundStyle(.primary)

                Spacer()

                Button(action: { showingFullscreen = true }) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            // Device preview
            deviceImagePreview
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
    }

    private var deviceImagePreview: some View {
        let deviceImage = getImageForDevice(selectedDevice)
        let deviceSpec = getSpecForDevice(selectedDevice)

        return GeometryReader { geometry in
            let maxWidth = geometry.size.width
            let maxHeight = geometry.size.height - 40 // Account for padding

            let imageAspectRatio = deviceSpec.aspectRatio
            let containerAspectRatio = maxWidth / maxHeight

            let displayWidth: CGFloat
            let displayHeight: CGFloat

            if imageAspectRatio > containerAspectRatio {
                // Image is wider relative to container
                displayWidth = maxWidth
                displayHeight = maxWidth / imageAspectRatio
            } else {
                // Image is taller relative to container
                displayHeight = maxHeight
                displayWidth = maxHeight * imageAspectRatio
            }

            VStack {
                Image(uiImage: deviceImage.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: displayWidth, height: displayHeight)
                    .clipShape(RoundedRectangle(cornerRadius: deviceSpec.cornerRadius))
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(minHeight: 300)
    }

    // MARK: - Device Specifications

    private var deviceSpecsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Specifications")
                .font(.system(.headline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)

            let spec = getSpecForDevice(selectedDevice)
            let image = getImageForDevice(selectedDevice)

            VStack(spacing: 8) {
                SpecRow(label: "Dimensions", value: "\(spec.width) × \(spec.height) pixels")
                SpecRow(label: "Aspect Ratio", value: String(format: "%.3f:1", spec.aspectRatio))
                SpecRow(label: "Corner Radius", value: spec.cornerRadius > 0 ? "\(Int(spec.cornerRadius))pt" : "None")
                SpecRow(label: "Optimizations", value: image.optimizations.count > 0 ? "\(image.optimizations.count) applied" : "Standard")
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Helper Methods

    private func getImageForDevice(_ deviceType: DeviceType) -> DeviceSpecificImage {
        switch deviceType {
        case .watchFace: return imageSet.watchFace
        case .phoneWallpaper: return imageSet.phoneWallpaper
        case .phoneLockscreen: return imageSet.phoneLockscreen
        }
    }

    private func getSpecForDevice(_ deviceType: DeviceType) -> DeviceOptimizedImageService.DeviceImageSpec {
        switch deviceType {
        case .watchFace: return .watchFace
        case .phoneWallpaper: return .phoneWallpaper
        case .phoneLockscreen: return .phoneLockscreen
        }
    }
}

// MARK: - Device Tab Button
struct DeviceTabButton: View {
    let deviceType: DeviceType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: deviceType.icon)
                    .font(.system(.body, design: .rounded).weight(.medium))
                    .foregroundStyle(isSelected ? .white : .primary)

                Text(deviceType.displayName)
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(isSelected ? .white : .primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                isSelected ? .accentColor : Color.clear,
                in: RoundedRectangle(cornerRadius: 12)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? .clear : .secondary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Spec Row
struct SpecRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(.caption, design: .rounded).weight(.medium))
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Fullscreen Device Preview
struct FullscreenDevicePreview: View {
    let imageSet: DeviceOptimizedImageSet
    @Binding var selectedDevice: DeviceType
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()

                TabView(selection: $selectedDevice) {
                    ForEach(DeviceType.allCases, id: \.self) { deviceType in
                        FullscreenDeviceImage(
                            deviceImage: getImageForDevice(deviceType),
                            deviceType: deviceType
                        )
                        .tag(deviceType)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
            }
            .navigationTitle("Device Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { isPresented = false }
                        .foregroundStyle(.white)
                }
            }
        }
    }

    private func getImageForDevice(_ deviceType: DeviceType) -> DeviceSpecificImage {
        switch deviceType {
        case .watchFace: return imageSet.watchFace
        case .phoneWallpaper: return imageSet.phoneWallpaper
        case .phoneLockscreen: return imageSet.phoneLockscreen
        }
    }
}

// MARK: - Fullscreen Device Image
struct FullscreenDeviceImage: View {
    let deviceImage: DeviceSpecificImage
    let deviceType: DeviceType

    var body: some View {
        VStack {
            Spacer()

            Image(uiImage: deviceImage.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: deviceImage.spec.cornerRadius))
                .shadow(color: .black.opacity(0.3), radius: 12, x: 0, y: 6)

            Spacer()

            VStack(spacing: 8) {
                Text(deviceType.displayName)
                    .font(.system(.title2, design: .rounded).weight(.semibold))
                    .foregroundStyle(.white)

                Text("\(deviceImage.spec.width) × \(deviceImage.spec.height)")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 40)
        }
        .padding(20)
    }
}

// MARK: - Preview
#if DEBUG
struct DevicePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        // Mock data for preview
        let mockImageSet = DeviceOptimizedImageSet(
            baseArtwork: CulturalGeneratedArtwork(
                id: UUID(),
                designSpec: CulturalDesignSpec(
                    culturalContext: "hindu_festivals",
                    genre: CulturalGenre(id: "diwali", displayName: "Diwali", icon: "flame.fill", basePrompt: "test", culturalContext: "hindu_festivals"),
                    colorPalette: CulturalColorPalette(id: "test", displayName: "Test", colors: [], culturalContext: "hindu_festivals"),
                    targetAgeGroup: CulturalAgeGroup(id: "any", displayName: "Any", ageRange: "All", culturalContext: "hindu_festivals")
                ),
                culturalContext: "hindu_festivals",
                mainImage: CulturalImageResult(url: "test", width: 512, height: 512, seed: 123, qualityScore: 0.9),
                qualityScore: 0.9,
                culturalScore: 0.85,
                generatedAt: Date(),
                metadata: CulturalGenerationMetadata(culturalContext: "hindu_festivals", model: "test", prompt: "test", negativePrompt: "test", culturalEnhancers: [], steps: 30, cfgScale: 7.5, seed: 123)
            ),
            watchFace: DeviceSpecificImage(
                image: UIImage(systemName: "heart.fill") ?? UIImage(),
                deviceType: .watchFace,
                spec: .watchFace,
                culturalContext: "hindu_festivals",
                optimizations: ["centered", "high_contrast"]
            ),
            phoneWallpaper: DeviceSpecificImage(
                image: UIImage(systemName: "heart.fill") ?? UIImage(),
                deviceType: .phoneWallpaper,
                spec: .phoneWallpaper,
                culturalContext: "hindu_festivals",
                optimizations: ["vertical", "gradient"]
            ),
            phoneLockscreen: DeviceSpecificImage(
                image: UIImage(systemName: "heart.fill") ?? UIImage(),
                deviceType: .phoneLockscreen,
                spec: .phoneLockscreen,
                culturalContext: "hindu_festivals",
                optimizations: ["lockscreen_safe"]
            ),
            generatedAt: Date()
        )

        DevicePreviewView(imageSet: mockImageSet)
    }
}
#endif
