import ClockKit
import SwiftUI
import WidgetKit

// MARK: - Rakhi Watch Face Complication Provider

@available(watchOS 7.0, *)
class RakhiComplicationProvider: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getComplicationDescriptors(handler: @escaping ([CLKComplicationDescriptor]) -> Void) {
        let descriptors = [
            CLKComplicationDescriptor(
                identifier: "rakhi_current",
                displayName: "Current Rakhi",
                supportedFamilies: CLKComplicationFamily.allCases
            ),
            CLKComplicationDescriptor(
                identifier: "rakhi_score",
                displayName: "Cultural Score",
                supportedFamilies: [.modularSmall, .circularSmall, .utilitarianSmall, .graphicCorner, .graphicCircular]
            ),
            CLKComplicationDescriptor(
                identifier: "rakhi_count",
                displayName: "Rakhi Count",
                supportedFamilies: [.modularSmall, .circularSmall, .utilitarianSmall]
            )
        ]
        
        handler(descriptors)
    }
    
    func handleSharedComplicationDescriptors(_ complicationDescriptors: [CLKComplicationDescriptor]) {
        // Handle shared complications if needed
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(
        for complication: CLKComplication,
        withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void
    ) {
        let entry = createTimelineEntry(for: complication, date: Date())
        handler(entry)
    }
    
    func getTimelineEntries(
        for complication: CLKComplication,
        after date: Date,
        limit: Int,
        withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void
    ) {
        var entries: [CLKComplicationTimelineEntry] = []
        
        // Create entries for the next few hours
        for hour in 1...min(limit, 24) {
            if let entryDate = Calendar.current.date(byAdding: .hour, value: hour, to: date) {
                if let entry = createTimelineEntry(for: complication, date: entryDate) {
                    entries.append(entry)
                }
            }
        }
        
        handler(entries)
    }
    
    func getTimelineEndDate(
        for complication: CLKComplication,
        withHandler handler: @escaping (Date?) -> Void
    ) {
        // Provide timeline for next 24 hours
        let endDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        handler(endDate)
    }
    
    // MARK: - Privacy Behavior
    
    func getPrivacyBehavior(
        for complication: CLKComplication,
        withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void
    ) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Entry Creation
    
    private func createTimelineEntry(
        for complication: CLKComplication,
        date: Date
    ) -> CLKComplicationTimelineEntry? {
        
        guard let complicationData = getCurrentComplicationData() else { return nil }
        
        let template = createTemplate(
            for: complication.family,
            identifier: complication.identifier,
            data: complicationData
        )
        
        guard let template = template else { return nil }
        
        return CLKComplicationTimelineEntry(date: date, complicationTemplate: template)
    }
    
    private func getCurrentComplicationData() -> WatchComplicationData? {
        return EnhancedRakhiWatchDisplayService.shared.getComplicationData()
    }
    
    // MARK: - Template Creation
    
    private func createTemplate(
        for family: CLKComplicationFamily,
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        switch family {
        case .modularSmall:
            return createModularSmallTemplate(identifier: identifier, data: data)
        case .modularLarge:
            return createModularLargeTemplate(identifier: identifier, data: data)
        case .circularSmall:
            return createCircularSmallTemplate(identifier: identifier, data: data)
        case .utilitarianSmall:
            return createUtilitarianSmallTemplate(identifier: identifier, data: data)
        case .utilitarianLarge:
            return createUtilitarianLargeTemplate(identifier: identifier, data: data)
        case .graphicCorner:
            return createGraphicCornerTemplate(identifier: identifier, data: data)
        case .graphicCircular:
            return createGraphicCircularTemplate(identifier: identifier, data: data)
        case .graphicRectangular:
            return createGraphicRectangularTemplate(identifier: identifier, data: data)
        case .graphicBezel:
            return createGraphicBezelTemplate(identifier: identifier, data: data)
        @unknown default:
            return nil
        }
    }
    
    // MARK: - Modular Templates
    
    private func createModularSmallTemplate(
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        switch identifier {
        case "rakhi_score":
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "⭐")
            template.line2TextProvider = CLKSimpleTextProvider(
                text: String(format: "%.1f", data.culturalScore)
            )
            return template
            
        case "rakhi_count":
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "🎊")
            template.line2TextProvider = CLKSimpleTextProvider(
                text: "\(EnhancedRakhiWatchDisplayService.shared.displayedRakhis.count)"
            )
            return template
            
        default:
            let template = CLKComplicationTemplateModularSmallStackImage()
            template.line1ImageProvider = CLKImageProvider(onePieceImage: createRakhiIcon())
            template.line2TextProvider = CLKSimpleTextProvider(text: "Rakhi")
            return template
        }
    }
    
    private func createModularLargeTemplate(
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        let template = CLKComplicationTemplateModularLargeStandardBody()
        
        // Header
        template.headerTextProvider = CLKSimpleTextProvider(text: "🎊 Forava")
        
        // Body
        let rakhiTitle = data.title.components(separatedBy: " • ").first ?? "Rakhi"
        template.body1TextProvider = CLKSimpleTextProvider(text: rakhiTitle)
        
        // Cultural score
        template.body2TextProvider = CLKSimpleTextProvider(
            text: "Cultural Score: \(String(format: "%.1f", data.culturalScore))"
        )
        
        return template
    }
    
    // MARK: - Circular Templates
    
    private func createCircularSmallTemplate(
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        switch identifier {
        case "rakhi_score":
            let template = CLKComplicationTemplateCircularSmallStackText()
            template.line1TextProvider = CLKSimpleTextProvider(text: "⭐")
            template.line2TextProvider = CLKSimpleTextProvider(
                text: String(format: "%.1f", data.culturalScore)
            )
            return template
            
        default:
            let template = CLKComplicationTemplateCircularSmallStackImage()
            template.line1ImageProvider = CLKImageProvider(onePieceImage: createRakhiIcon())
            template.line2TextProvider = CLKSimpleTextProvider(text: "🎊")
            return template
        }
    }
    
    // MARK: - Utilitarian Templates
    
    private func createUtilitarianSmallTemplate(
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        let template = CLKComplicationTemplateUtilitarianSmallFlat()
        
        switch identifier {
        case "rakhi_score":
            template.textProvider = CLKSimpleTextProvider(
                text: "⭐\(String(format: "%.1f", data.culturalScore))"
            )
            
        case "rakhi_count":
            template.textProvider = CLKSimpleTextProvider(
                text: "🎊\(EnhancedRakhiWatchDisplayService.shared.displayedRakhis.count)"
            )
            
        default:
            template.textProvider = CLKSimpleTextProvider(text: "🎊 Rakhi")
        }
        
        return template
    }
    
    private func createUtilitarianLargeTemplate(
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        let template = CLKComplicationTemplateUtilitarianLargeFlat()
        
        let rakhiTitle = data.title.components(separatedBy: " • ").first ?? "Rakhi"
        template.textProvider = CLKSimpleTextProvider(
            text: "🎊 \(rakhiTitle) ⭐\(String(format: "%.1f", data.culturalScore))"
        )
        
        return template
    }
    
    // MARK: - Graphic Templates (watchOS 5+)
    
    @available(watchOS 5.0, *)
    private func createGraphicCornerTemplate(
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        let template = CLKComplicationTemplateGraphicCornerStackText()
        
        template.outerTextProvider = CLKSimpleTextProvider(text: "🎊")
        template.innerTextProvider = CLKSimpleTextProvider(
            text: String(format: "%.1f", data.culturalScore)
        )
        
        return template
    }
    
    @available(watchOS 5.0, *)
    private func createGraphicCircularTemplate(
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        let template = CLKComplicationTemplateGraphicCircularStackText()
        
        template.line1TextProvider = CLKSimpleTextProvider(text: "🎊")
        template.line2TextProvider = CLKSimpleTextProvider(
            text: String(format: "%.1f", data.culturalScore)
        )
        
        return template
    }
    
    @available(watchOS 5.0, *)
    private func createGraphicRectangularTemplate(
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        let template = CLKComplicationTemplateGraphicRectangularStandardBody()
        
        // Header
        template.headerTextProvider = CLKSimpleTextProvider(text: "Forava Rakhi")
        
        // Body
        let rakhiTitle = data.title.components(separatedBy: " • ").first ?? "Rakhi"
        template.body1TextProvider = CLKSimpleTextProvider(text: rakhiTitle)
        
        // Cultural score with time
        let timeText = DateFormatter.localizedString(from: data.createdDate, dateStyle: .none, timeStyle: .short)
        template.body2TextProvider = CLKSimpleTextProvider(
            text: "⭐\(String(format: "%.1f", data.culturalScore)) • \(timeText)"
        )
        
        return template
    }
    
    @available(watchOS 5.0, *)
    private func createGraphicBezelTemplate(
        identifier: String?,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate? {
        
        let circularTemplate = CLKComplicationTemplateGraphicCircularStackText()
        circularTemplate.line1TextProvider = CLKSimpleTextProvider(text: "🎊")
        circularTemplate.line2TextProvider = CLKSimpleTextProvider(
            text: String(format: "%.1f", data.culturalScore)
        )
        
        let template = CLKComplicationTemplateGraphicBezelCircularText()
        template.circularTemplate = circularTemplate
        
        let rakhiTitle = data.title.components(separatedBy: " • ").first ?? "Rakhi"
        template.textProvider = CLKSimpleTextProvider(text: rakhiTitle)
        
        return template
    }
    
    // MARK: - Helper Methods
    
    private func createRakhiIcon() -> UIImage {
        // Create a simple rakhi icon for complications
        let size = CGSize(width: 32, height: 32)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: size)
            
            // Background circle
            context.cgContext.setFillColor(UIColor.systemOrange.cgColor)
            context.cgContext.fillEllipse(in: rect)
            
            // Inner design
            context.cgContext.setFillColor(UIColor.white.cgColor)
            let innerRect = rect.insetBy(dx: 8, dy: 8)
            context.cgContext.fillEllipse(in: innerRect)
            
            // Center dot
            context.cgContext.setFillColor(UIColor.systemOrange.cgColor)
            let centerRect = rect.insetBy(dx: 12, dy: 12)
            context.cgContext.fillEllipse(in: centerRect)
        }
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(
        for complication: CLKComplication,
        withHandler handler: @escaping (CLKComplicationTemplate?) -> Void
    ) {
        let sampleData = WatchComplicationData(
            rakhiId: UUID(),
            title: "Traditional • Sacred",
            culturalScore: 8.5,
            primaryColor: .orange,
            createdDate: Date()
        )
        
        let template = createTemplate(
            for: complication.family,
            identifier: complication.identifier,
            data: sampleData
        )
        
        handler(template)
    }
}

