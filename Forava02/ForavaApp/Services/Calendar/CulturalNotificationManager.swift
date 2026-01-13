import Foundation
import UserNotifications
import SwiftUI
import Combine

// PersonalizationServiceProtocol is defined in SharedCulturalTypes.swift

// MARK: - Cultural Notification Manager for Smart Notifications
@MainActor
class CulturalNotificationManager: NSObject, ObservableObject {
    static let shared = CulturalNotificationManager()
    
    @Published var notificationPermissionStatus: NotificationPermissionStatus = .notDetermined
    @Published var scheduledNotifications: [CulturalNotification] = []
    @Published var notificationHistory: [NotificationRecord] = []
    @Published var userNotificationPreferences: NotificationPreferences
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let calendarService = CulturalCalendarService.shared
    // PersonalizationService dependency - uses protocol for loose coupling
    private var personalizationService: PersonalizationServiceProtocol? {
        // Access the shared PersonalizationService if available
        // Using protocol to avoid tight coupling between services
        return nil // Will be connected when PersonalizationServiceProtocol conformance is added
    }

    // Notification frequency tracking for rate limiting
    private var notificationCountsByCategory: [NotificationType: Int] = [:]
    private var lastNotificationCountReset: Date = Date()
    private var culturalNotificationTemplates: [NotificationTemplate] = []
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        self.userNotificationPreferences = NotificationPreferences()
        super.init()
        
