# Rosh Hashanah Cultural Expansion Implementation Plan

## Overview
Enhance the existing Forava02 cultural gift system to implement comprehensive Rosh Hashanah functionality with 4 sub-themes (Traditional, Renewal, Family, Modern), design elements with Centre Pieces, 8 color palettes, 6 optional messages, and the complete workflow from Style through Send.

## Current Status Analysis
- ✅ **Foundation**: Forava02 has stable cultural framework
- ✅ **Rosh Hashanah Event**: Already defined in `CulturalEvent.allEvents`
- ✅ **Rosh Hashanah Gifts**: 7 Rosh Hashanah gifts already exist in `CulturalGiftModel.swift`
- ✅ **Tab System**: 7-tab workflow already implemented in `CulturalGiftDesignView.swift`
- 🟡 **Missing**: Rosh Hashanah-specific sub-themes, elements, colors, messages

## Implementation Tasks

### 1. Update Cultural Category Icons
**File**: `ForavaApp/Models/CulturalEvent.swift:46-56`
- Icons already updated with emoji-based system:
  - `jewish`: "✡️" (Star of David - appropriate for Jewish festivals)

### 2. Create Rosh Hashanah Sub-Theme Structure
**New File**: `ForavaApp/Models/RoshHashanahModels.swift`
- Define `RoshHashanahTheme` enum: Traditional, Renewal, Family, Modern
- Each theme with:
  - Brief description
  - 8 gift options per theme
  - Theme-specific styling properties

### 3. Implement Rosh Hashanah Design Elements
**Extend**: `ForavaApp/Models/RoshHashanahModels.swift`
- Create `RoshHashanahElement` struct with 4 design elements:
  - **Centre Piece** (takes precedence): Shofar, Apples & Honey, Star of David, Torah Scroll
  - **Supporting Elements**: Pomegranates, Challah Bread, Hebrew Calligraphy, New Year Symbols
- Each element with generation priority and AI prompt modifiers

### 4. Define Rosh Hashanah Color Palettes
**Extend**: `ForavaApp/Models/RoshHashanahModels.swift`
- Create 8 Rosh Hashanah-specific color palettes:
  - Traditional Blue Gold (Royal Blue, Gold, White)
  - Apple Honey (Red Apple, Golden Honey, Cream)
  - Shofar Natural (Horn Brown, Gold, Beige)
  - Pomegranate Rich (Deep Red, Gold, Burgundy)
  - New Year Fresh (White, Gold, Light Blue)
  - Synagogue Royal (Deep Blue, Silver, White)
  - Modern Minimalist (Black, White, Blue Accent)
  - Warm Blessing (Gold, Warm Brown, Ivory)

### 5. Create Rosh Hashanah Personal Touch System
**Extend**: `ForavaApp/Models/RoshHashanahModels.swift`
- Define 6 optional Rosh Hashanah messages:
  - "שנה טובה! Wishing you a sweet and blessed New Year"
  - "May you be inscribed in the Book of Life"
  - "L'Shanah Tovah! May this year bring peace and joy"
  - "Wishing you apples and honey for a sweet year"
  - "May your prayers be answered this New Year"
  - "Sending blessings for health, happiness, and prosperity"
- Personal message input field with Rosh Hashanah-themed placeholder

### 6. Update Style Tab Implementation
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:209-270`
- Modify `StyleTabContent` to show Rosh Hashanah sub-themes instead of individual gifts
- Create sub-theme cards showing 4 themes with descriptions
- Each sub-theme leads to 8 gift options grid

### 7. Implement Elements Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:325-356`
- Replace placeholder with Rosh Hashanah elements selection
- Show 4 design elements with Centre Piece prominence
- Visual indicators for element hierarchy

### 8. Implement Colour Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:358-389`
- Replace placeholder with 8 Rosh Hashanah color palette options
- Color swatch previews with palette names
- Selection state management

### 9. Implement Touch Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:391-422`
- Replace placeholder with 6 optional message buttons
- Personal message text field
- Character limit and validation

