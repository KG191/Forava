# Eid al-Adha Cultural Expansion Implementation Plan

## Overview
Enhance the existing Forava02 cultural gift system to implement comprehensive Eid al-Adha functionality with 4 sub-themes (Sacrifice, Pilgrimage, Family, Modern), design elements with Centre Pieces, 8 color palettes, 6 optional messages, and the complete workflow from Style through Send.

## Current Status Analysis
- ✅ **Foundation**: Forava02 has stable cultural framework
- ✅ **Eid al-Adha Event**: Already defined in `CulturalEvent.allEvents`
- ✅ **Eid al-Adha Gifts**: 7 Eid al-Adha gifts already exist in `CulturalGiftModel.swift`
- ✅ **Tab System**: 7-tab workflow already implemented in `CulturalGiftDesignView.swift`
- 🟡 **Missing**: Eid al-Adha-specific sub-themes, elements, colors, messages

## Implementation Tasks

### 1. Update Cultural Category Icons
**File**: `ForavaApp/Models/CulturalEvent.swift:46-56`
- Icons already updated with emoji-based system:
  - `islamic`: "🌙" (crescent moon - appropriate for Islamic festivals)

### 2. Create Eid al-Adha Sub-Theme Structure
**New File**: `ForavaApp/Models/EidAlAdhaModels.swift`
- Define `EidAlAdhaTheme` enum: Sacrifice, Pilgrimage, Family, Modern
- Each theme with:
  - Brief description
  - 8 gift options per theme
  - Theme-specific styling properties

### 3. Implement Eid al-Adha Design Elements
**Extend**: `ForavaApp/Models/EidAlAdhaModels.swift`
- Create `EidAlAdhaElement` struct with 4 design elements:
  - **Centre Piece** (takes precedence): Kaaba, Crescent & Star, Mosque, Sheep/Ram
  - **Supporting Elements**: Islamic Calligraphy, Geometric Patterns, Lanterns, Prayer Beads
- Each element with generation priority and AI prompt modifiers

### 4. Define Eid al-Adha Color Palettes
**Extend**: `ForavaApp/Models/EidAlAdhaModels.swift`
- Create 8 Eid al-Adha-specific color palettes:
  - Traditional Islamic (Deep Green, Gold, White)
  - Hajj Colors (Black, Gold, White - representing Kaaba)
  - Desert Sands (Warm Beiges, Gold, Teal)
  - Mosque Blues (Navy Blue, Silver, Light Blue)
  - Crescent Moon (Dark Blue, Silver, White)
  - Royal Islamic (Purple, Gold, Emerald)
  - Modern Minimalist (Black, White, Gold Accent)
  - Warm Celebration (Terracotta, Gold, Cream)

### 5. Create Eid al-Adha Personal Touch System
**Extend**: `ForavaApp/Models/EidAlAdhaModels.swift`
- Define 6 optional Eid al-Adha messages:
  - "عيد أضحى مبارك! Eid al-Adha Mubarak!"
  - "May Allah accept your sacrifices and prayers"
  - "Wishing you blessed Eid al-Adha filled with joy"
  - "May this Eid bring peace and prosperity"
  - "Eid Mubarak! May Allah's blessings be with you"
  - "Celebrating the spirit of sacrifice and devotion"
- Personal message input field with Eid al-Adha-themed placeholder

### 6. Update Style Tab Implementation
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:209-270`
- Modify `StyleTabContent` to show Eid al-Adha sub-themes instead of individual gifts
- Create sub-theme cards showing 4 themes with descriptions
- Each sub-theme leads to 8 gift options grid

### 7. Implement Elements Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:325-356`
- Replace placeholder with Eid al-Adha elements selection
- Show 4 design elements with Centre Piece prominence
- Visual indicators for element hierarchy

### 8. Implement Colour Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:358-389`
- Replace placeholder with 8 Eid al-Adha color palette options
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
- Display temporary dummy Eid al-Adha image placeholder
- Show personal message or optional text below image
- "Watch and Phone Background Ready" indicator

