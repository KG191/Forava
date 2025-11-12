# Landing Page Redesign & Culture Selection Implementation Plan
**Branch:** XCode04_Se
**Status:** Planning Phase - Implementation Not Started
**Created:** November 12, 2025

---

## Overview
Redesign the app to show a welcome screen on first launch, require culture selection in Settings, and only load selected cultures to resolve lag issues.

## User Requirements (Confirmed)
- ✅ Infinity loop animation: Continuous gentle blink (heartbeat style)
- ✅ Culture selection: Multiple cultures via checkboxes
- ✅ First launch behavior: Force Settings first (must select cultures)
- ✅ Quick access: "View All Cultures" button on carousel

---

## Phase 1: User Preferences Infrastructure

### 1.1 Create CulturePreferencesManager
**File:** `ForavaApp/Utils/CulturePreferencesManager.swift`

```swift
import Foundation
import SwiftUI

class CulturePreferencesManager: ObservableObject {
    @AppStorage("selectedCultureIDs") private var selectedCultureIDsData: Data = Data()
    @AppStorage("hasCompletedOnboarding") var hasCompletedOnboarding: Bool = false

    @Published var selectedCultureIDs: Set<String> = []

    init() {
        loadCultures()
    }

    func saveCultures() {
        if let encoded = try? JSONEncoder().encode(selectedCultureIDs) {
            selectedCultureIDsData = encoded
        }
    }

    func loadCultures() {
        if let decoded = try? JSONDecoder().decode(Set<String>.self, from: selectedCultureIDsData) {
            selectedCultureIDs = decoded
        }
    }

    func isFirstLaunch() -> Bool {
        return !hasCompletedOnboarding
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
    }
}
```

### 1.2 Update CulturalEvent Model
**File:** `ForavaApp/Models/CulturalEvent.swift`

Add helper method:
```swift
extension CulturalEvent {
    static func filtered(by categoryIDs: Set<String>) -> [CulturalEvent] {
        guard !categoryIDs.isEmpty else { return [] }
        return allEvents.filter { categoryIDs.contains($0.id.uuidString) }
    }
}
```

---

## Phase 2: New Welcome Screen

### 2.1 Create WelcomeView
**File:** `ForavaApp/Views/WelcomeView.swift`

Layout structure (top to bottom):
1. "Forava" title (near top, 48pt serif font)
2. "Connect with Loved Ones..." subtitle
3. Infinity loop icon (center, ~200pt, animated)
4. "Go to Settings to get started" text (fades in after 1s)
5. Settings button (top-right corner)

Background: Reuse gradient from ContentView

### 2.2 Create InfinityLoopView Component
**File:** `ForavaApp/Views/Components/InfinityLoopView.swift`

```swift
import SwiftUI

struct InfinityLoopView: View {
    @State private var isAnimating = false

    var body: some View {
        Image("AppIcon-1024x1024@1x")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200)
            .scaleEffect(isAnimating ? 1.05 : 1.0)
            .animation(
                Animation.easeInOut(duration: 2.0)
                    .repeatForever(autoreverses: true),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}
```

Animation specs:
- Scale: 1.0 → 1.05 → 1.0
- Duration: 2 seconds
- Easing: `.easeInOut`
- Repeat: Forever with autoreverse

---

## Phase 3: Settings Culture Selection

### 3.1 Add "My Cultures" Section to SettingsView
**File:** `ForavaApp/Views/SettingsView.swift`

Insert at top of List (before Notifications):

```swift
// My Cultures Section
Section {
    cultureSelectionSection
} header: {
    Text("My Cultures")
} footer: {
    Text("Select all cultures you want to see. You can change this anytime.")
}
```

### 3.2 Culture Selection UI

Group by `CulturalCategory` for better organization:

```
Universal (1)
  ☑ Anniversary

Hindu (3)
  ☑ Diwali
  ☐ Holi
  ☐ Raksha Bandhan

Chinese (2)
  ☑ Chinese New Year
  ☐ Mid-Autumn Festival

Christian (2)
  ☐ Christmas
  ☐ Easter

Islamic (1)
  ☐ Eid al-Adha

Jewish (2)
  ☐ Hanukkah
  ☐ Rosh Hashanah

Buddhist (1)
  ☐ Vesak Day
```

### 3.3 Glass Morphism Selection Animation

On checkbox tap:
- Row scales to 1.05x with spring animation
- Checkmark appears with slide-in animation
- Background: `.ultraThinMaterial` with cultural color tint (0.08 opacity)

### 3.4 Validation Rules

- **Minimum:** At least 1 culture must be selected
- **Alert:** Show warning if user tries to deselect all
- **First Launch:** "Done" button disabled until ≥1 culture selected
- **After Onboarding:** Can freely toggle cultures