        notificationCenter.delegate = self
        loadNotificationTemplates()
        loadUserPreferences()
        setupEventObservers()
        requestNotificationPermissions()
    }
    
    // MARK: - Permission Management
    
    func requestNotificationPermissions() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.updatePermissionStatus(settings.authorizationStatus)
            }
        }
        
        let options: UNAuthorizationOptions = [.alert, .badge, .sound, .provisional]
        
        notificationCenter.requestAuthorization(options: options) { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Notification permission error: \(error)")
                    self?.notificationPermissionStatus = .denied
                } else {
                    self?.notificationPermissionStatus = granted ? .authorized : .denied
                    
                    if granted {
                        Task {
                            await self?.scheduleInitialCulturalNotifications()
                        }
                    }
                }
            }
        }
    }
    
    private func updatePermissionStatus(_ status: UNAuthorizationStatus) {
        switch status {
        case .notDetermined:
            notificationPermissionStatus = .notDetermined
        case .denied:
            notificationPermissionStatus = .denied
        case .authorized, .provisional, .ephemeral:
            notificationPermissionStatus = .authorized
        @unknown default:
            notificationPermissionStatus = .notDetermined
        }
    }
    
    // MARK: - Cultural Notification Scheduling
    
    func scheduleInitialCulturalNotifications() async {
        guard notificationPermissionStatus == .authorized else { return }
        
        // Clear existing cultural notifications
        await clearAllCulturalNotifications()
        
        // Schedule notifications based on upcoming cultural events
        let upcomingEvents = calendarService.upcomingCulturalEvents
        
        for event in upcomingEvents.prefix(20) { // Limit to next 20 events
            await scheduleCulturalEventNotifications(for: event)
        }
        
        // Schedule periodic cultural reminder notifications
        await schedulePeriodicCulturalReminders()
        
        // Schedule personalized recommendation notifications
        await schedulePersonalizedNotifications()
    }
    
    func scheduleCulturalEventNotifications(for event: CulturalCalendarEvent) async {
        let notifications = createNotificationsForEvent(event)
        
        for notification in notifications {
            await scheduleNotification(notification)
        }
    }
    
    private func createNotificationsForEvent(_ event: CulturalCalendarEvent) -> [CulturalNotification] {
        var notifications: [CulturalNotification] = []
        let now = Date()
        
        // Preparation notification (if event is far enough ahead)
        if event.preparationDays > 0 {
            let preparationDate = Calendar.current.date(
                byAdding: .day,
                value: -event.preparationDays,
                to: event.date
            ) ?? event.date
            
            if preparationDate > now {
                let template = getNotificationTemplate(for: .preparation, culturalContext: event.culturalContext)
                notifications.append(CulturalNotification(
                    id: UUID(),
                    type: .preparation,
                    culturalContext: event.culturalContext,
                    event: event,
                    scheduledDate: preparationDate,
                    title: template.title.replacingOccurrences(of: "{event}", with: event.name),
                    body: template.body.replacingOccurrences(of: "{event}", with: event.name)
                        .replacingOccurrences(of: "{days}", with: "\(event.preparationDays)"),
                    actionButtons: template.actionButtons,
                    priority: determinePriority(for: event, notificationType: .preparation)
                ))
            }
        }
        
        // Week-before reminder (for high-significance events)
        if event.significance.rawValue >= 0.6 {
            let weekBeforeDate = Calendar.current.date(byAdding: .day, value: -7, to: event.date) ?? event.date
            if weekBeforeDate > now {
                let template = getNotificationTemplate(for: .weekReminder, culturalContext: event.culturalContext)
                notifications.append(CulturalNotification(
                    id: UUID(),
                    type: .weekReminder,
                    culturalContext: event.culturalContext,
                    event: event,
                    scheduledDate: weekBeforeDate,
                    title: template.title.replacingOccurrences(of: "{event}", with: event.name),
                    body: template.body.replacingOccurrences(of: "{event}", with: event.name),
                    actionButtons: template.actionButtons,
                    priority: determinePriority(for: event, notificationType: .weekReminder)
                ))
            }
        }
        
        // Day-before reminder
        let dayBeforeDate = Calendar.current.date(byAdding: .day, value: -1, to: event.date) ?? event.date
        if dayBeforeDate > now {
            let template = getNotificationTemplate(for: .dayBefore, culturalContext: event.culturalContext)
            notifications.append(CulturalNotification(
                id: UUID(),
                type: .dayBefore,
                culturalContext: event.culturalContext,
                event: event,
                scheduledDate: dayBeforeDate,
                title: template.title.replacingOccurrences(of: "{event}", with: event.name),
                body: template.body.replacingOccurrences(of: "{event}", with: event.name),
                actionButtons: template.actionButtons,
                priority: determinePriority(for: event, notificationType: .dayBefore)
            ))
        }
        
        // Day-of celebration reminder
        if event.date > now {
            let template = getNotificationTemplate(for: .celebration, culturalContext: event.culturalContext)
            notifications.append(CulturalNotification(
                id: UUID(),
                type: .celebration,
                culturalContext: event.culturalContext,
                event: event,
                scheduledDate: event.date,
                title: template.title.replacingOccurrences(of: "{event}", with: event.name),
                body: template.body.replacingOccurrences(of: "{event}", with: event.name),
                actionButtons: template.actionButtons,
                priority: determinePriority(for: event, notificationType: .celebration)
            ))
        }
        
        // Optimal gifting time notification
        if event.giftingOpportunity.rawValue > 0.5 {
            let optimalGiftingTime = calendarService.getOptimalGiftingTime(for: event)
            if optimalGiftingTime > now {
                let template = getNotificationTemplate(for: .giftingReminder, culturalContext: event.culturalContext)
                notifications.append(CulturalNotification(
                    id: UUID(),
                    type: .giftingReminder,
                    culturalContext: event.culturalContext,
                    event: event,
                    scheduledDate: optimalGiftingTime,
                    title: template.title.replacingOccurrences(of: "{event}", with: event.name),
                    body: template.body.replacingOccurrences(of: "{event}", with: event.name),
                    actionButtons: template.actionButtons,
                    priority: determinePriority(for: event, notificationType: .giftingReminder)
                ))
            }
        }
        
        return notifications.filter { shouldScheduleNotification($0) }
    }
    
    // MARK: - Personalized Notification Scheduling
    
    private func schedulePeriodicCulturalReminders() async {
        guard userNotificationPreferences.enablePeriodicReminders else { return }
        
        // Weekly cultural exploration reminder
        let weeklyReminderDate = getNextWeeklyReminderDate()
        let weeklyNotification = CulturalNotification(
            id: UUID(),
            type: .periodicReminder,
            culturalContext: getRandomCulturalContext(),
            event: nil,
            scheduledDate: weeklyReminderDate,
            title: "Explore New Cultural Traditions",
            body: "Discover beautiful cultural celebrations happening this week",
            actionButtons: [
                NotificationAction(identifier: "explore", title: "Explore", options: [.foreground]),
                NotificationAction(identifier: "dismiss", title: "Later", options: [])
            ],
            priority: .low
        )
        
        await scheduleNotification(weeklyNotification)
    }
    
    private func schedulePersonalizedNotifications() async {
        guard let userProfile = personalizationService?.userCulturalProfile else { return }

        // Schedule notifications based on user's strongest cultural affinities
        let topAffinities = userProfile.culturalAffinities
            .sorted { $0.value > $1.value }
            .prefix(3)

        for (culturalContext, affinity) in topAffinities where affinity > 0.7 {
            await schedulePersonalizedCulturalInsights(for: culturalContext, affinity: affinity)
        }
    }
    
    private func schedulePersonalizedCulturalInsights(for context: CulturalContext, affinity: Double) async {
        // Schedule insights based on user interest level
        let insightDate = Calendar.current.date(byAdding: .day, value: Int.random(in: 3...7), to: Date()) ?? Date()
        
        let insightNotification = CulturalNotification(
            id: UUID(),
            type: .personalizedInsight,
            culturalContext: context,
            event: nil,
            scheduledDate: insightDate,
            title: "New \(context.displayName) Insights",
            body: "Discover deeper meanings and traditions in \(context.displayName) celebrations",
            actionButtons: [
                NotificationAction(identifier: "learn", title: "Learn More", options: [.foreground]),
                NotificationAction(identifier: "create", title: "Create Gift", options: [.foreground])
            ],
            priority: .medium
        )
        
        await scheduleNotification(insightNotification)
    }
    
    // MARK: - Notification Scheduling Infrastructure
    
    private func scheduleNotification(_ notification: CulturalNotification) async {
        guard notificationPermissionStatus == .authorized else { return }
        guard shouldScheduleNotification(notification) else { return }

        // Adjust scheduled date for quiet hours
        let adjustedDate = adjustForQuietHours(notification.scheduledDate)

        // Create adjusted notification if date changed
        var scheduledNotification = notification
        if adjustedDate != notification.scheduledDate {
            scheduledNotification = CulturalNotification(
                id: notification.id,
                type: notification.type,
                culturalContext: notification.culturalContext,
                event: notification.event,
                scheduledDate: adjustedDate,
                title: notification.title,
                body: notification.body,
                actionButtons: notification.actionButtons,
                priority: notification.priority
            )
        }

        // Increment frequency counter
        incrementNotificationCount(for: notification.type)

        let content = UNMutableNotificationContent()
        content.title = notification.title
        content.body = notification.body
        content.sound = getNotificationSound(for: notification)
        content.badge = 1
        
        // Add custom data
        content.userInfo = [
            "cultural_context": notification.culturalContext.rawValue,
            "notification_type": notification.type.rawValue,
            "event_id": notification.event?.id.uuidString ?? "",
            "notification_id": notification.id.uuidString
        ]
        
        // Add action buttons
        if !notification.actionButtons.isEmpty {
            let actions = notification.actionButtons.map { actionButton in
                UNNotificationAction(
                    identifier: actionButton.identifier,
                    title: actionButton.title,
                    options: actionButton.options
                )
            }
            
            let categoryIdentifier = "cultural_\(notification.type.rawValue)"
            let category = UNNotificationCategory(
                identifier: categoryIdentifier,
                actions: actions,
                intentIdentifiers: [],
                options: []
            )
            
            notificationCenter.setNotificationCategories([category])
            content.categoryIdentifier = categoryIdentifier
        }
        
        // Add cultural imagery
        if let imageURL = getCulturalImageURL(for: notification.culturalContext) {
            if let attachment = try? UNNotificationAttachment(identifier: "cultural_image", url: imageURL) {
                content.attachments = [attachment]
            }
        }
        
        // Schedule notification using adjusted date
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute],
                                                         from: scheduledNotification.scheduledDate),
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: scheduledNotification.id.uuidString,
            content: content,
            trigger: trigger
        )

        do {
            try await notificationCenter.add(request)
            scheduledNotifications.append(scheduledNotification)
            print("Scheduled cultural notification: \(scheduledNotification.title) for \(scheduledNotification.scheduledDate)")
        } catch {
            print("Failed to schedule notification: \(error)")
        }
    }
    
    // MARK: - Notification Management
    
    func cancelNotification(_ notification: CulturalNotification) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notification.id.uuidString])
        scheduledNotifications.removeAll { $0.id == notification.id }
    }
    
    func cancelAllCulturalNotifications() async {
        let identifiers = scheduledNotifications.map { $0.id.uuidString }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        scheduledNotifications.removeAll()
    }
    
    private func clearAllCulturalNotifications() async {
        // Get all pending notifications
        let pendingRequests = await notificationCenter.pendingNotificationRequests()
        
        // Filter for cultural notifications
        let culturalIdentifiers = pendingRequests.compactMap { request -> String? in
            if let culturalContext = request.content.userInfo["cultural_context"] as? String,
               !culturalContext.isEmpty {
                return request.identifier
            }
            return nil
        }
        
        // Remove cultural notifications
        notificationCenter.removePendingNotificationRequests(withIdentifiers: culturalIdentifiers)
        scheduledNotifications.removeAll()
    }
    
    func updateNotificationPreferences(_ preferences: NotificationPreferences) {
        userNotificationPreferences = preferences
        saveUserPreferences()
        
        // Reschedule notifications based on new preferences
        Task {
            await scheduleInitialCulturalNotifications()
        }
    }
    
    // MARK: - Smart Notification Logic

    private func shouldScheduleNotification(_ notification: CulturalNotification) -> Bool {
        // Check user preferences first
        let typeEnabled: Bool
        switch notification.type {
        case .preparation:
            typeEnabled = userNotificationPreferences.enablePreparationReminders
        case .weekReminder:
            typeEnabled = userNotificationPreferences.enableWeeklyReminders
        case .dayBefore:
            typeEnabled = userNotificationPreferences.enableDayBeforeReminders
        case .celebration:
            typeEnabled = userNotificationPreferences.enableCelebrationReminders
        case .giftingReminder:
            typeEnabled = userNotificationPreferences.enableGiftingReminders
        case .periodicReminder:
            typeEnabled = userNotificationPreferences.enablePeriodicReminders
        case .personalizedInsight:
            typeEnabled = userNotificationPreferences.enablePersonalizedInsights
        }

        guard typeEnabled else { return false }

        // Check quiet hours
        if isWithinQuietHours(notification.scheduledDate) {
            // Reschedule to after quiet hours if possible
            return false
        }

        // Check frequency limits
        if exceedsFrequencyLimit(notification.type) {
            return false
        }

        return true
    }

    // MARK: - Quiet Hours Enforcement

    private func isWithinQuietHours(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)

        let quietStart = userNotificationPreferences.quietHoursStart
        let quietEnd = userNotificationPreferences.quietHoursEnd

        // Handle quiet hours that span midnight (e.g., 22:00 - 08:00)
        if quietStart > quietEnd {
            // Quiet period spans midnight
            return hour >= quietStart || hour < quietEnd
        } else {
            // Quiet period within same day
            return hour >= quietStart && hour < quietEnd
        }
    }

    /// Adjusts a notification time to avoid quiet hours
    private func adjustForQuietHours(_ date: Date) -> Date {
        guard isWithinQuietHours(date) else { return date }

        let calendar = Calendar.current
        let quietEnd = userNotificationPreferences.quietHoursEnd

        // Move notification to after quiet hours end
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = quietEnd
        components.minute = 0

        if let adjustedDate = calendar.date(from: components) {
            // If the adjusted time is before the original, move to next day
            if adjustedDate < date {
                return calendar.date(byAdding: .day, value: 1, to: adjustedDate) ?? date
            }
            return adjustedDate
        }

        return date
    }

    // MARK: - Frequency Rate Limiting

    private func exceedsFrequencyLimit(_ type: NotificationType) -> Bool {
        // Reset counts weekly
        resetFrequencyCountsIfNeeded()

        let currentCount = notificationCountsByCategory[type] ?? 0
        let limit = getFrequencyLimit(for: type)

        return currentCount >= limit
    }

    private func getFrequencyLimit(for type: NotificationType) -> Int {
        // Weekly limits per notification type
        switch type {
        case .preparation:
            return 5  // Max 5 preparation reminders per week
        case .weekReminder:
            return 5  // Max 5 week reminders per week
        case .dayBefore:
            return 7  // Max 7 day-before reminders per week (one per day)
        case .celebration:
            return 5  // Max 5 celebration notifications per week
        case .giftingReminder:
            return 3  // Max 3 gifting reminders per week
        case .periodicReminder:
            return 1  // Max 1 periodic reminder per week
        case .personalizedInsight:
            return 2  // Max 2 personalized insights per week
        }
    }

    private func resetFrequencyCountsIfNeeded() {
        let calendar = Calendar.current
        let weeksSinceReset = calendar.dateComponents([.weekOfYear], from: lastNotificationCountReset, to: Date()).weekOfYear ?? 0

        if weeksSinceReset >= 1 {
            notificationCountsByCategory.removeAll()
            lastNotificationCountReset = Date()
        }
    }

    private func incrementNotificationCount(for type: NotificationType) {
        notificationCountsByCategory[type] = (notificationCountsByCategory[type] ?? 0) + 1
    }
    
    private func determinePriority(for event: CulturalCalendarEvent, notificationType: NotificationType) -> NotificationPriority {
        let baseSignificance = event.significance.rawValue
        let userRelevance = event.userRelevance
        
        let combinedScore = (baseSignificance + userRelevance) / 2.0
        
        // Adjust based on notification type
        let typeModifier: Double
        switch notificationType {
        case .celebration:
            typeModifier = 1.2 // Celebration notifications are most important
        case .dayBefore:
            typeModifier = 1.1
        case .giftingReminder:
            typeModifier = 1.0
        case .preparation:
            typeModifier = 0.9
        case .weekReminder:
            typeModifier = 0.8
        case .periodicReminder, .personalizedInsight:
            typeModifier = 0.7
        }
        
        let finalScore = combinedScore * typeModifier
        
        if finalScore > 0.8 {
            return .high
        } else if finalScore > 0.6 {
            return .medium
        } else {
            return .low
        }
    }
    
    // MARK: - Notification Templates and Personalization
    
    private func getNotificationTemplate(for type: NotificationType, culturalContext: CulturalContext) -> NotificationTemplate {
        // Find specific template for this context and type
        if let template = culturalNotificationTemplates.first(where: { 
            $0.type == type && $0.culturalContext == culturalContext 
        }) {
            return template
        }
        
        // Fall back to generic template for this type
        if let template = culturalNotificationTemplates.first(where: { 
            $0.type == type && $0.culturalContext == nil 
        }) {
            return template
        }
        
        // Return default template
        return getDefaultTemplate(for: type)
    }
    
    private func getDefaultTemplate(for type: NotificationType) -> NotificationTemplate {
        switch type {
        case .preparation:
            return NotificationTemplate(
                type: type,
                culturalContext: nil,
                title: "Prepare for {event}",
                body: "Start preparing for {event} in {days} days. Create beautiful cultural gifts!",
                actionButtons: [
                    NotificationAction(identifier: "create_gift", title: "Create Gift", options: [.foreground]),
                    NotificationAction(identifier: "learn_more", title: "Learn More", options: [.foreground])
                ]
            )
            
        case .weekReminder:
            return NotificationTemplate(
                type: type,
                culturalContext: nil,
                title: "{event} is coming up",
                body: "{event} is next week. Perfect time to start planning your celebration!",
                actionButtons: [
                    NotificationAction(identifier: "plan", title: "Plan", options: [.foreground])
                ]
            )
            
        case .dayBefore:
            return NotificationTemplate(
                type: type,
                culturalContext: nil,
                title: "{event} is tomorrow",
                body: "Don't forget {event} is tomorrow! Last chance to create meaningful gifts.",
                actionButtons: [
                    NotificationAction(identifier: "create_now", title: "Create Now", options: [.foreground]),
                    NotificationAction(identifier: "set_reminder", title: "Remind Later", options: [])
                ]
            )
            
        case .celebration:
            return NotificationTemplate(
                type: type,
                culturalContext: nil,
                title: "Happy {event}! 🎉",
                body: "Celebrate {event} today! Share your beautiful cultural creations with loved ones.",
                actionButtons: [
                    NotificationAction(identifier: "share", title: "Share", options: [.foreground]),
                    NotificationAction(identifier: "create", title: "Create", options: [.foreground])
                ]
            )
            
        case .giftingReminder:
            return NotificationTemplate(
                type: type,
                culturalContext: nil,
                title: "Perfect time to create gifts for {event}",
                body: "Create and send beautiful {event} gifts now for the perfect timing!",
                actionButtons: [
                    NotificationAction(identifier: "create_gift", title: "Create Gift", options: [.foreground])
                ]
            )
            
        case .periodicReminder:
            return NotificationTemplate(
                type: type,
                culturalContext: nil,
                title: "Discover Cultural Celebrations",
                body: "Explore new cultural traditions and create meaningful connections.",
                actionButtons: [
                    NotificationAction(identifier: "explore", title: "Explore", options: [.foreground])
                ]
            )
            
        case .personalizedInsight:
            return NotificationTemplate(
                type: type,
                culturalContext: nil,
                title: "New Cultural Insights",
                body: "Learn more about traditions you love and discover new ways to celebrate.",
                actionButtons: [
                    NotificationAction(identifier: "learn", title: "Learn", options: [.foreground])
                ]
            )
        }
    }
    
    // MARK: - Helper Methods
    
    private func getNotificationSound(for notification: CulturalNotification) -> UNNotificationSound {
        // Use different sounds for different cultural contexts
        switch notification.culturalContext {
        case .rakshabandhan, .diwali:
            return UNNotificationSound(named: UNNotificationSoundName("temple_bell.caf"))
        case .chineseNewYear:
            return UNNotificationSound(named: UNNotificationSoundName("wind_chime.caf"))
        case .christmas:
            return UNNotificationSound(named: UNNotificationSoundName("jingle_bell.caf"))
        default:
            return UNNotificationSound.default
        }
    }
    
    private func getCulturalImageURL(for context: CulturalContext) -> URL? {
        // Return URLs to cultural images stored in app bundle
        let imageName: String
        switch context {
        case .rakshabandhan: imageName = "rakhi_notification"
        case .diwali: imageName = "diya_notification"
        case .chineseNewYear: imageName = "dragon_notification"
        case .christmas: imageName = "christmas_notification"
        default: imageName = "cultural_default"
        }

        // Try PNG first (preferred for asset catalog), then JPG as fallback
        if let pngURL = Bundle.main.url(forResource: imageName, withExtension: "png") {
            return pngURL
        }
        return Bundle.main.url(forResource: imageName, withExtension: "jpg")
    }
    
    private func getNextWeeklyReminderDate() -> Date {
        let calendar = Calendar.current
        let now = Date()
        
        // Schedule for next preferred day of week (default: Sunday)
        let preferredWeekday = userNotificationPreferences.preferredReminderDay
        let preferredHour = userNotificationPreferences.preferredReminderTime
        
        var dateComponents = DateComponents()
        dateComponents.weekday = preferredWeekday
        dateComponents.hour = preferredHour
        
        return calendar.nextDate(after: now, matching: dateComponents, matchingPolicy: .nextTime) ?? 
               calendar.date(byAdding: .day, value: 7, to: now) ?? now
    }
    
    private func getRandomCulturalContext() -> CulturalContext {
        let userProfile = personalizationService?.userCulturalProfile
        let relevantContexts = userProfile?.primaryCulturalContexts ?? Array(CulturalContext.allCases.prefix(5))
        return relevantContexts.randomElement() ?? .anniversary
    }
    
    // MARK: - Data Management
    
    private func loadNotificationTemplates() {
        culturalNotificationTemplates = [
            // Raksha Bandhan specific templates
            NotificationTemplate(
                type: .celebration,
                culturalContext: .rakshabandhan,
                title: "Happy Raksha Bandhan! 🎊",
                body: "Celebrate the sacred bond of siblings today! Share beautiful Rakhi creations with your loved ones.",
                actionButtons: [
                    NotificationAction(identifier: "create_rakhi", title: "Create Rakhi", options: [.foreground]),
                    NotificationAction(identifier: "share", title: "Share", options: [.foreground])
                ]
            ),
            
            // Diwali specific templates
            NotificationTemplate(
                type: .preparation,
                culturalContext: .diwali,
                title: "Diwali preparations begin! ✨",
                body: "Start preparing for the Festival of Lights! Create luminous gifts that celebrate prosperity and joy.",
                actionButtons: [
                    NotificationAction(identifier: "create_diwali_gift", title: "Create Gift", options: [.foreground]),
                    NotificationAction(identifier: "diwali_traditions", title: "Learn Traditions", options: [.foreground])
                ]
            )
            
            // Add more specific templates...
        ]
    }
    
    private func loadUserPreferences() {
        if let data = UserDefaults.standard.data(forKey: "NotificationPreferences"),
           let preferences = try? JSONDecoder().decode(NotificationPreferences.self, from: data) {
            userNotificationPreferences = preferences
        }
    }
    
    private func saveUserPreferences() {
        if let data = try? JSONEncoder().encode(userNotificationPreferences) {
            UserDefaults.standard.set(data, forKey: "NotificationPreferences")
        }
    }
    
    private func setupEventObservers() {
        // Observe changes in cultural events
        calendarService.$upcomingCulturalEvents
            .debounce(for: .seconds(5), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                Task {
                    await self?.scheduleInitialCulturalNotifications()
                }
            }
            .store(in: &cancellables)
        
        // Observe changes in user cultural profile
        // TODO: Restore when PersonalizationService is properly added to project
        /*
        personalizationService?.$userCulturalProfile
            .debounce(for: DispatchTimeInterval.seconds(10), scheduler: DispatchQueue.main)
            .sink { [weak self] (_: CulturalProfile?) in
                Task {
                    await self?.schedulePersonalizedNotifications()
                }
            }
            .store(in: &cancellables)
        */
    }
    
    // MARK: - Analytics and Tracking
    
    private func recordNotificationInteraction(_ interaction: NotificationInteraction) {
        let record = NotificationRecord(
            id: UUID(),
            notificationId: interaction.notificationId,
            interactionType: String(describing: interaction.type),
            culturalContext: interaction.culturalContext,
            timestamp: Date(),
            response: String(describing: interaction.response)
        )
        
        notificationHistory.append(record)
        
        // Limit history size
        if notificationHistory.count > 1000 {
            notificationHistory.removeFirst(100)
        }
        
        // Use interaction data to improve future notifications
        adjustNotificationStrategy(based: record)
    }
    
    private func adjustNotificationStrategy(based record: NotificationRecord) {
        // Analyze user response patterns to improve notification timing and content
        
        switch record.response {
        case "opened":
            // User engagement is good, continue similar notifications
            break
        case "dismissed":
            // Consider reducing frequency for this context
            break
        case "interacted":
            // High engagement, prioritize similar notifications
            break
        default:
            break
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension CulturalNotificationManager: UNUserNotificationCenterDelegate {
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .badge, .sound])
    }
    
    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        let userInfo = response.notification.request.content.userInfo
        let actionIdentifier = response.actionIdentifier
        
        // Extract notification data
        guard let culturalContextString = userInfo["cultural_context"] as? String,
              let culturalContext = CulturalContext(rawValue: culturalContextString),
              let notificationIdString = userInfo["notification_id"] as? String,
              let notificationId = UUID(uuidString: notificationIdString) else {
            completionHandler()
            return
        }
        
        // Record the interaction
        Task { @MainActor in
            let interaction = NotificationInteraction(
                notificationId: notificationId,
                culturalContext: culturalContext,
                type: .action,
                response: determineResponseType(actionIdentifier)
            )
            recordNotificationInteraction(interaction)
        }
        
        // Handle the action
        Task {
            await handleNotificationAction(actionIdentifier, culturalContext: culturalContext)
        }
        
        completionHandler()
    }
    
    private func determineResponseType(_ actionIdentifier: String) -> NotificationResponseType {
        switch actionIdentifier {
        case UNNotificationDefaultActionIdentifier:
            return .opened
        case UNNotificationDismissActionIdentifier:
            return .dismissed
        default:
            return .interacted
        }
    }
    
    private func handleNotificationAction(_ actionIdentifier: String, culturalContext: CulturalContext) async {
        switch actionIdentifier {
        case "create_gift", "create_rakhi", "create_diwali_gift":
            // Navigate to gift creation
            NotificationCenter.default.post(name: .navigateToGiftCreation, object: culturalContext)
            
        case "share":
            // Navigate to sharing
            NotificationCenter.default.post(name: .navigateToSharing, object: nil)
            
        case "explore", "learn_more":
            // Navigate to cultural learning
            NotificationCenter.default.post(name: .navigateToCulturalLearning, object: culturalContext)
            
        case "plan":
            // Navigate to planning
            NotificationCenter.default.post(name: .navigateToPlanning, object: culturalContext)
            
        default:
            break
        }
    }
}