### 10. Implement Create Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:424-455`
- Show summary of selections (Style, Elements, Colour, Personal Touch)
- "Generate your personal designer gift" button
- Selection validation before generation

### 11. Implement Check Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:457-489`
- Display temporary dummy Rosh Hashanah image placeholder
- Show personal message or optional text below image
- "Watch and Phone Background Ready" indicator

### 12. Implement Send Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:491-523`
- Show same dummy image with contact name
- "Send your personal designer gift to [Contact Name]" button
- "Re-create, for $2" button with subscription integration

## Validation Requirements
- All existing Rakhi functionality must remain intact
- Rosh Hashanah implementation must not break other cultural events
- SwiftLint compliance for all new code
- Build successfully with Xcode project integration
- Test Rosh Hashanah workflow end-to-end
- Cultural authenticity review by Jewish cultural experts

## Key Files Modified
1. `ForavaApp/Models/CulturalEvent.swift` - Already updated with icons
2. `ForavaApp/Models/RoshHashanahModels.swift` - New file with all Rosh Hashanah-specific models
3. `ForavaApp/Views/CulturalGiftDesignView.swift` - All 7 tabs enhanced for Rosh Hashanah
4. Assets - Add dummy Rosh Hashanah image placeholder

## Success Criteria
- Rosh Hashanah carousel shows ✡️ icon with "Choose a New Year Blessing Style" title
- Style tab shows 4 sub-themes, each leading to 8 options
- Elements tab shows 4 design elements with Centre Piece priority
- Colour tab shows 8 Rosh Hashanah color palettes
- Touch tab shows 6 messages + personal input
- Create tab summarizes selections with generate button
- Check & Send tabs show dummy image with appropriate buttons

## Cultural Significance
Rosh Hashanah, the Jewish New Year, marks the beginning of the High Holy Days and is a time for reflection, renewal, and spiritual preparation. This implementation honors:
- **New Beginning**: Celebration of the new year and fresh starts
- **Spiritual Reflection**: Time for introspection and self-examination
- **Divine Judgment**: The belief in being inscribed in the Book of Life
- **Sweet Traditions**: Apples and honey for a sweet year ahead
- **Cultural Authenticity**: Proper use of Hebrew, traditional symbols, and meaningful rituals

This plan maintains the existing stable architecture while adding comprehensive Rosh Hashanah functionality that respects and celebrates authentic Jewish traditions.

## Rosh Hashanah Theme Details

### Traditional Theme
- **Description**: "Classic Rosh Hashanah with authentic religious elements"
- **Gift Options**: 
  - "Traditional Shofar Blessing"
  - "Apples & Honey Tradition"
  - "Sacred Torah Reading"
  - "Synagogue New Year"
  - "Traditional Prayer Scene"
  - "Religious Blessing Card"
  - "Classic Holiday Table"
  - "Traditional Family Gathering"

### Renewal Theme
- **Description**: "Spiritual renewal and fresh beginnings"
- **Gift Options**:
  - "New Year Reflection"
  - "Spiritual Renewal Card"
  - "Fresh Start Blessing"
  - "Book of Life Entry"
  - "Teshuvah Journey"
  - "Soul Cleansing Theme"
  - "New Beginning Path"
  - "Renewal Prayer Scene"

### Family Theme
- **Description**: "Family traditions and generational celebration"
- **Gift Options**:
  - "Family Holiday Table"
  - "Generations Together"
  - "Family Blessing Scene"
  - "Holiday Dinner Gathering"
  - "Children's New Year"
  - "Family Tradition Card"
  - "Multi-Generation Celebration"
  - "Family Unity Blessing"

### Modern Theme
- **Description**: "Contemporary Rosh Hashanah with modern elements"
- **Gift Options**:
  - "Modern Shofar Art"
  - "Contemporary Jewish Design"
  - "Minimalist New Year"
  - "Urban Synagogue Scene"
  - "Modern Hebrew Typography"
  - "Stylized Star of David"
  - "Contemporary Holiday Card"
  - "Modern Jewish Art"