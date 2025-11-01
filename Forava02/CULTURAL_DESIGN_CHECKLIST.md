# Cultural Design Implementation Checklist

## 🎯 Purpose
This checklist ensures complete and consistent implementation of new cultural designs in the Forava app.

## ⚠️ CRITICAL: Single Source of Truth
**ALL cultural routing must be added to `CulturalGiftDesignView.swift`**
- DO NOT modify `TempCulturalGiftDesignView` (deprecated)
- The app now uses `CulturalGiftDesignView` as the single routing source

## 📋 Implementation Steps

When adding a new cultural design (e.g., "Christmas", "Eid", etc.), follow these steps:

### 1. Models Layer
- [ ] Create `[Culture]Models.swift` in `ForavaApp/Models/`
  - [ ] Define `[Culture]Theme` enum (4+ themes)
  - [ ] Define `[Culture]Element` struct (8+ elements)
  - [ ] Define `[Culture]ColorPalette` struct (8+ palettes)
  - [ ] Define `[Culture]PersonalTouch` enum (6+ message tones)
  - [ ] Add `all[Elements/Palettes/Touches]` static collections

### 2. AI Service Layer
- [ ] Create `[Culture]AIService.swift` in `ForavaApp/Services/`
  - [ ] Extend `BaseCulturalAIService`
  - [ ] Implement `CulturalAIServiceProtocol`
  - [ ] Add DALL-E 3 primary generation
  - [ ] Add SDXL fallback support
  - [ ] Create 16+ alternative natural language prompts (4 themes × 4 elements)
  - [ ] Add cultural authenticity validation

### 3. View Layer - Create 7 View Files
Create in `ForavaApp/Views/CulturalDesigns/[Culture]/`:

- [ ] `[Culture]StyleSelectionView.swift` - Theme selection
- [ ] `[Culture]ElementsSelectionView.swift` - Element selection
- [ ] `[Culture]ColorPaletteView.swift` - Color palette selection
- [ ] `[Culture]PersonalTouchView.swift` - Message customization
- [ ] `[Culture]CreateSummaryView.swift` - Review and generate
- [ ] `[Culture]CheckImageView.swift` - Image preview and regenerate
- [ ] `[Culture]SendShareView.swift` - Share and send options

### 4. Main Design Coordinator
- [ ] Create `[Culture]DesignView.swift` in `ForavaApp/Views/CulturalDesigns/[Culture]/`
  - [ ] Implement `CulturalDesignViewProtocol`
  - [ ] Set up tab navigation with `GiftDesignTab`
  - [ ] Configure state management (@State properties)
  - [ ] Add AI service integration (@StateObject)
  - [ ] Implement generation logic

### 5. 🎯 CRITICAL: Add Routing (Single Source of Truth)
- [ ] **Update `CulturalGiftDesignView.swift`** (line ~17)
  ```swift
  case "[culture name]":
      [Culture]DesignView(selectedContact: selectedContact, selectedEvent: selectedEvent)
  ```
- [ ] ⚠️ DO NOT modify `TempCulturalGiftDesignView` (deprecated)

### 6. Cultural Event Registration
- [ ] Verify culture exists in `CulturalEvent.allEvents` in `ForavaApp/Models/CulturalEvent.swift`
- [ ] Ensure event name matches routing case (case-insensitive)

### 7. Xcode Project Integration
- [ ] Add all new files to Xcode project
- [ ] Verify target membership (ForavaApp)
- [ ] Check file organization in Project Navigator

### 8. Testing & Validation
- [ ] Build project: `xcodebuild -project Forava.xcodeproj -scheme ForavaApp build`
- [ ] Run SwiftLint: `/opt/homebrew/bin/swiftlint lint`
- [ ] Test in Simulator:
  - [ ] Navigate to cultural event
  - [ ] Verify all 7 tabs appear
  - [ ] Select options in each tab
  - [ ] Generate image
  - [ ] Verify image preview
  - [ ] Test share functionality
- [ ] Verify Rakhi still works (backward compatibility)

### 9. Git & Documentation
- [ ] Commit changes with descriptive message
- [ ] Push to GitHub
- [ ] Update CLAUDE.md if architectural changes made

## 🔍 Common Issues & Solutions

### Issue: Tabs not showing, seeing "Coming Soon" message
**Cause:** Routing not added to `CulturalGiftDesignView.swift`
**Solution:** Add case to switch statement in `CulturalGiftDesignView.swift` (see Step 5)

### Issue: "Creating [Culture] Gift Cultural Design Studio" placeholder
**Cause:** Event name mismatch between `CulturalEvent.allEvents` and routing case
**Solution:** Ensure case-insensitive match: `case "vesak day":` matches `name: "Vesak Day"`

### Issue: Build errors about missing protocol methods
**Cause:** Incomplete `CulturalDesignViewProtocol` implementation
**Solution:** Implement all 7 required ViewBuilder methods in `[Culture]DesignView`

### Issue: Image generation fails
**Cause:** Missing AI service or incorrect protocol implementation
**Solution:** Verify `[Culture]AIService` extends `BaseCulturalAIService` and implements all required methods

## 📊 Cultural Design Status

| Culture | Models | AI Service | Views (7) | Routing | Status |
|---------|--------|------------|-----------|---------|--------|
| Anniversary | ✅ | ✅ | ✅ | ✅ | Complete |
| Chinese New Year | ✅ | ✅ | ✅ | ✅ | Complete |
| Diwali | ✅ | ✅ | ✅ | ✅ | Complete |
| Vesak Day | ✅ | ✅ | ✅ | ✅ | Complete |
| Christmas | ⏳ | ⏳ | ⏳ | ⏳ | Pending |
| Easter | ⏳ | ⏳ | ⏳ | ⏳ | Pending |
| Eid al-Fitr | ⏳ | ⏳ | ⏳ | ⏳ | Pending |
| Eid al-Adha | ⏳ | ⏳ | ⏳ | ⏳ | Pending |
| Hanukkah | ⏳ | ⏳ | ⏳ | ⏳ | Pending |
| Rosh Hashanah | ⏳ | ⏳ | ⏳ | ⏳ | Pending |
| Mid-Autumn Festival | ⏳ | ⏳ | ⏳ | ⏳ | Pending |
| Raksha Bandhan | ⏳ | ⏳ | ⏳ | ⏳ | Pending |

## 🎨 Cultural Design Examples

### Reference Implementations
Use these as templates for new cultures:
- **Most Complete**: Chinese New Year (`ChineseNewYear*` files)
- **Buddhist Example**: Vesak Day (`VesakDay*` files)
- **Hindu Example**: Diwali (`Diwali*` files)

## ⚠️ Architecture Reminders

1. **Single Routing Source**: Only update `CulturalGiftDesignView.swift`
2. **Protocol Conformance**: All design views must implement `CulturalDesignViewProtocol`
3. **Modular Components**: Use shared UI components from `CulturalDesignComponents.swift`
4. **One-at-a-Time**: Complete and test each culture before starting the next
5. **Backward Compatibility**: Existing cultures must continue to work after changes

## 📝 Version History

- **2025-11-01**: Created checklist after Vesak Day routing issue
  - Documented single source of truth for routing
  - Deprecated `TempCulturalGiftDesignView`
  - Established clear implementation steps