// MARK: - Complication Update Service

@MainActor
class RakhiComplicationUpdateService: ObservableObject {
    static let shared = RakhiComplicationUpdateService()
    
    private var lastUpdateTime: Date?
    private let minimumUpdateInterval: TimeInterval = 300 // 5 minutes
    
    private init() {
        setupComplicationUpdates()
    }
    
    private func setupComplicationUpdates() {
        // Monitor for rakhi changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRakhiUpdate),
            name: .rakhiUpdated,
            object: nil
        )
        
        // Monitor for display service changes
        EnhancedRakhiWatchDisplayService.shared.$currentRakhi
            .sink { [weak self] _ in
                self?.requestComplicationUpdate()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    @objc private func handleRakhiUpdate() {
        requestComplicationUpdate()
    }
    
    func requestComplicationUpdate() {
        // Throttle updates to prevent excessive requests
        if let lastUpdate = lastUpdateTime,
           Date().timeIntervalSince(lastUpdate) < minimumUpdateInterval {
            return
        }
        
        lastUpdateTime = Date()
        
        // Request complication update
        if #available(watchOS 7.0, *) {
            let server = CLKComplicationServer.sharedInstance()
            
            for complication in server.activeComplications ?? [] {
                server.reloadTimeline(for: complication)
            }
        }
    }
    
