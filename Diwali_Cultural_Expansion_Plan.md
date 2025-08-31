# Diwali Cultural Expansion Implementation Plan

## Overview
Enhance the existing Forava02 cultural gift system to implement comprehensive Diwali functionality with 4 sub-themes (Traditional, Rangoli, Lakshmi, Modern), design elements with Centre Pieces, 8 color palettes, 6 optional messages, and the complete workflow from Style through Send.

## Current Status Analysis
- ✅ **Foundation**: Forava02 has stable cultural framework
- ✅ **Diwali Event**: Already defined in `CulturalEvent.allEvents`
- ✅ **Diwali Gifts**: 7 Diwali gifts already exist in `CulturalGiftModel.swift`
- ✅ **Tab System**: 7-tab workflow already implemented in `CulturalGiftDesignView.swift`
- 🟡 **Missing**: Diwali-specific sub-themes, elements, colors, messages

## Implementation Tasks

### 1. Update Cultural Category Icons
**File**: `ForavaApp/Models/CulturalEvent.swift:46-56`
- Icons already updated with emoji-based system:
  - `hindu`: "🪢" (appropriate for Hindu festivals including Diwali)

### 2. Create Diwali Sub-Theme Structure
**New File**: `ForavaApp/Models/DiwaliModels.swift`
- Define `DiwaliTheme` enum: Traditional, Rangoli, Lakshmi, Modern
- Each theme with:
  - Brief description
  - 8 gift options per theme
  - Theme-specific styling properties

### 3. Implement Diwali Design Elements
**Extend**: `ForavaApp/Models/DiwaliModels.swift`
- Create `DiwaliElement` struct with 4 design elements:
  - **Centre Piece** (takes precedence): Diya (Oil Lamp), Lotus, Lakshmi, Fireworks
  - **Supporting Elements**: Rangoli Patterns, Marigold Flowers, Om Symbol, Gold Coins
- Each element with generation priority and AI prompt modifiers

### 4. Define Diwali Color Palettes
**Extend**: `ForavaApp/Models/DiwaliModels.swift`
- Create 8 Diwali-specific color palettes:
  - Classic Diwali (Deep Orange, Gold, Purple)
  - Golden Prosperity (Multiple Gold Shades, Orange Accents)
  - Lakshmi Blessings (Rich Purple, Gold, Deep Pink)
  - Rangoli Colors (Bright Multi-colors, White Base)
  - Royal Elegance (Deep Purple, Rose Gold, Cream)
  - Traditional Festival (Saffron, Red, Gold)
  - Modern Minimalist (Black, Gold, Orange Accent)
  - Warm Celebration (Warm Orange, Copper, Ivory)

### 5. Create Diwali Personal Touch System
**Extend**: `ForavaApp/Models/DiwaliModels.swift`
- Define 6 optional Diwali messages:
  - "दीपावली की हार्दिक शुभकामनाएं! Happy Diwali!"
  - "May Goddess Lakshmi bless you with prosperity"
  - "Wishing you light, love, and happiness this Diwali"
  - "May the festival of lights brighten your life"
  - "शुभ दीपावली! May joy illuminate your path"
  - "Celebrating the victory of light over darkness"
- Personal message input field with Diwali-themed placeholder

### 6. Update Style Tab Implementation
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:209-270`
- Modify `StyleTabContent` to show Diwali sub-themes instead of individual gifts
- Create sub-theme cards showing 4 themes with descriptions
- Each sub-theme leads to 8 gift options grid

### 7. Implement Elements Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:325-356`
- Replace placeholder with Diwali elements selection
- Show 4 design elements with Centre Piece prominence
- Visual indicators for element hierarchy

### 8. Implement Colour Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:358-389`
- Replace placeholder with 8 Diwali color palette options
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
- Display temporary dummy Diwali image placeholder
- Show personal message or optional text below image
- "Watch and Phone Background Ready" indicator

### 12. Implement Send Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:491-523`
- Show same dummy image with contact name
- "Send your personal designer gift to [Contact Name]" button
- "Re-create, for $2" button with subscription integration

## Validation Requirements
- All existing Rakhi functionality must remain intact
- Diwali implementation must not break other cultural events
- SwiftLint compliance for all new code
- Build successfully with Xcode project integration
- Test Diwali workflow end-to-end
- Cultural authenticity review by Hindu cultural experts

## Key Files Modified
1. `ForavaApp/Models/CulturalEvent.swift` - Already updated with icons
2. `ForavaApp/Models/DiwaliModels.swift` - New file with all Diwali-specific models
3. `ForavaApp/Views/CulturalGiftDesignView.swift` - All 7 tabs enhanced for Diwali
4. Assets - Add dummy Diwali image placeholder

## Success Criteria
- Diwali carousel shows 🪢 icon with "Choose a Diya Design Style" title
- Style tab shows 4 sub-themes, each leading to 8 options
- Elements tab shows 4 design elements with Centre Piece priority
- Colour tab shows 8 Diwali color palettes
- Touch tab shows 6 messages + personal input
- Create tab summarizes selections with generate button
- Check & Send tabs show dummy image with appropriate buttons

## Cultural Significance
Diwali, the Festival of Lights, is one of the most important Hindu festivals celebrating the victory of light over darkness, good over evil, and knowledge over ignorance. This implementation honors:
- **Traditional Elements**: Diyas, rangoli, Lakshmi worship, and classic symbols
- **Spiritual Significance**: Focus on prosperity, wisdom, and divine blessings
- **Family Unity**: Celebration of togetherness and shared traditions
- **Light Symbolism**: Emphasis on illumination, hope, and positivity
- **Cultural Authenticity**: Proper use of traditional colors, symbols, and Sanskrit/Hindi greetings

This plan maintains the existing stable architecture while adding comprehensive Diwali functionality that respects and celebrates authentic Hindu traditions.

## Diwali Theme Details

### Traditional Theme
- **Description**: "Classic Diwali with authentic religious elements"
- **Gift Options**: 
  - "Golden Diya Array"
  - "Traditional Lakshmi Puja"
  - "Sacred Om Design"
  - "Temple Lights Scene"
  - "Religious Blessing Card"
  - "Traditional Family Puja"
  - "Sanskrit Mantra Design"
  - "Classical Festival Scene"

### Rangoli Theme
- **Description**: "Beautiful floor art patterns and designs"
- **Gift Options**:
  - "Geometric Rangoli Pattern"
  - "Floral Rangoli Design"
  - "Peacock Rangoli Art"
  - "Mandala Rangoli Circle"
  - "Traditional Kolam Pattern"
  - "Colorful Rangoli Border"
  - "Sacred Symbol Rangoli"
  - "Festival Floor Art"

### Lakshmi Theme
- **Description**: "Celebrating the goddess of wealth and prosperity"
- **Gift Options**:
  - "Goddess Lakshmi Portrait"
  - "Lakshmi Pada (Footprints)"
  - "Golden Lotus Throne"
  - "Prosperity Blessing Card"
  - "Wealth Goddess Scene"
  - "Lakshmi Puja Setup"
  - "Divine Blessing Design"
  - "Prosperity Mandala"

### Modern Theme
- **Description**: "Contemporary Diwali with modern artistic elements"
- **Gift Options**:
  - "Modern Diya Arrangement"
  - "Contemporary Rangoli"
  - "Urban Diwali Lights"
  - "Minimalist Festival Card"
  - "Digital Art Lakshmi"
  - "Modern Light Pattern"
  - "Stylized Diwali Scene"
  - "Contemporary Blessing"