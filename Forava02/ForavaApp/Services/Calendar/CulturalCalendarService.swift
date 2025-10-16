import Foundation
import EventKit
import SwiftUI
import Combine

// Service protocols are defined in SharedCulturalTypes.swift

// MARK: - Cultural Calendar Service with EventKit Integration
@MainActor
class CulturalCalendarService: ObservableObject {
    static let shared = CulturalCalendarService()

    @Published var upcomingCulturalEvents: [CulturalCalendarEvent] = []
    @Published var userCulturalCalendar: [CulturalCalendarEvent] = []
    @Published var isLoadingEvents = false
    @Published var calendarPermissionStatus: CalendarPermissionStatus = .notDetermined

    private let eventStore = EKEventStore()
    private var culturalEventDatabase: CulturalEventDatabase
    // PersonalizationService dependency - conditionally loaded to prevent build failures
    private lazy var personalizationService: PersonalizationServiceProtocol? = {
        // TODO: Replace with proper PersonalizationService.shared when project configuration is fixed
        // For now, return nil to prevent compilation errors
        return nil
    }()
    private var cancellables = Set<AnyCancellable>()

    private init() {
        self.culturalEventDatabase = CulturalEventDatabase()
        loadCulturalEventDatabase()
        Task {
            await requestCalendarPermissions()
        }
        setupPersonalizationObserver()
    }

    // MARK: - Calendar Permissions

    func requestCalendarPermissions() async {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            calendarPermissionStatus = .notDetermined
            do {
                let granted = try await eventStore.requestFullAccessToEvents()
                calendarPermissionStatus = granted ? .authorized : .denied
            } catch {
                print("Failed to request calendar permissions: \(error)")
                calendarPermissionStatus = .denied
            }

        case .denied:
            calendarPermissionStatus = .denied

        case .restricted:
            calendarPermissionStatus = .restricted

        case .authorized:
            calendarPermissionStatus = .authorized

        case .fullAccess:
            calendarPermissionStatus = .authorized

        case .writeOnly:
            calendarPermissionStatus = .authorized

        @unknown default:
            calendarPermissionStatus = .notDetermined
        }

