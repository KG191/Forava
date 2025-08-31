# Chinese New Year Cultural Expansion Implementation Plan

## Overview
Enhance the existing Forava02 cultural gift system to implement comprehensive Chinese New Year functionality with 4 sub-themes (Traditional, Zodiac, Prosperity, Modern), design elements with Centre Pieces, 8 color palettes, 6 optional messages, and the complete workflow from Style through Send.

## Current Status Analysis
- ✅ **Foundation**: Forava02 has stable cultural framework
- ✅ **Chinese New Year Event**: Already defined in `CulturalEvent.allEvents`
- ✅ **Chinese New Year Gifts**: 7 Chinese New Year gifts already exist in `CulturalGiftModel.swift`
- ✅ **Tab System**: 7-tab workflow already implemented in `CulturalGiftDesignView.swift`
- 🟡 **Missing**: Chinese New Year-specific sub-themes, elements, colors, messages

## Implementation Tasks

### 1. Update Cultural Category Icons
**File**: `ForavaApp/Models/CulturalEvent.swift:46-56`
- Icons already updated with emoji-based system:
  - `chinese`: "🧧" (red envelope - perfect for Chinese New Year)

### 2. Create Chinese New Year Sub-Theme Structure
**New File**: `ForavaApp/Models/ChineseNewYearModels.swift`
- Define `ChineseNewYearTheme` enum: Traditional, Zodiac, Prosperity, Modern
- Each theme with:
  - Brief description
  - 8 gift options per theme
  - Theme-specific styling properties

### 3. Implement Chinese New Year Design Elements
**Extend**: `ForavaApp/Models/ChineseNewYearModels.swift`
- Create `ChineseNewYearElement` struct with 4 design elements:
  - **Centre Piece** (takes precedence): Dragon, Lion Dance, Lanterns, Fireworks
  - **Supporting Elements**: Plum Blossoms, Gold Coins, Bamboo, Fu Character
- Each element with generation priority and AI prompt modifiers

### 4. Define Chinese New Year Color Palettes
**Extend**: `ForavaApp/Models/ChineseNewYearModels.swift`
- Create 8 Chinese New Year-specific color palettes:
  - Classic Red Gold (Crimson Red, Imperial Gold, Black)
  - Dragon Colors (Deep Red, Gold, Emerald Green)
  - Prosperity Gold (Multiple Gold Shades, Red Accents)
  - Imperial Palace (Royal Red, Yellow Gold, Black)
  - Modern Minimalist (Red, White, Gold Accent)
  - Zodiac Traditional (Earth Tones, Red, Gold)
  - Festive Bright (Bright Red, Electric Gold, White)
  - Elegant Lunar (Deep Red, Rose Gold, Cream)

### 5. Create Chinese New Year Personal Touch System
**Extend**: `ForavaApp/Models/ChineseNewYearModels.swift`
- Define 6 optional Chinese New Year messages:
  - "恭喜發財! Wishing you prosperity and happiness"
  - "May the Year of [Zodiac] bring you good fortune"
  - "新年快樂! Happy New Year filled with joy"
  - "Wishing you health, wealth, and happiness"
  - "May your dreams bloom like plum blossoms"
  - "Sending you luck and prosperity this New Year"
- Personal message input field with Chinese New Year-themed placeholder

### 6. Update Style Tab Implementation
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:209-270`
- Modify `StyleTabContent` to show Chinese New Year sub-themes instead of individual gifts
- Create sub-theme cards showing 4 themes with descriptions
- Each sub-theme leads to 8 gift options grid

### 7. Implement Elements Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:325-356`
- Replace placeholder with Chinese New Year elements selection
- Show 4 design elements with Centre Piece prominence
- Visual indicators for element hierarchy

### 8. Implement Colour Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:358-389`
- Replace placeholder with 8 Chinese New Year color palette options
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
- Display temporary dummy Chinese New Year image placeholder
- Show personal message or optional text below image
- "Watch and Phone Background Ready" indicator

### 12. Implement Send Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:491-523`
- Show same dummy image with contact name
- "Send your personal designer gift to [Contact Name]" button
- "Re-create, for $2" button with subscription integration

## Validation Requirements
- All existing Rakhi functionality must remain intact
- Chinese New Year implementation must not break other cultural events
- SwiftLint compliance for all new code
- Build successfully with Xcode project integration
- Test Chinese New Year workflow end-to-end
- Cultural authenticity review by Chinese cultural experts

## Key Files Modified
1. `ForavaApp/Models/CulturalEvent.swift` - Already updated with icons
2. `ForavaApp/Models/ChineseNewYearModels.swift` - New file with all Chinese New Year-specific models
3. `ForavaApp/Views/CulturalGiftDesignView.swift` - All 7 tabs enhanced for Chinese New Year
4. Assets - Add dummy Chinese New Year image placeholder

## Success Criteria
- Chinese New Year carousel shows 🧧 icon with "Choose a Red Envelope Design Style" title
- Style tab shows 4 sub-themes, each leading to 8 options
- Elements tab shows 4 design elements with Centre Piece priority
- Colour tab shows 8 Chinese New Year color palettes
- Touch tab shows 6 messages + personal input
- Create tab summarizes selections with generate button
- Check & Send tabs show dummy image with appropriate buttons

## Cultural Significance
Chinese New Year represents the most important traditional festival in Chinese culture, marking the beginning of the lunar calendar. This implementation honors:
- **Traditional Elements**: Dragons, lions, lanterns, and classic symbols
- **Zodiac System**: Integration of the 12-year zodiac cycle
- **Prosperity Focus**: Emphasis on wealth, health, and good fortune
- **Family Unity**: Celebration of reunion and ancestral respect
- **Cultural Authenticity**: Proper use of traditional colors, symbols, and greetings

This plan maintains the existing stable architecture while adding comprehensive Chinese New Year functionality that respects and celebrates authentic Chinese traditions.

## Chinese New Year Theme Details

### Traditional Theme
- **Description**: "Classic Chinese New Year with authentic elements"
- **Gift Options**: 
  - "Imperial Dragon Card"
  - "Traditional Lion Dance"
  - "Red Lantern Festival"
  - "Plum Blossom Branch"
  - "Golden Temple Design"
  - "Ancestral Blessing Card"
  - "Classic Calligraphy Style"
  - "Traditional Family Scene"

### Zodiac Theme
- **Description**: "Celebrating the current zodiac animal year"
- **Gift Options**:
  - "Year of the Dragon"
  - "Zodiac Animal Portrait"
  - "12 Animals Circle"
  - "Zodiac Compatibility Card"
  - "Animal Characteristics"
  - "Zodiac Calendar Design"
  - "Lucky Animal Symbols"
  - "Zodiac Fortune Card"

### Prosperity Theme
- **Description**: "Focus on wealth, luck, and good fortune"
- **Gift Options**:
  - "Gold Coins Rain"
  - "Fortune Tree Design"
  - "Lucky Bamboo Card"
  - "Wealth God Blessing"
  - "Golden Ingots Scene"
  - "Prosperity Characters"
  - "Money Tree Branches"
  - "Abundance Symbols"

### Modern Theme
- **Description**: "Contemporary Chinese New Year with modern twist"
- **Gift Options**:
  - "Digital Dragon Art"
  - "Modern Red Envelope"
  - "Contemporary Lanterns"
  - "Urban Celebration"
  - "Minimalist CNY Design"
  - "Tech-Style Fireworks"
  - "Modern Calligraphy"
  - "Digital Prosperity Card"