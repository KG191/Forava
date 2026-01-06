import SwiftUI

// MARK: - Cached Async Image Component for Cultural Designs

/// High-performance image loader with caching for AI-generated cultural artwork
/// Supports loading from URLs with automatic caching and error handling
struct CachedAsyncImage: View {
    let url: String
    let contentMode: ContentMode
    let aspectRatio: CGFloat?

    @StateObject private var loader = ImageLoader()

    init(
        url: String,
        contentMode: ContentMode = .fit,
        aspectRatio: CGFloat? = nil
    ) {
        self.url = url
        self.contentMode = contentMode
        self.aspectRatio = aspectRatio
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
                    .if(aspectRatio != nil) { view in
                        view.aspectRatio(aspectRatio, contentMode: .fit)
                    }
            } else if loader.isLoading {
                loadingView
            } else if loader.error != nil {
                errorView
            } else {
                placeholderView
            }
        }
        .onAppear {
            loader.load(from: url)
        }
    }

    @ViewBuilder
    private var loadingView: some View {
        ZStack {
            Color(.systemGray6)

            VStack(spacing: 12) {
                ProgressView()
                    .scaleEffect(1.2)

                Text("Loading image...")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)

                if let progress = loader.downloadProgress, progress > 0 {
                    Text("\(Int(progress * 100))%")
                        .font(.system(.caption2, design: .rounded).weight(.medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .if(aspectRatio != nil) { view in
            view.aspectRatio(aspectRatio, contentMode: .fit)
        }
    }

    @ViewBuilder
    private var errorView: some View {
        ZStack {
            Color(.systemGray6)

            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(.title))
                    .foregroundStyle(.orange)

                Text("Failed to load image")
                    .font(.system(.caption, design: .rounded).weight(.medium))
                    .foregroundStyle(.secondary)

                if let errorMessage = loader.error {
                    Text(errorMessage)
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                Button("Retry") {
                    loader.load(from: url)
                }
                .font(.system(.caption, design: .rounded).weight(.semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.blue)
                .foregroundStyle(.white)
                .cornerRadius(8)
            }
        }
        .if(aspectRatio != nil) { view in
            view.aspectRatio(aspectRatio, contentMode: .fit)
        }
    }

    @ViewBuilder
    private var placeholderView: some View {
        ZStack {
            Color(.systemGray6)

            Image(systemName: "photo")
                .font(.system(.largeTitle))
                .foregroundStyle(.secondary)
        }
        .if(aspectRatio != nil) { view in
            view.aspectRatio(aspectRatio, contentMode: .fit)
        }
    }
}

// MARK: - Image Loader with Caching

@MainActor
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var error: String?
    @Published var downloadProgress: Double?

    private static let cache = NSCache<NSString, UIImage>()
    private var currentTask: URLSessionDataTask?

    func load(from urlString: String) {
        // Reset state
        error = nil
        downloadProgress = nil

        // Check cache first
        let cacheKey = NSString(string: urlString)
        if let cachedImage = Self.cache.object(forKey: cacheKey) {
            print("✅ Image loaded from cache: \(urlString)")
            self.image = cachedImage
            return
        }

        // Validate URL
        guard let url = URL(string: urlString) else {
            print("❌ Invalid image URL: \(urlString)")
            error = "Invalid image URL"
            return
        }

        // Start loading
        isLoading = true
        print("📥 Downloading image from: \(urlString)")

        // Cancel any existing task
        currentTask?.cancel()

        // Capture cache key as String for Sendable compliance
        let cacheKeyString = urlString

        // Create download task with progress tracking
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, taskError in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.isLoading = false

                if let error = taskError {
                    if (error as NSError).code != NSURLErrorCancelled {
                        print("❌ Image download error: \(error.localizedDescription)")
                        self.error = error.localizedDescription
                    }
                    return
                }

                guard let data = data, let downloadedImage = UIImage(data: data) else {
                    print("❌ Failed to decode image data")
                    self.error = "Failed to decode image"
                    return
                }

                // Cache the image using String converted to NSString
                Self.cache.setObject(downloadedImage, forKey: NSString(string: cacheKeyString))

                print("✅ Image downloaded and cached successfully")
                self.image = downloadedImage
            }
        }

        currentTask = task
        task.resume()
    }

    func cancel() {
        currentTask?.cancel()
        isLoading = false
    }
}

// MARK: - View Extension for Conditional Modifiers

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