        if calendarPermissionStatus == .authorized {
            await loadUpcomingCulturalEvents()
        }
    }

    // MARK: - Cultural Event Loading and Management

    func loadUpcomingCulturalEvents() async {
        isLoadingEvents = true

        defer {
            isLoadingEvents = false
        }

        // Get current date and look ahead 12 months
        let now = Date()
        let calendar = Calendar.current
        let endDate = calendar.date(byAdding: .year, value: 1, to: now) ?? now

        var allCulturalEvents: [CulturalCalendarEvent] = []

        // Load events based on user's cultural preferences
        let userProfile = personalizationService?.userCulturalProfile
        let relevantContexts = getUserRelevantCulturalContexts(userProfile)

        for culturalContext in relevantContexts {
            let contextEvents = await loadEventsForCulturalContext(
                context: culturalContext,
                from: now,
                to: endDate
            )
            allCulturalEvents.append(contentsOf: contextEvents)
        }

        // Add global cultural events that might be of interest
        let globalEvents = await loadGlobalCulturalEvents(from: now, to: endDate)
        allCulturalEvents.append(contentsOf: globalEvents)

        // Sort events by date
        upcomingCulturalEvents = allCulturalEvents.sorted { $0.date < $1.date }

        // Update user's personal cultural calendar
        await updateUserCulturalCalendar()
    }

    private func loadEventsForCulturalContext(
        context: CulturalContext,
        from startDate: Date,
        to endDate: Date
    ) async -> [CulturalCalendarEvent] {

        let eventDefinitions = culturalEventDatabase.getEvents(for: context)
        var calculatedEvents: [CulturalCalendarEvent] = []

        for definition in eventDefinitions {
            let occurrences = calculateEventOccurrences(
                definition: definition,
                from: startDate,
                to: endDate
            )

            for occurrence in occurrences {
                let culturalEvent = CulturalCalendarEvent(
                    id: UUID(),
                    name: definition.name,
                    culturalContext: context,
                    date: occurrence.date,
                    duration: definition.duration,
                    description: definition.description,
                    significance: definition.significance,
                    preparationDays: definition.preparationDays,
                    giftingOpportunity: definition.giftingOpportunity,
                    customizations: occurrence.customizations,
                    source: .culturalDatabase,
                    userRelevance: calculateUserRelevance(context: context, event: definition)
                )
                calculatedEvents.append(culturalEvent)
            }
        }

        return calculatedEvents
    }

    private func loadGlobalCulturalEvents(from startDate: Date, to endDate: Date) async -> [CulturalCalendarEvent] {
        // Load events that might be interesting regardless of user preferences
        var globalEvents: [CulturalCalendarEvent] = []

        // International cultural events
        let internationalEvents = [
            ("International Day of Families", CulturalContext.anniversary, DateComponents(month: 5, day: 15)),
            ("World Cultural Diversity Day", CulturalContext.anniversary, DateComponents(month: 5, day: 21)),
            ("International Friendship Day", CulturalContext.birthday, DateComponents(month: 7, day: 30))
        ]

        let calendar = Calendar.current

        for (name, context, dateComponents) in internationalEvents {
            if let eventDate = calendar.nextDate(
                after: startDate.addingTimeInterval(-86400), // Start from yesterday
                matching: dateComponents,
                matchingPolicy: .nextTime
            ), eventDate <= endDate {

                globalEvents.append(CulturalCalendarEvent(
                    id: UUID(),
                    name: name,
                    culturalContext: context,
                    date: eventDate,
                    duration: 1,
                    description: "A global celebration of cultural diversity and connection",
                    significance: .moderate,
                    preparationDays: 3,
                    giftingOpportunity: .moderate,
                    customizations: [:],
                    source: .globalCultural,
                    userRelevance: 0.6
                ))
            }
        }

        return globalEvents
    }

    // MARK: - Event Calculation for Lunar and Complex Calendars

    private func calculateEventOccurrences(
        definition: CulturalEventDefinition,
        from startDate: Date,
        to endDate: Date
    ) -> [EventOccurrence] {

        var occurrences: [EventOccurrence] = []

        switch definition.calculationType {
        case .fixed(let dateComponents):
            occurrences = calculateFixedEventOccurrences(
                dateComponents: dateComponents,
                from: startDate,
                to: endDate
            )

        case .lunar(let lunarOffset):
            occurrences = calculateLunarEventOccurrences(
                lunarOffset: lunarOffset,
                from: startDate,
                to: endDate
            )

        case .relative(let relativeTo, let offset):
            occurrences = calculateRelativeEventOccurrences(
                relativeTo: relativeTo,
                offset: offset,
                from: startDate,
                to: endDate
            )

        case .complex(let algorithm):
            occurrences = calculateComplexEventOccurrences(
                algorithm: algorithm,
                from: startDate,
                to: endDate
            )
        }

        // Apply cultural customizations
        return occurrences.map { occurrence in
            var customizedOccurrence = occurrence
            customizedOccurrence.customizations = applyCustomizations(
                for: definition,
                occurrence: occurrence
            )
            return customizedOccurrence
        }
    }

    private func calculateFixedEventOccurrences(
        dateComponents: DateComponents,
        from startDate: Date,
        to endDate: Date
    ) -> [EventOccurrence] {

        var occurrences: [EventOccurrence] = []
        let calendar = Calendar.current

        var searchDate = startDate
        let endYear = calendar.component(.year, from: endDate)

        while calendar.component(.year, from: searchDate) <= endYear {
            var fullComponents = dateComponents
            fullComponents.year = calendar.component(.year, from: searchDate)

            if let eventDate = calendar.date(from: fullComponents),
               eventDate >= startDate && eventDate <= endDate {

                occurrences.append(EventOccurrence(
                    date: eventDate,
                    customizations: [:]
                ))
            }

            // Move to next year
            searchDate = calendar.date(byAdding: .year, value: 1, to: searchDate) ?? endDate
        }

        return occurrences
    }

    private func calculateLunarEventOccurrences(
        lunarOffset: Int,
        from startDate: Date,
        to endDate: Date
    ) -> [EventOccurrence] {

        var occurrences: [EventOccurrence] = []

        // Use astronomical calculations for lunar calendar events
        let lunarCalendar = createLunarCalendar()
        var searchDate = startDate

        while searchDate <= endDate {
            if let lunarDate = lunarCalendar.nextNewMoon(after: searchDate) {
                let eventDate = Calendar.current.date(byAdding: .day, value: lunarOffset, to: lunarDate) ?? lunarDate

                if eventDate <= endDate {
                    occurrences.append(EventOccurrence(
                        date: eventDate,
                        customizations: ["lunar_phase": getLunarPhase(for: eventDate)]
                    ))

                    searchDate = Calendar.current.date(byAdding: .month, value: 1, to: eventDate) ?? endDate
                } else {
                    break
                }
            } else {
                break
            }
        }

        return occurrences
    }

    private func calculateRelativeEventOccurrences(
        relativeTo baseEvent: String,
        offset: Int,
        from startDate: Date,
        to endDate: Date
    ) -> [EventOccurrence] {

        // Calculate events relative to other events (e.g., "40 days after Easter")
        let occurrences: [EventOccurrence] = []

        // This would implement relative calculations
        // For example, finding Easter and calculating events relative to it

        return occurrences
    }

    private func calculateComplexEventOccurrences(
        algorithm: String,
        from startDate: Date,
        to endDate: Date
    ) -> [EventOccurrence] {

        // Handle complex calculations like Chinese New Year, Islamic holidays, etc.
        var occurrences: [EventOccurrence] = []

        switch algorithm {
        case "chinese_new_year":
            occurrences = calculateChineseNewYear(from: startDate, to: endDate)
        case "eid_al_fitr":
            occurrences = calculateEidAlFitr(from: startDate, to: endDate)
        case "eid_al_adha":
            occurrences = calculateEidAlAdha(from: startDate, to: endDate)
        default:
            break
        }

        return occurrences
    }

    // MARK: - User Calendar Integration

    func addCulturalEventToUserCalendar(_ event: CulturalCalendarEvent) async -> Bool {
        guard calendarPermissionStatus == .authorized else { return false }

        let ekEvent = EKEvent(eventStore: eventStore)
        ekEvent.title = event.name
        ekEvent.startDate = event.date
        ekEvent.endDate = Calendar.current.date(
            byAdding: .day,
            value: event.duration,
            to: event.date
        ) ?? event.date
        ekEvent.notes = createEventNotes(for: event)
        ekEvent.calendar = eventStore.defaultCalendarForNewEvents

        // Add cultural metadata
        ekEvent.location = "Cultural Celebration"
        ekEvent.url = createEventURL(for: event)

        // Set reminders based on preparation days
        ekEvent.alarms = createCulturalReminders(for: event)

        do {
            try eventStore.save(ekEvent, span: .thisEvent)
            return true
        } catch {
            print("Failed to add cultural event to calendar: \(error)")
            return false
        }
    }

    func removeCulturalEventFromUserCalendar(_ event: CulturalCalendarEvent) async -> Bool {
        guard calendarPermissionStatus == .authorized else { return false }

        // Find and remove the event
        let predicate = eventStore.predicateForEvents(
            withStart: event.date,
            end: Calendar.current.date(byAdding: .day, value: 1, to: event.date) ?? event.date,
            calendars: nil
        )

        let events = eventStore.events(matching: predicate)

        for ekEvent in events where ekEvent.title == event.name {
            do {
                try eventStore.remove(ekEvent, span: .thisEvent)
                return true
            } catch {
                print("Failed to remove cultural event from calendar: \(error)")
                return false
            }
        }

        return false
    }

    // MARK: - Cultural Event Intelligence

    func getCulturalEventRecommendations(for date: Date) -> [CulturalEventRecommendation] {
        let targetDate = date
        let daysBefore = 14 // Look 2 weeks ahead
        let daysAfter = 7   // Look 1 week back

        let startDate = Calendar.current.date(byAdding: .day, value: -daysAfter, to: targetDate) ?? targetDate
        let endDate = Calendar.current.date(byAdding: .day, value: daysBefore, to: targetDate) ?? targetDate

        let nearbyEvents = upcomingCulturalEvents.filter { event in
            event.date >= startDate && event.date <= endDate
        }

        return nearbyEvents.map { event in
            CulturalEventRecommendation(
                event: event,
                recommendationType: determineRecommendationType(event: event, targetDate: targetDate),
                priority: calculateRecommendationPriority(event: event, targetDate: targetDate),
                giftingSuggestions: generateGiftingSuggestions(for: event)
            )
        }.sorted { $0.priority > $1.priority }
    }

    func getOptimalGiftingTime(for event: CulturalCalendarEvent) -> Date {
        let optimalDaysBefore = max(1, event.preparationDays / 2)
        return Calendar.current.date(
            byAdding: .day,
            value: -optimalDaysBefore,
            to: event.date
        ) ?? event.date
    }

    func getCulturalContext(for date: Date) -> CulturalEventContext {
        let nearbyEvents = upcomingCulturalEvents.filter { event in
            abs(event.date.timeIntervalSince(date)) < 7 * 24 * 3600 // Within a week
        }

        return CulturalEventContext(
            primaryEvent: nearbyEvents.first,
            relatedEvents: Array(nearbyEvents.dropFirst()),
            culturalSeason: determineCulturalSeason(for: date),
            recommendedActions: generateRecommendedActions(for: nearbyEvents, on: date)
        )
    }

    // MARK: - Helper Methods

    private func getUserRelevantCulturalContexts(_ userProfile: CulturalProfile?) -> [CulturalContext] {
        guard let profile = userProfile else {
            // Return default cultural contexts if no profile
            return [.rakshabandhan, .diwali, .christmas, .anniversary, .birthday]
        }

        var relevantContexts = profile.primaryCulturalContexts

        // Add contexts with high affinity
        for (context, affinity) in profile.culturalAffinities {
            if affinity > 0.5 && !relevantContexts.contains(context) {
                relevantContexts.append(context)
            }
        }

        // Ensure we have at least some contexts
        if relevantContexts.isEmpty {
            relevantContexts = Array(CulturalContext.allCases.prefix(5))
        }

        return relevantContexts
    }

    private func calculateUserRelevance(context: CulturalContext, event: CulturalEventDefinition) -> Double {
        let baseRelevance = Double(personalizationService?.getCulturalRecommendations(for: context).count ?? 1) * 0.1

        // Adjust based on event significance
        let significanceBonus = event.significance.rawValue * 0.1

        // Adjust based on gifting opportunity
        let giftingBonus = event.giftingOpportunity.rawValue * 0.1

        return min(1.0, baseRelevance + significanceBonus + giftingBonus)
    }

    private func applyCustomizations(
        for definition: CulturalEventDefinition,
        occurrence: EventOccurrence
    ) -> [String: String] {

        var customizations = occurrence.customizations

        // Add year-specific customizations
        let year = Calendar.current.component(.year, from: occurrence.date)
        customizations["year"] = String(year)

        // Add cultural-specific customizations
        switch definition.culturalContext {
        case .chineseNewYear:
            customizations["zodiac_animal"] = getChineseZodiacAnimal(for: year)
        case .diwali:
            customizations["lunar_phase"] = getLunarPhase(for: occurrence.date)
        default:
            break
        }

        return customizations
    }

    private func createEventNotes(for event: CulturalCalendarEvent) -> String {
        var notes = event.description

        notes += "\n\nCultural Significance: \(event.significance.description)"

        if event.giftingOpportunity.rawValue > 0.3 {
            notes += "\n\nGifting Opportunity: This is a perfect time for creating and sharing cultural gifts!"
        }

        if event.preparationDays > 0 {
            notes += "\n\nPreparation: Consider starting gift preparation \(event.preparationDays) days in advance."
        }

        notes += "\n\nCreated by Forava - Cultural Gift App"

        return notes
    }

    private func createEventURL(for event: CulturalCalendarEvent) -> URL? {
        var components = URLComponents()
        components.scheme = "forava"
        components.host = "cultural-event"
        components.path = "/details"
        components.queryItems = [
            URLQueryItem(name: "event_id", value: event.id.uuidString),
            URLQueryItem(name: "context", value: event.culturalContext.rawValue)
        ]
        return components.url
    }

    private func createCulturalReminders(for event: CulturalCalendarEvent) -> [EKAlarm] {
        var alarms: [EKAlarm] = []

        // Add preparation reminder
        if event.preparationDays > 0 {
            let preparationAlarm = EKAlarm(relativeOffset: TimeInterval(-event.preparationDays * 24 * 3600))
            alarms.append(preparationAlarm)
        }

        // Add day-before reminder
        let dayBeforeAlarm = EKAlarm(relativeOffset: TimeInterval(-24 * 3600))
        alarms.append(dayBeforeAlarm)

        // Add day-of reminder
        let dayOfAlarm = EKAlarm(relativeOffset: TimeInterval(-2 * 3600)) // 2 hours before
        alarms.append(dayOfAlarm)

        return alarms
    }

    private func updateUserCulturalCalendar() async {
        // Update user's personal cultural calendar with relevant events
        userCulturalCalendar = upcomingCulturalEvents.filter { event in
            event.userRelevance > 0.3 // Only include relevant events
        }
    }

    private func setupPersonalizationObserver() {
        // Observe changes in user preferences to update calendar
        // TODO: Restore when PersonalizationService is properly added to project
        /*
        personalizationService?.$userCulturalProfile
            .debounce(for: DispatchTimeInterval.seconds(2), scheduler: DispatchQueue.main)
            .sink { [weak self] (_: CulturalProfile?) in
                Task {
                    await self?.loadUpcomingCulturalEvents()
                }
            }
            .store(in: &cancellables)
        */
    }

    private func loadCulturalEventDatabase() {
        culturalEventDatabase.loadEvents()
    }

    // MARK: - Complex Calendar Calculations

    private func calculateChineseNewYear(from startDate: Date, to endDate: Date) -> [EventOccurrence] {
        // Simplified Chinese New Year calculation
        // In a real app, this would use proper astronomical calculations
        let knownChineseNewYears = [
            (2024, DateComponents(month: 2, day: 10)),
            (2025, DateComponents(month: 1, day: 29)),
            (2026, DateComponents(month: 2, day: 17))
        ]

        var occurrences: [EventOccurrence] = []

        for (year, dateComponents) in knownChineseNewYears {
            var fullComponents = dateComponents
            fullComponents.year = year

            if let eventDate = Calendar.current.date(from: fullComponents),
               eventDate >= startDate && eventDate <= endDate {

                occurrences.append(EventOccurrence(
                    date: eventDate,
                    customizations: ["zodiac_animal": getChineseZodiacAnimal(for: year)]
                ))
            }
        }

        return occurrences
    }

    private func calculateEidAlFitr(from startDate: Date, to endDate: Date) -> [EventOccurrence] {
        // Simplified Eid calculation - in practice, this would use Islamic calendar calculations
        // Using approximate dates
        let knownEidDates = [
            (2024, DateComponents(month: 4, day: 10)),
            (2025, DateComponents(month: 3, day: 30)),
            (2026, DateComponents(month: 3, day: 20))
        ]

        return calculateFromKnownDates(knownEidDates, from: startDate, to: endDate)
    }

    private func calculateEidAlAdha(from startDate: Date, to endDate: Date) -> [EventOccurrence] {
        let knownEidDates = [
            (2024, DateComponents(month: 6, day: 16)),
            (2025, DateComponents(month: 6, day: 6)),
            (2026, DateComponents(month: 5, day: 26))
        ]

        return calculateFromKnownDates(knownEidDates, from: startDate, to: endDate)
    }

    private func calculateFromKnownDates(
        _ knownDates: [(Int, DateComponents)],
        from startDate: Date,
        to endDate: Date
    ) -> [EventOccurrence] {

        var occurrences: [EventOccurrence] = []

        for (year, dateComponents) in knownDates {
            var fullComponents = dateComponents
            fullComponents.year = year

            if let eventDate = Calendar.current.date(from: fullComponents),
               eventDate >= startDate && eventDate <= endDate {

                occurrences.append(EventOccurrence(
                    date: eventDate,
                    customizations: [:]
                ))
            }
        }

        return occurrences
    }

    // MARK: - Astronomical and Cultural Calculations

    private func createLunarCalendar() -> LunarCalendar {
        return LunarCalendar()
    }

    private func getLunarPhase(for date: Date) -> String {
        // Simplified lunar phase calculation
        let lunarCalendar = createLunarCalendar()
        return lunarCalendar.getLunarPhase(for: date)
    }

    private func getChineseZodiacAnimal(for year: Int) -> String {
        let animals = [
            "Rat", "Ox", "Tiger", "Rabbit", "Dragon", "Snake",
            "Horse", "Goat", "Monkey", "Rooster", "Dog", "Pig"
        ]
        let index = (year - 1924) % 12 // 1924 was Year of the Rat
        return animals[index >= 0 ? index : index + 12]
    }

    private func determineRecommendationType(event: CulturalCalendarEvent, targetDate: Date) -> RecommendationType {
        let daysDifference = Calendar.current.dateComponents([.day], from: targetDate, to: event.date).day ?? 0

        if daysDifference < 0 {
            return .followUp
        } else if daysDifference <= 3 {
            return .imminent
        } else if daysDifference <= event.preparationDays {
            return .preparation
        } else {
            return .plannng
        }
    }

    private func calculateRecommendationPriority(event: CulturalCalendarEvent, targetDate: Date) -> Double {
        let basePriority = event.userRelevance
        let significanceBonus = event.significance.rawValue * 0.2
        let giftingBonus = event.giftingOpportunity.rawValue * 0.3

        // Time-based priority adjustment
        let daysDifference = abs(Calendar.current.dateComponents([.day], from: targetDate, to: event.date).day ?? 0)
        let timingFactor = max(0.1, 1.0 - (Double(daysDifference) / 30.0)) // Decreases over 30 days

        return min(1.0, (basePriority + significanceBonus + giftingBonus) * timingFactor)
    }

    private func generateGiftingSuggestions(for event: CulturalCalendarEvent) -> [GiftingSuggestion] {
        var suggestions: [GiftingSuggestion] = []

        // Base suggestions for all cultural events
        suggestions.append(GiftingSuggestion(
            type: .culturalGift,
            description: "Create a personalized \(event.culturalContext.displayName) gift",
            urgency: event.giftingOpportunity,
            culturalContext: event.culturalContext
        ))

        // Context-specific suggestions
        switch event.culturalContext {
        case .rakshabandhan:
            suggestions.append(GiftingSuggestion(
                type: .siblingGift,
                description: "Design a traditional Rakhi with meaningful symbols",
                urgency: .high,
                culturalContext: event.culturalContext
            ))

        case .diwali:
            suggestions.append(GiftingSuggestion(
                type: .familyGift,
                description: "Create gifts celebrating light and prosperity",
                urgency: .high,
                culturalContext: event.culturalContext
            ))

        default:
            break
        }

        return suggestions
    }

    private func determineCulturalSeason(for date: Date) -> CulturalSeason {
        let month = Calendar.current.component(.month, from: date)

        switch month {
        case 1, 2: return .winterCelebrations
        case 3, 4, 5: return .springFestivals
        case 6, 7, 8: return .summerCelebrations
        case 9, 10, 11: return .autumnFestivals
        case 12: return .winterCelebrations
        default: return .general
        }
    }

    private func generateRecommendedActions(for events: [CulturalCalendarEvent], on date: Date) -> [RecommendedAction] {
        var actions: [RecommendedAction] = []

        for event in events {
            let daysDifference = Calendar.current.dateComponents([.day], from: date, to: event.date).day ?? 0

            if daysDifference <= event.preparationDays && daysDifference > 0 {
                actions.append(RecommendedAction(
                    type: .startPreparation,
                    description: "Start preparing for \(event.name)",
                    deadline: event.date,
                    priority: event.significance
                ))
            } else if daysDifference <= 1 && daysDifference >= 0 {
                actions.append(RecommendedAction(
                    type: .createGift,
                    description: "Create and share gifts for \(event.name)",
                    deadline: event.date,
                    priority: event.significance
                ))
            }
        }

        return actions.sorted { $0.priority.rawValue > $1.priority.rawValue }
    }
}

