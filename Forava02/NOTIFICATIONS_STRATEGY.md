# Forava Notifications Strategy

A comprehensive guide to push notifications designed to boost user engagement, encourage gift creation, and help users celebrate cultural moments meaningfully.

---

## Implementation Status

| Attribute | Value |
|-----------|-------|
| **Status** | In Progress |
| **Development Branch** | `Notifications` |
| **Merge Target** | `XCode04_Se` |
| **Last Updated** | January 12, 2026 |

> **Merge Instructions:** When notifications implementation is complete, merge this branch into `XCode04_Se` for integration with the main development line.

---

## Table of Contents

1. [Overview & Goals](#overview--goals)
2. [Notification Categories](#notification-categories)
3. [Cultural Event Notifications](#cultural-event-notifications)
4. [Feature-Based Notifications](#feature-based-notifications)
5. [User Preference Settings](#user-preference-settings)
6. [Best Practices](#best-practices)
7. [Implementation Reference](#implementation-reference)

---

## Overview & Goals

### Purpose

Notifications in Forava serve to:
- Remind users of upcoming cultural celebrations in their life
- Encourage timely gift creation before important events
- Build a habit of meaningful digital gifting
- Celebrate cultural moments together with loved ones

### Engagement Principles

1. **Value-First**: Every notification should provide clear value to the user
2. **Culturally Respectful**: Messaging must honor each tradition's significance
3. **Personalized**: Notifications adapt to user preferences and cultural affinities
4. **Non-Intrusive**: Respect quiet hours and frequency limits

### Target Metrics

| Metric | Target |
|--------|--------|
| Notification opt-in rate | >70% |
| Open rate | >25% |
| Gift creation from notification | >15% |
| Unsubscribe rate | <5% |

---

## Notification Categories

### 1. Cultural Event Reminders

Timed notifications around cultural celebrations.

| Type | Timing | Purpose |
|------|--------|---------|
| **Preparation** | 7-14 days before | Plan ahead reminder |
| **Week Reminder** | 7 days before | Gift creation prompt |
| **Day Before** | 1 day before | Last-minute reminder |
| **Celebration** | Day of event | Celebration & sharing prompt |

### 2. Gift Creation Prompts

Encourage users to create and send gifts.

| Notification | Trigger | Message Focus |
|--------------|---------|---------------|
| **Optimal Timing** | Best window for gift creation | "Perfect time to create a gift" |
| **Quota Alert** | Free generation available | "Your free generation is ready" |
| **Regeneration Available** | Credits restored | "Create something new today" |
| **Draft Reminder** | Incomplete gift saved | "Finish your beautiful creation" |

### 3. Subscription & Account

Keep users informed about their account status.

| Notification | Trigger | Priority |
|--------------|---------|----------|
| **Welcome** | New signup | High |
| **Subscription Expiring** | 7 days before expiry | High |
| **Subscription Expired** | Day of expiry | High |
| **Credit Balance Low** | <3 credits remaining | Medium |
| **Purchase Confirmation** | Successful IAP | High |
| **Credit Pack Bonus** | Special offer available | Low |

### 4. Social Engagement

Celebrate sharing and community moments.

| Notification | Trigger |
|--------------|---------|
| **Share Success** | Gift successfully shared |
| **Gift Delivered** | Recipient opened gift |
| **Gift Viewed** | Recipient viewed animation |
| **Trending Celebration** | Popular event in user's culture |

### 5. Personalized Insights

Cultural learning and discovery.

| Notification | Frequency | Content |
|--------------|-----------|---------|
| **Cultural Insight** | Weekly | Did-you-know cultural facts |
| **New Event Discovery** | When relevant | Introduce new celebrations |
| **Seasonal Highlight** | Seasonal | Upcoming cultural season |

### 6. Watch App Sync

> **Status:** Not Applicable - Watch app sync functionality has not been implemented in the current app architecture. This section is retained for future reference only.

Cross-device notifications (Future Enhancement).

| Notification | Device | Purpose |
|--------------|--------|---------|
| **Gift Ready on Watch** | Watch | Animation synced |
| **Haptic Alert** | Watch | Gift delivery trigger |
| **Sync Complete** | iOS | Cross-device confirmation |

---

## Cultural Event Notifications

### Hindu Celebrations

#### Raksha Bandhan

**Theme**: Bond of protection between siblings

| Timing | Title | Body |
|--------|-------|------|
| 14 days before | Raksha Bandhan is coming | Time to plan something special for your sibling. Create a meaningful digital Rakhi. |
| 7 days before | One week until Raksha Bandhan | Your sibling would love a personalized Rakhi. Start creating now! |
| 1 day before | Raksha Bandhan is tomorrow! | Don't forget to send your digital Rakhi with a heartfelt message. |
| Day of | Happy Raksha Bandhan! | Celebrate the sacred bond. Share your love today. |

#### Diwali

**Theme**: Festival of lights, triumph of good over evil

| Timing | Title | Body |
|--------|-------|------|
| 14 days before | Diwali preparations begin | The festival of lights approaches. Create luminous greetings for your loved ones. |
| 7 days before | Light up someone's Diwali | One week until Diwali. Design beautiful AI-powered greetings with diyas and rangoli. |
| 1 day before | Diwali eve is here | Tomorrow we celebrate! Finish your Diwali greetings and share the light. |
| Day of | Shubh Diwali! | May the light of diyas guide you. Share joy with those you love. |

#### Holi

**Theme**: Festival of colors, spring celebration

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | Colors of Holi await | The festival of colors is near. Create vibrant greetings bursting with joy. |
| 1 day before | Holi celebrations start tomorrow | Get ready to play with colors! Send your colorful wishes now. |
| Day of | Happy Holi! | Spread love and color today. Share your greetings with everyone! |

---

### Chinese Celebrations

#### Chinese New Year

**Theme**: New beginnings, family reunion, prosperity

| Timing | Title | Body |
|--------|-------|------|
| 14 days before | Chinese New Year approaches | The Year of the [Zodiac] is coming! Create auspicious greetings for family. |
| 7 days before | Prepare for the Spring Festival | Red envelopes and golden wishes await. Design your New Year greetings. |
| 1 day before | New Year's Eve is tomorrow | Family reunion time! Send your blessings before the celebrations begin. |
| Day of | Gong Xi Fa Cai! | Wishing you prosperity and happiness in the new year. Share your joy! |

#### Mid-Autumn Festival

**Theme**: Harvest moon, family togetherness, mooncakes

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | The Moon Festival nears | The harvest moon will soon shine. Create moonlit greetings for loved ones. |
| 1 day before | Mid-Autumn Festival tomorrow | Time for mooncakes and lanterns. Send your lunar blessings tonight. |
| Day of | Happy Mid-Autumn Festival | May the full moon bring you family harmony and lasting happiness. |

---

### Christian Celebrations

#### Christmas

**Theme**: Birth of Christ, peace, giving, family

| Timing | Title | Body |
|--------|-------|------|
| 14 days before | Christmas is coming | The season of giving begins. Create heartwarming greetings for family and friends. |
| 7 days before | One week until Christmas | Spread holiday cheer with personalized Christmas cards and messages. |
| 1 day before | Christmas Eve is here | Tomorrow we celebrate! Send your Christmas wishes before the big day. |
| Day of | Merry Christmas! | Celebrate the joy of the season. Share love and warmth with everyone. |

#### Easter

**Theme**: Resurrection, renewal, spring, hope

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | Easter is approaching | Spring renewal and hope await. Create joyful Easter greetings. |
| 1 day before | Easter Sunday is tomorrow | The celebration of new life begins. Send your Easter blessings. |
| Day of | Happy Easter! | He is risen! Share hope and joy with your loved ones today. |

---

### Islamic Celebrations

#### Eid al-Fitr

**Theme**: Breaking of fast, gratitude, celebration after Ramadan

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | Eid al-Fitr approaches | The blessed celebration after Ramadan nears. Prepare your Eid greetings. |
| 1 day before | Eid is almost here | Tomorrow marks the end of Ramadan. Create beautiful Eid Mubarak wishes. |
| Day of | Eid Mubarak! | Celebrate the breaking of fast with joy. Share blessings with family. |

#### Eid al-Adha

**Theme**: Festival of sacrifice, devotion, charity

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | Eid al-Adha is coming | The Festival of Sacrifice approaches. Honor devotion with heartfelt greetings. |
| 1 day before | Prepare for Eid al-Adha | Tomorrow we celebrate faith and sacrifice. Send your Eid wishes. |
| Day of | Eid Mubarak! | May your sacrifices be accepted. Share joy and blessings today. |

---

### Jewish Celebrations

#### Rosh Hashanah

**Theme**: Jewish New Year, reflection, new beginnings

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | Rosh Hashanah approaches | The Jewish New Year is near. Create sweet greetings for a blessed year ahead. |
| 1 day before | Rosh Hashanah begins tomorrow | Time for apples and honey. Send L'Shanah Tovah wishes to loved ones. |
| Day of | L'Shanah Tovah! | May you be inscribed for a good year. Share blessings with family. |

#### Hanukkah

**Theme**: Festival of lights, miracles, dedication

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | Hanukkah is coming | The Festival of Lights begins soon. Create glowing greetings for eight nights. |
| 1 day before | Light the first candle tomorrow | Hanukkah begins! Prepare your messages of light and miracles. |
| Day of | Happy Hanukkah! | May the lights of the menorah brighten your home. Share the miracle! |

---

### Buddhist Celebrations

#### Vesak Day

**Theme**: Buddha's birth, enlightenment, and passing; compassion

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | Vesak Day approaches | The most sacred Buddhist day is near. Create peaceful, mindful greetings. |
| 1 day before | Vesak celebrations begin tomorrow | Honor the Buddha's teachings. Send messages of compassion and peace. |
| Day of | Happy Vesak! | May peace and enlightenment guide you. Share loving-kindness today. |

---

### Universal Celebrations

#### Birthdays

**Theme**: Personal celebration, another year of life

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | Birthday coming up | [Name]'s birthday is in one week. Create a personalized birthday surprise! |
| 1 day before | Birthday tomorrow! | [Name]'s special day is almost here. Make their birthday unforgettable. |
| Day of | Happy Birthday time! | It's [Name]'s birthday! Send your wishes and make them smile. |

#### Anniversaries

**Theme**: Milestone celebrations, lasting love

| Timing | Title | Body |
|--------|-------|------|
| 7 days before | Anniversary approaching | A special milestone is coming. Create a meaningful anniversary celebration. |
| 1 day before | Anniversary is tomorrow | Celebrate years of memories. Prepare something heartfelt. |
| Day of | Happy Anniversary! | Celebrate this beautiful milestone. Share your love today. |

---

## Feature-Based Notifications

### Gift Creation Journey

```
Trigger: User hasn't created a gift in 30+ days
Title: We miss your creativity!
Body: Your loved ones would love a personalized greeting. Create something beautiful today.
Action: [Create Gift] button
```

```
Trigger: User started but didn't finish gift
Title: Your gift is waiting
Body: You were creating something special. Come back and finish your masterpiece.
Action: [Continue Creating] button
```

```
Trigger: Free daily generation available
Title: Your free design awaits
Body: Create one AI-generated greeting today, on us. What will you make?
Action: [Start Creating] button
```

### Subscription Lifecycle

```
Trigger: 7 days before subscription expires
Title: Your subscription is ending soon
Body: Renew to keep creating unlimited cultural greetings for your loved ones.
Action: [Renew Now] button
```

```
Trigger: Subscription expired
Title: We'd love to have you back
Body: Your subscription has ended. Resubscribe to continue creating beautiful gifts.
Action: [Resubscribe] button
```

```
Trigger: Credit balance below 3
Title: Running low on credits
Body: Only [X] regeneration credits left. Top up to keep creating fresh designs.
Action: [Get Credits] button
```

### Social & Sharing

```
Trigger: Recipient opened gift
Title: Your gift was delivered!
Body: [Name] opened your [Event] greeting. Your love reached them.
Action: None (celebration moment)
```

```
Trigger: Gift viewed for first time
Title: [Name] loved your gift!
Body: Your [Event] creation brought joy. Consider sharing with more loved ones?
Action: [Share Again] button
```

---

## User Preference Settings

### Notification Toggles

Users can control these in Settings:

| Toggle | Default | Description |
|--------|---------|-------------|
| Event Reminders | ON | Cultural event countdown notifications |
| Gift Prompts | ON | Creation and completion reminders |
| Subscription Alerts | ON | Account and billing notifications |
| Social Updates | ON | Sharing and delivery confirmations |
| Cultural Insights | ON | Weekly learning moments |
| Watch Sync | N/A | Cross-device notifications (not implemented) |
| Promotional | OFF | Special offers and bonuses |

### Timing Preferences

| Setting | Options | Default |
|---------|---------|---------|
| Quiet Hours Start | 6 PM - 12 AM | 10:00 PM |
| Quiet Hours End | 6 AM - 12 PM | 8:00 AM |
| Reminder Day | 1-14 days before | 7 days |
| Preferred Time | Morning/Afternoon/Evening | Morning |

### Frequency Limits

| Category | Max Per Week |
|----------|--------------|
| Event Reminders | 5 |
| Gift Prompts | 3 |
| Insights | 1 |
| Promotional | 1 |

---

## Best Practices

### Timing Optimization

1. **Cultural Context Matters**
   - Send Diwali notifications in the evening (festival of lights)
   - Send Chinese New Year notifications in the morning (fresh start)
   - Avoid sending Islamic notifications during prayer times

2. **User Behavior Patterns**
   - Track when users typically open the app
   - Send notifications 30 minutes before peak engagement times
   - Avoid Mondays for non-urgent notifications

3. **Event Proximity Scaling**
   - More notifications as event approaches
   - Increase urgency in copy closer to date
   - Stop reminders after event passes

### Personalization Strategies

1. **Cultural Affinity**
   - Prioritize notifications for user's preferred cultures
   - Reduce frequency for cultures user hasn't engaged with
   - Introduce new cultures gradually

2. **Engagement History**
   - Users who create gifts get fewer "create" prompts
   - Users who share get more social notifications
   - Inactive users get re-engagement campaigns

3. **Recipient Names**
   - Include recipient names when available
   - "Create a Diwali gift for Mom" > "Create a Diwali gift"

### A/B Testing Recommendations

| Element | Test Variants |
|---------|---------------|
| Title Length | Short (5 words) vs Medium (8 words) |
| Emoji Usage | With emoji vs Without |
| Action Buttons | 1 button vs 2 buttons |
| Personalization | Name included vs Generic |
| Timing | Morning vs Evening |

### Analytics to Track

1. **Delivery Metrics**
   - Delivery rate by device/OS
   - Permission status changes

2. **Engagement Metrics**
   - Open rate by notification type
   - Click-through rate on actions
   - Time to open after delivery

3. **Conversion Metrics**
   - Gift creations from notifications
   - Subscription conversions from alerts
   - Share actions from prompts

4. **Health Metrics**
   - Notification disable rate
   - Complaint rate
   - Re-opt-in rate

---

## Implementation Reference

### Existing Infrastructure

The app uses `CulturalNotificationManager` with these notification types:

```swift
enum NotificationType {
    case preparation      // 7-14 days before
    case weekReminder     // 7 days before
    case dayBefore        // 1 day before
    case celebration      // Day of event
    case giftingReminder  // Optimal gift timing
    case periodicReminder // Weekly engagement
    case personalizedInsight // Cultural learning
}
```

### Priority Levels

```swift
enum NotificationPriority {
    case low      // Insights, promotional
    case medium   // Reminders, prompts
    case high     // Subscription alerts, celebrations
}
```

### User Preferences Storage

Stored in UserDefaults under key `"NotificationPreferences"`:

```swift
struct NotificationPreferences {
    var eventRemindersEnabled: Bool
    var giftPromptsEnabled: Bool
    var subscriptionAlertsEnabled: Bool
    var socialUpdatesEnabled: Bool
    var culturalInsightsEnabled: Bool
    // var watchSyncEnabled: Bool  // Not implemented - Watch sync not available
    var promotionalEnabled: Bool
    var quietHoursStart: Date
    var quietHoursEnd: Date
    var preferredReminderDay: Int
}
```

### Navigation Actions

Notifications can deep-link to:

```swift
// Notification actions
Notification.Name.navigateToGiftCreation
Notification.Name.navigateToSharing
Notification.Name.navigateToCulturalLearning
Notification.Name.navigateToPlanning
```

---

## Revision History

| Date | Version | Changes |
|------|---------|---------|
| January 2026 | 1.0 | Initial notification strategy document |
| January 12, 2026 | 1.1 | Added implementation status, branch info, and merge target. Marked Watch App Sync as not applicable. |

---

## Branch & Merge Information

- **Development Branch:** `Notifications`
- **Merge Target:** `XCode04_Se`
- **Related Documentation:** `NOTIFICATIONS_IMPLEMENTATION_STATUS.md`

When all notification features are implemented and tested, create a pull request to merge into `XCode04_Se`.

---

*This document aligns with the existing `CulturalNotificationManager` infrastructure and supports Forava's mission to help users celebrate cultural moments meaningfully.*