### 12. Implement Send Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:491-523`
- Show same dummy image with contact name
- "Send your personal designer gift to [Contact Name]" button
- "Re-create, for $2" button with subscription integration

## Validation Requirements
- All existing Rakhi functionality must remain intact
- Eid al-Adha implementation must not break other cultural events
- SwiftLint compliance for all new code
- Build successfully with Xcode project integration
- Test Eid al-Adha workflow end-to-end
- Cultural authenticity review by Islamic cultural experts

## Key Files Modified
1. `ForavaApp/Models/CulturalEvent.swift` - Already updated with icons
2. `ForavaApp/Models/EidAlAdhaModels.swift` - New file with all Eid al-Adha-specific models
3. `ForavaApp/Views/CulturalGiftDesignView.swift` - All 7 tabs enhanced for Eid al-Adha
4. Assets - Add dummy Eid al-Adha image placeholder

## Success Criteria
- Eid al-Adha carousel shows 🌙 icon with "Choose an Eid Design Style" title
- Style tab shows 4 sub-themes, each leading to 8 options
- Elements tab shows 4 design elements with Centre Piece priority
- Colour tab shows 8 Eid al-Adha color palettes
- Touch tab shows 6 messages + personal input
- Create tab summarizes selections with generate button
- Check & Send tabs show dummy image with appropriate buttons

## Cultural Significance
Eid al-Adha, the Festival of Sacrifice, is one of the most significant Islamic holidays commemorating Prophet Ibrahim's willingness to sacrifice his son in obedience to Allah. This implementation honors:
- **Religious Elements**: Kaaba, Islamic calligraphy, and sacred symbols
- **Sacrifice Theme**: Commemorating Ibrahim's devotion and obedience
- **Pilgrimage Connection**: Reference to Hajj and Mecca pilgrimage
- **Family Unity**: Emphasis on community, charity, and sharing
- **Cultural Authenticity**: Proper use of Islamic symbols, colors, and Arabic greetings

This plan maintains the existing stable architecture while adding comprehensive Eid al-Adha functionality that respects and celebrates authentic Islamic traditions.

## Eid al-Adha Theme Details

### Sacrifice Theme
- **Description**: "Commemorating Ibrahim's devotion and sacrifice"
- **Gift Options**: 
  - "Ibrahim's Devotion Scene"
  - "Sacrifice Commemoration"
  - "Devotion to Allah Card"
  - "Sacred Sacrifice Story"
  - "Prophet's Obedience"
  - "Divine Test Scene"
  - "Faithful Sacrifice"
  - "Religious Devotion"

### Pilgrimage Theme
- **Description**: "Celebrating Hajj and the journey to Mecca"
- **Gift Options**:
  - "Sacred Kaaba Design"
  - "Hajj Pilgrimage Scene"
  - "Mecca Holy Mosque"
  - "Pilgrims Around Kaaba"
  - "Tawaf Ritual Scene"
  - "Mount Arafat Gathering"
  - "Holy Journey Map"
  - "Pilgrimage Blessing"

### Family Theme
- **Description**: "Celebrating community, charity, and togetherness"
- **Gift Options**:
  - "Family Eid Gathering"
  - "Community Celebration"
  - "Charity & Giving Scene"
  - "Shared Feast Table"
  - "Family Prayer Time"
  - "Eid Gift Exchange"
  - "Community Unity"
  - "Blessed Family Time"

### Modern Theme
- **Description**: "Contemporary Eid with modern artistic elements"
- **Gift Options**:
  - "Modern Islamic Art"
  - "Contemporary Calligraphy"
  - "Geometric Pattern Design"
  - "Minimalist Crescent"
  - "Digital Islamic Art"
  - "Modern Mosque Design"
  - "Stylized Eid Greeting"
  - "Contemporary Islamic Card"