// MARK: - Supporting Types and Enums

enum CalendarPermissionStatus {
    case notDetermined
    case restricted
    case denied
    case authorized
}

struct CulturalCalendarEvent: Identifiable, Codable {
    let id: UUID
    let name: String
    let culturalContext: CulturalContext
    let date: Date
    let duration: Int // days
    let description: String
    let significance: EventSignificance
    let preparationDays: Int
    let giftingOpportunity: GiftingOpportunity
    let customizations: [String: String]
    let source: EventSource
    let userRelevance: Double
}

enum EventSignificance: Double, CaseIterable, Codable {
    case low = 0.3
    case moderate = 0.6
    case high = 0.9
    case critical = 1.0

    var description: String {
        switch self {
        case .low: return "Personal significance"
        case .moderate: return "Community importance"
        case .high: return "Major cultural celebration"
        case .critical: return "Sacred cultural observance"
        }
    }
}

enum GiftingOpportunity: Double, CaseIterable, Codable {
    case none = 0.0
    case low = 0.3
    case moderate = 0.6
    case high = 0.9
}

enum EventSource: Codable {
    case culturalDatabase
    case userCalendar
    case globalCultural
    case astronomical
}

struct EventOccurrence {
    let date: Date
    var customizations: [String: String]
}

enum RecommendationType {
    case plannng
    case preparation
    case imminent
    case followUp
}