---

## Phase 4: Navigation Flow Updates

### 4.1 Update App.swift Entry Point
**File:** `ForavaApp/App.swift`

```swift
@main
struct ForavaApp: App {
    @StateObject private var preferences = CulturePreferencesManager()

    var body: some Scene {
        WindowGroup {
            if preferences.isFirstLaunch() {
                WelcomeView()
                    .environmentObject(preferences)
            } else {
                ContentView()
                    .environmentObject(preferences)
            }
        }
    }
}
```

### 4.2 Navigation States

**State 1: First Launch (Onboarding)**
```
WelcomeView (blinking infinity loop)
  ↓ [tap Settings button]
SettingsView (full-screen, not sheet)
  ↓ [select cultures, tap Done]
ContentView (filtered carousel)
  ↓ [preferences.completeOnboarding() called]
```

**State 2: After Onboarding**
```
ContentView (app opens here directly)
  ↓ [optional: tap Settings button]
SettingsView (sheet presentation)
  ↓ [modify cultures, dismiss]
ContentView (carousel updates with new filters)
```

### 4.3 Settings Button Behavior

- **From WelcomeView:** Navigate to full-screen SettingsView (required)
- **From ContentView:** Present SettingsView as sheet (optional)
- **First Launch Done Button:** Calls `preferences.completeOnboarding()`, navigates to ContentView
- **Regular Done Button:** Dismisses sheet

---

## Phase 5: Carousel Filtering

### 5.1 Update CulturalCarouselView
**File:** `ForavaApp/Views/CulturalCarouselView.swift`

Add parameters:
```swift
struct CulturalCarouselView: View {
    @EnvironmentObject var preferences: CulturePreferencesManager
    @Binding var showAllCultures: Bool

    var displayedEvents: [CulturalEvent] {
        if showAllCultures {
            return CulturalEvent.allEvents
        } else {
            return CulturalEvent.filtered(by: preferences.selectedCultureIDs)
        }
    }

    var body: some View {
        // Use displayedEvents instead of CulturalEvent.allEvents
    }
}
```

### 5.2 Performance Optimization

Replace `HStack` with `LazyHStack`:
```swift
ScrollView(.horizontal, showsIndicators: false) {
    LazyHStack(spacing: 15) {
        ForEach(displayedEvents) { event in
            CulturalEventCard(event: event, isSelected: selectedEvent?.id == event.id)
                .onTapGesture {
                    // Selection logic
                }
        }
    }
}
```

Benefits:
- Only loads images for visible cards
- Defers loading until card scrolls into view
- Significantly reduces initial memory usage

### 5.3 Empty State

If `displayedEvents.isEmpty`:
```swift
VStack(spacing: 16) {
    Image(systemName: "square.grid.3x3")
        .font(.system(size: 60))
        .foregroundStyle(.orange.opacity(0.5))

    Text("No Cultures Selected")
        .font(.title3.weight(.semibold))

    Text("Go to Settings to choose which cultures you want to see")
        .font(.subheadline)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)

    Button("Open Settings") {
        // Present SettingsView
    }
    .buttonStyle(.borderedProminent)
}
```

---

## Phase 6: "View All Cultures" Feature

### 6.1 Add Toggle Button to ContentView
**File:** `ForavaApp/Views/ContentView.swift`

Below carousel:
```swift
Button(action: {
    showAllCultures.toggle()
}) {
    HStack {
        Image(systemName: showAllCultures ? "checkmark.circle.fill" : "square.grid.3x3.fill")
            .font(.headline)

        Text(showAllCultures ? "View My Cultures" : "View All Cultures")
            .font(.system(.subheadline, design: .rounded).weight(.semibold))
    }
    .padding(.horizontal, 20)
    .padding(.vertical, 12)
    .background(
        RoundedRectangle(cornerRadius: 10)
            .fill(.ultraThinMaterial)
    )
    .overlay(
        RoundedRectangle(cornerRadius: 10)
            .strokeBorder(Color.orange, lineWidth: 1.5)
    )
}
.padding(.top, 8)
```

### 6.2 Visual Indicator Banner

When `showAllCultures == true`, show badge above carousel:
```swift
if showAllCultures {
    HStack {
        Image(systemName: "eye")
        Text("Showing all 12 cultures")
            .font(.caption.weight(.medium))
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 6)
    .background(
        Capsule()
            .fill(Color.orange.opacity(0.15))
    )
    .foregroundStyle(.orange)
}
```

---

## Implementation Files Summary

### New Files (3)
1. ✅ `ForavaApp/Utils/CulturePreferencesManager.swift` - Preferences storage & management
2. ✅ `ForavaApp/Views/WelcomeView.swift` - New landing/onboarding screen
3. ✅ `ForavaApp/Views/Components/InfinityLoopView.swift` - Reusable animated infinity symbol