// MARK: - Supporting Types

enum NotificationPermissionStatus {
    case notDetermined
    case denied
    case authorized
}

enum NotificationType: String, CaseIterable, Codable {
    case preparation
    case weekReminder
    case dayBefore
    case celebration
    case giftingReminder
    case periodicReminder
    case personalizedInsight
}

enum NotificationPriority: String, Codable {
    case low
    case medium
    case high
}

struct CulturalNotification: Identifiable, Codable {
    let id: UUID
    let type: NotificationType
    let culturalContext: CulturalContext
    let event: CulturalCalendarEvent?
    let scheduledDate: Date
    let title: String
    let body: String
    let actionButtons: [NotificationAction]
    let priority: NotificationPriority
}

struct NotificationAction: Codable {
    let identifier: String
    let title: String
    let options: UNNotificationActionOptions
    
    init(identifier: String, title: String, options: UNNotificationActionOptions) {
        self.identifier = identifier
        self.title = title
        self.options = options
    }
    
    // Custom coding to handle UNNotificationActionOptions
    enum CodingKeys: String, CodingKey {
        case identifier, title, options
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        identifier = try container.decode(String.self, forKey: .identifier)
        title = try container.decode(String.self, forKey: .title)
        let rawValue = try container.decode(UInt.self, forKey: .options)
        options = UNNotificationActionOptions(rawValue: rawValue)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(identifier, forKey: .identifier)
        try container.encode(title, forKey: .title)
        try container.encode(options.rawValue, forKey: .options)
    }
}