    func forceComplicationUpdate() {
        lastUpdateTime = Date()
        
        if #available(watchOS 7.0, *) {
            let server = CLKComplicationServer.sharedInstance()
            
            for complication in server.activeComplications ?? [] {
                server.reloadTimeline(for: complication)
            }
        }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    static let rakhiUpdated = Notification.Name("rakhiUpdated")
    static let complicationDataChanged = Notification.Name("complicationDataChanged")
}

// MARK: - Complication Intent Configuration

@available(watchOS 9.0, *)
struct RakhiComplicationIntentConfiguration {
    
    static func configureDynamicComplications() {
        // Configure dynamic complications that can be updated based on user activity
        
        let intentProvider = RakhiComplicationIntentProvider()
        
        // Register for timeline updates
        WidgetCenter.shared.reloadAllTimelines()
    }
}

@available(watchOS 9.0, *)
class RakhiComplicationIntentProvider: NSObject {
    
    func getCurrentRakhiIntent() -> RakhiDisplayIntent {
        let intent = RakhiDisplayIntent()
        
        if let currentRakhi = EnhancedRakhiWatchDisplayService.shared.currentRakhi {
            intent.rakhiTitle = currentRakhi.title
            intent.culturalScore = NSNumber(value: currentRakhi.culturalScore)
        }
        
        return intent
    }
}

// MARK: - Intent Definition (placeholder)

@available(watchOS 9.0, *)
class RakhiDisplayIntent: NSObject {
    var rakhiTitle: String?
    var culturalScore: NSNumber?
}

// MARK: - Complication Privacy Handling

extension RakhiComplicationProvider {
    
    func getPrivacyBehavior(
        for complication: CLKComplication,
        withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void
    ) {
        // Show on lock screen for quick access
        handler(.showOnLockScreen)
    }
    
    private func shouldShowSensitiveData() -> Bool {
        // Check if device is unlocked or user has allowed sensitive data on lock screen
        return true // For now, Rakhi data is not considered sensitive
    }
}

// MARK: - Accessibility Support

extension RakhiComplicationProvider {
    
    private func createAccessibleTemplate(
        _ template: CLKComplicationTemplate,
        data: WatchComplicationData
    ) -> CLKComplicationTemplate {
        
        // Add accessibility labels for VoiceOver support
        if let stackTemplate = template as? CLKComplicationTemplateModularSmallStackText {
            stackTemplate.line1TextProvider?.accessibilityLabel = "Cultural significance star"
            stackTemplate.line2TextProvider?.accessibilityLabel = "Score \(String(format: "%.1f", data.culturalScore))"
        }
        
        return template
    }
}