# Mid-Autumn Festival Cultural Expansion Implementation Plan

## Overview
Enhance the existing Forava02 cultural gift system to implement comprehensive Mid-Autumn Festival functionality with 4 sub-themes (Traditional, Mooncakes, Family, Modern), design elements with Centre Pieces, 8 color palettes, 6 optional messages, and the complete workflow from Style through Send.

## Current Status Analysis
- ✅ **Foundation**: Forava02 has stable cultural framework
- ✅ **Mid-Autumn Festival Event**: Already defined in `CulturalEvent.allEvents`
- ✅ **Mid-Autumn Festival Gifts**: 7 Mid-Autumn Festival gifts already exist in `CulturalGiftModel.swift`
- ✅ **Tab System**: 7-tab workflow already implemented in `CulturalGiftDesignView.swift`
- 🟡 **Missing**: Mid-Autumn Festival-specific sub-themes, elements, colors, messages

## Implementation Tasks

### 1. Update Cultural Category Icons
**File**: `ForavaApp/Models/CulturalEvent.swift:46-56`
- Icons already updated with emoji-based system:
  - `chinese`: "🧧" (red envelope - appropriate for Chinese festivals)

### 2. Create Mid-Autumn Festival Sub-Theme Structure
**New File**: `ForavaApp/Models/MidAutumnFestivalModels.swift`
- Define `MidAutumnFestivalTheme` enum: Traditional, Mooncakes, Family, Modern
- Each theme with:
  - Brief description
  - 8 gift options per theme
  - Theme-specific styling properties

### 3. Implement Mid-Autumn Festival Design Elements
**Extend**: `ForavaApp/Models/MidAutumnFestivalModels.swift`
- Create `MidAutumnFestivalElement` struct with 4 design elements:
  - **Centre Piece** (takes precedence): Full Moon, Mooncakes, Jade Rabbit, Lanterns
  - **Supporting Elements**: Osmanthus Flowers, Tea Set, Autumn Leaves, Chinese Calligraphy
- Each element with generation priority and AI prompt modifiers

### 4. Define Mid-Autumn Festival Color Palettes
**Extend**: `ForavaApp/Models/MidAutumnFestivalModels.swift`
- Create 8 Mid-Autumn Festival-specific color palettes:
  - Harvest Moon (Golden Yellow, Orange, Deep Brown)
  - Autumn Leaves (Rust Orange, Golden Brown, Deep Red)
  - Traditional Lantern (Red, Gold, Warm Yellow)
  - Moonlight Silver (Silver, Pearl White, Soft Blue)
  - Jade Rabbit (Jade Green, White, Gold)
  - Osmanthus Gold (Golden Yellow, Orange, Cream)
  - Modern Minimalist (Black, White, Gold Accent)
  - Warm Family (Warm Orange, Brown, Ivory)

### 5. Create Mid-Autumn Festival Personal Touch System
**Extend**: `ForavaApp/Models/MidAutumnFestivalModels.swift`
- Define 6 optional Mid-Autumn Festival messages:
  - "中秋快樂! Wishing you a happy Mid-Autumn Festival"
  - "May the full moon bring you peace and prosperity"
  - "Celebrating family unity under the bright moon"
  - "Sharing mooncakes and warm wishes with you"
  - "May your family be blessed with happiness and harmony"
  - "Under the same moon, we share the same love"
- Personal message input field with Mid-Autumn Festival-themed placeholder

### 6. Update Style Tab Implementation
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:209-270`
- Modify `StyleTabContent` to show Mid-Autumn Festival sub-themes instead of individual gifts
- Create sub-theme cards showing 4 themes with descriptions
- Each sub-theme leads to 8 gift options grid

### 7. Implement Elements Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:325-356`
- Replace placeholder with Mid-Autumn Festival elements selection
- Show 4 design elements with Centre Piece prominence
- Visual indicators for element hierarchy

### 8. Implement Colour Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:358-389`
- Replace placeholder with 8 Mid-Autumn Festival color palette options
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
- Display temporary dummy Mid-Autumn Festival image placeholder
- Show personal message or optional text below image
- "Watch and Phone Background Ready" indicator