struct NotificationTemplate {
    let type: NotificationType
    let culturalContext: CulturalContext?
    let title: String
    let body: String
    let actionButtons: [NotificationAction]
}

struct NotificationPreferences: Codable {
    var enablePreparationReminders: Bool = true
    var enableWeeklyReminders: Bool = true
    var enableDayBeforeReminders: Bool = true
    var enableCelebrationReminders: Bool = true
    var enableGiftingReminders: Bool = true
    var enablePeriodicReminders: Bool = false
    var enablePersonalizedInsights: Bool = true
    var preferredReminderDay: Int = 1 // Sunday
    var preferredReminderTime: Int = 10 // 10 AM
    var quietHoursStart: Int = 22 // 10 PM
    var quietHoursEnd: Int = 8 // 8 AM
}

struct NotificationInteraction {
    let notificationId: UUID
    let culturalContext: CulturalContext
    let type: InteractionType
    let response: NotificationResponseType
    
    enum InteractionType {
        case delivered
        case viewed
        case action
        case dismissed
    }
}

enum NotificationResponseType {
    case opened
    case dismissed
    case interacted
}

struct NotificationRecord: Identifiable, Codable {
    let id: UUID
    let notificationId: UUID
    let interactionType: String
    let culturalContext: CulturalContext
    let timestamp: Date
    let response: String
}

// MARK: - Notification Names for Navigation

extension Notification.Name {
    static let navigateToGiftCreation = Notification.Name("navigateToGiftCreation")
    static let navigateToSharing = Notification.Name("navigateToSharing")
    static let navigateToCulturalLearning = Notification.Name("navigateToCulturalLearning")
    static let navigateToPlanning = Notification.Name("navigateToPlanning")
}