### Modified Files (5)
1. ✅ `ForavaApp/App.swift` - Add onboarding check, inject CulturePreferencesManager
2. ✅ `ForavaApp/ContentView.swift` - Add "View All" toggle, pass filtered events to carousel
3. ✅ `ForavaApp/Views/SettingsView.swift` - Add "My Cultures" section with checkboxes
4. ✅ `ForavaApp/Views/CulturalCarouselView.swift` - Support filtered events, lazy loading
5. ✅ `ForavaApp/Models/CulturalEvent.swift` - Add `filtered()` helper method

---

## Expected Performance Impact

### Current (XCode03_All Branch)
- **Startup Time:** 2.5s total
- **Images Loaded:** All 12 culture PNGs simultaneously
- **Memory Usage:** ~15-20MB for all images
- **User Experience:** Slight delay before carousel interactive

### After Implementation (XCode04_Se Branch)
- **Startup Time:** 0.5-1s (if 3-4 cultures selected)
- **Images Loaded:** Only selected cultures (lazy)
- **Memory Usage:** ~5-8MB for 3-4 cultures
- **User Experience:** Instant carousel interaction

### Performance Gain
- ⚡ **60-80% faster** initial load for typical user (3-4 cultures)
- 📉 **65-75% less memory** usage
- 🎯 **100% responsive** - no loading lag

---

## Testing Checklist

### Onboarding Flow
- [ ] First launch shows WelcomeView with blinking infinity loop
- [ ] "Go to Settings to get started" text appears after 1s
- [ ] Tapping Settings button navigates to full-screen SettingsView
- [ ] Cannot dismiss Settings without selecting ≥1 culture
- [ ] Selecting cultures shows glass morphism animation
- [ ] Tapping "Done" completes onboarding and shows ContentView

### Carousel Filtering
- [ ] Carousel shows only selected cultures after onboarding
- [ ] Page indicators reflect correct number of filtered cultures
- [ ] Selected event text updates correctly
- [ ] "Create a [Event] Gift" button shows correct event name
- [ ] Empty state appears if no cultures selected

### "View All Cultures" Feature
- [ ] Toggle button shows "View All Cultures" by default
- [ ] Tapping button shows all 12 cultures with badge
- [ ] Badge displays "Showing all 12 cultures"
- [ ] Toggle button updates to "View My Cultures"
- [ ] Tapping again returns to filtered view

### Settings Management
- [ ] Opening Settings from ContentView shows as sheet
- [ ] Culture checkboxes reflect saved preferences
- [ ] Changing selections updates carousel immediately
- [ ] Cannot deselect all cultures (shows alert)
- [ ] Settings changes persist across app restarts

### Performance
- [ ] Carousel loads quickly with fewer cultures
- [ ] No lag when scrolling carousel
- [ ] Images load smoothly (lazy loading works)
- [ ] App launches faster than v03 with filtered cultures
- [ ] Memory usage lower with fewer loaded images

### Edge Cases
- [ ] Handles user deleting all preferences (shows WelcomeView)
- [ ] Handles rapid culture selection changes
- [ ] Handles app backgrounding during onboarding
- [ ] Settings "Done" button works in both contexts (onboarding vs regular)

---

## Implementation Order

1. **Phase 1** - Infrastructure (preferences manager, model updates)
2. **Phase 2** - WelcomeView + InfinityLoopView (onboarding UI)
3. **Phase 3** - Settings culture selection (UI + validation)
4. **Phase 4** - Navigation flow (App.swift, routing logic)
5. **Phase 5** - Carousel filtering (performance optimization)
6. **Phase 6** - "View All" feature (convenience feature)

**Estimated Time:** 3-4 hours for complete implementation + testing

---

## Notes & Considerations

### Design Decisions
- Used checkboxes instead of dropdown for better UX (see all options at once)
- Grouped cultures by category for easier browsing
- Forced Settings on first launch to ensure user makes conscious choice
- Added "View All" as safety net if user wants to explore

### Performance Strategy
- Lazy loading prevents loading all images upfront
- Filtering reduces number of views in hierarchy
- Only selected cultures rendered in carousel
- Images cached after first load (existing behavior maintained)

### Future Enhancements (Not in Current Scope)
- [ ] Smart suggestions based on device locale/calendar
- [ ] "Favorite" vs "Show" distinction (favorites appear first)
- [ ] Analytics to track most popular culture combinations
- [ ] Seasonal prompts ("Diwali is coming soon, add it?")

---

## Status: READY FOR IMPLEMENTATION
⏸️ **Awaiting user approval to begin implementation**

When approved, implementation will proceed in order through Phases 1-6.