### 12. Implement Send Tab
**File**: `ForavaApp/Views/CulturalGiftDesignView.swift:491-523`
- Show same dummy image with contact name
- "Send your personal designer gift to [Contact Name]" button
- "Re-create, for $2" button with subscription integration

## Validation Requirements
- All existing Rakhi functionality must remain intact
- Mid-Autumn Festival implementation must not break other cultural events
- SwiftLint compliance for all new code
- Build successfully with Xcode project integration
- Test Mid-Autumn Festival workflow end-to-end
- Cultural authenticity review by Chinese cultural experts

## Key Files Modified
1. `ForavaApp/Models/CulturalEvent.swift` - Already updated with icons
2. `ForavaApp/Models/MidAutumnFestivalModels.swift` - New file with all Mid-Autumn Festival-specific models
3. `ForavaApp/Views/CulturalGiftDesignView.swift` - All 7 tabs enhanced for Mid-Autumn Festival
4. Assets - Add dummy Mid-Autumn Festival image placeholder

## Success Criteria
- Mid-Autumn Festival carousel shows 🧧 icon with "Choose a Mooncake Style" title
- Style tab shows 4 sub-themes, each leading to 8 options
- Elements tab shows 4 design elements with Centre Piece priority
- Colour tab shows 8 Mid-Autumn Festival color palettes
- Touch tab shows 6 messages + personal input
- Create tab summarizes selections with generate button
- Check & Send tabs show dummy image with appropriate buttons

## Cultural Significance
Mid-Autumn Festival is one of the most important traditional Chinese festivals, celebrating family reunion, harvest, and lunar appreciation. This implementation honors:
- **Family Unity**: Emphasis on togetherness and reunion under the full moon
- **Harvest Celebration**: Thanksgiving for the autumn harvest and abundance
- **Lunar Worship**: Traditional appreciation of the full moon's beauty
- **Cultural Legends**: Chang'e and the Jade Rabbit folklore
- **Cultural Authenticity**: Proper use of traditional symbols, colors, and Chinese greetings

This plan maintains the existing stable architecture while adding comprehensive Mid-Autumn Festival functionality that respects and celebrates authentic Chinese traditions.

## Mid-Autumn Festival Theme Details

### Traditional Theme
- **Description**: "Classic Mid-Autumn with authentic cultural elements"
- **Gift Options**: 
  - "Traditional Mooncake Display"
  - "Chang'e Flying to Moon"
  - "Jade Rabbit Legend"
  - "Classic Lantern Festival"
  - "Traditional Family Scene"
  - "Osmanthus Wine Toast"
  - "Ancient Moon Poetry"
  - "Classical Festival Scene"

### Mooncakes Theme
- **Description**: "Celebrating the traditional delicacy and sharing"
- **Gift Options**:
  - "Golden Mooncake Gift"
  - "Assorted Mooncake Box"
  - "Traditional Recipe Card"
  - "Mooncake Making Scene"
  - "Family Sharing Mooncakes"
  - "Elegant Mooncake Plate"
  - "Premium Gift Box"
  - "Sweet Tradition Card"

### Family Theme
- **Description**: "Family reunion and togetherness celebration"
- **Gift Options**:
  - "Family Moon Viewing"
  - "Generations Together"
  - "Family Reunion Dinner"
  - "Children's Lantern Parade"
  - "Grandparents & Grandchildren"
  - "Family Garden Party"
  - "Unity Under Moon"
  - "Family Blessing Circle"

### Modern Theme
- **Description**: "Contemporary Mid-Autumn with modern artistic elements"
- **Gift Options**:
  - "Modern Mooncake Art"
  - "Contemporary Lantern Design"
  - "Urban Moon Viewing"
  - "Digital Moon Phase"
  - "Minimalist Festival Card"
  - "Modern Chinese Typography"
  - "Stylized Jade Rabbit"
  - "Contemporary Festival Art"