struct CulturalEventRecommendation {
    let event: CulturalCalendarEvent
    let recommendationType: RecommendationType
    let priority: Double
    let giftingSuggestions: [GiftingSuggestion]
}

struct GiftingSuggestion {
    let type: GiftingType
    let description: String
    let urgency: GiftingOpportunity
    let culturalContext: CulturalContext

    enum GiftingType {
        case culturalGift
        case familyGift
        case siblingGift
        case romanticGift
        case friendshipGift
    }
}

struct CulturalEventContext {
    let primaryEvent: CulturalCalendarEvent?
    let relatedEvents: [CulturalCalendarEvent]
    let culturalSeason: CulturalSeason
    let recommendedActions: [RecommendedAction]
}

enum CulturalSeason {
    case springFestivals
    case summerCelebrations
    case autumnFestivals
    case winterCelebrations
    case general
}

struct RecommendedAction {
    let type: ActionType
    let description: String
    let deadline: Date
    let priority: EventSignificance

    enum ActionType {
        case startPreparation
        case createGift
        case sendReminder
        case planCelebration
    }
}

// MARK: - Cultural Event Database

class CulturalEventDatabase {
    private var events: [CulturalContext: [CulturalEventDefinition]] = [:]

    func loadEvents() {
        events[.rakshabandhan] = [
            CulturalEventDefinition(
                name: "Raksha Bandhan",
                culturalContext: .rakshabandhan,
                calculationType: .lunar(15), // Full moon day of Shravan month
                description: "Festival celebrating the bond between siblings",
                significance: .high,
                duration: 1,
                preparationDays: 7,
                giftingOpportunity: .high
            )
        ]

        events[.diwali] = [
            CulturalEventDefinition(
                name: "Diwali",
                culturalContext: .diwali,
                calculationType: .lunar(0), // New moon day of Kartik month
                description: "Festival of lights celebrating good over evil",
                significance: .critical,
                duration: 5,
                preparationDays: 10,
                giftingOpportunity: .high
            )
        ]

        events[.chineseNewYear] = [
            CulturalEventDefinition(
                name: "Chinese New Year",
                culturalContext: .chineseNewYear,
                calculationType: .complex("chinese_new_year"),
                description: "Lunar New Year celebration",
                significance: .critical,
                duration: 15,
                preparationDays: 14,
                giftingOpportunity: .high
            )
        ]

        events[.christmas] = [
            CulturalEventDefinition(
                name: "Christmas",
                culturalContext: .christmas,
                calculationType: .fixed(DateComponents(month: 12, day: 25)),
                description: "Christian celebration of Jesus Christ's birth",
                significance: .critical,
                duration: 1,
                preparationDays: 21,
                giftingOpportunity: .high
            )
        ]

        // Add more cultural events...
    }

    func getEvents(for context: CulturalContext) -> [CulturalEventDefinition] {
        return events[context] ?? []
    }
}

struct CulturalEventDefinition {
    let name: String
    let culturalContext: CulturalContext
    let calculationType: CalculationType
    let description: String
    let significance: EventSignificance
    let duration: Int
    let preparationDays: Int
    let giftingOpportunity: GiftingOpportunity

    enum CalculationType {
        case fixed(DateComponents)
        case lunar(Int) // Days offset from new/full moon
        case relative(String, Int) // Relative to another event
        case complex(String) // Complex algorithm identifier
    }
}

// MARK: - Lunar Calendar Helper

class LunarCalendar {
    func nextNewMoon(after date: Date) -> Date? {
        // Simplified lunar calculation - in practice, use astronomical libraries
        let calendar = Calendar.current
        let _ = 29.53 // days (approximateLunarCycle)

        // Find next new moon (simplified)
        let daysToAdd = Int.random(in: 1...30) // Placeholder calculation
        return calendar.date(byAdding: .day, value: daysToAdd, to: date)
    }

    func getLunarPhase(for date: Date) -> String {
        // Simplified phase calculation
        let phases = ["New Moon", "Waxing Crescent", "First Quarter", "Waxing Gibbous",
                     "Full Moon", "Waning Gibbous", "Last Quarter", "Waning Crescent"]
        return phases.randomElement() ?? "Unknown"
    }
}
