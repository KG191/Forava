# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Forava is an AI-powered multi-cultural digital gifting platform with subscription-based revenue model. Originally built for Rakhi (Hindu tradition), the app is now transitioning to a universal cultural gifting platform supporting multiple occasions and traditions through AI-generated personalized greetings and animations.

**IMPORTANT**: As of August 2025, we have adopted a **fresh start strategy** using Forava02 as our primary development environment, built from the stable Rakhi app foundation (GitHub commit 978f9c2).

### Core Mission
Transform cultural celebrations into personalized AI-powered digital experiences while maintaining cultural authenticity and supporting subscription-based revenue through image re-generation fees.

### Target Cultures
- **Hindu**: Raksha Bandhan, Diwali, Holi
- **Chinese**: Chinese New Year, Mid-Autumn Festival  
- **Christian**: Christmas, Easter
- **Islamic**: Eid al-Fitr, Eid al-Adha
- **Buddhist**: Vesak Day
- **Jewish**: Rosh Hashanah, Hanukkah
- **Universal**: Birthdays, Anniversaries

## Development Environment Structure

### Project Structure
```
Forava/
├── Forava02/                          # PRIMARY DEVELOPMENT (Clean Start)
│   ├── Forava.xcodeproj              # Working Xcode project
│   ├── ForavaApp/                     # iOS app (stable Rakhi foundation)
│   ├── ForavaWatch/                   # Watch app
│   └── Shared/                        # Shared components
├── Forava01/                          # REFERENCE ONLY (Had errors)
├── Forava_PreWired_Workspace/         # REFERENCE ONLY (Complex/Broken)
│   └── [100+ compilation errors]      # Use for code patterns only
└── CLAUDE.md                          # This file
```

### Xcode Integration & Workflow

#### Primary Development Environment
```bash
# Navigate to clean development version
cd /Users/kirangokal/Documents/Forava/Forava02

# Open in Xcode
open Forava.xcodeproj
# or
open Forava.xcworkspace
```

#### Build & Test Commands
```bash
# From Forava02 directory
xcodebuild -project Forava.xcodeproj -scheme ForavaApp clean build CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=""

# SwiftLint
/opt/homebrew/bin/swiftlint lint
/opt/homebrew/bin/swiftlint --fix

# Test single culture before adding next
xcodebuild test -project Forava.xcodeproj -scheme ForavaApp
```

#### Cultural Expansion Strategy (One-at-a-Time)
1. **Current Status**: Rakhi app (stable, building successfully)
2. **Next Culture**: Chinese New Year (add + test thoroughly)  
3. **Following Culture**: Only add after previous culture 100% working
4. **Test Cycle**: Build → Test → Cultural Validation → User Testing

### Mock Backend (Python Flask)
```bash
cd Forava_MockBackend
python app.py
```
Server runs at `http://127.0.0.1:5055`

## Multi-Cultural Transformation Architecture

### Fresh Start Implementation Strategy

**RESET STATUS**: All previous 6-phase implementation has been reset. We now use incremental cultural expansion from stable Rakhi foundation.

#### 🔄 Phase A: Foundation Validation (COMPLETE)
- **Status**: ✅ COMPLETE  
- **Location**: `Forava02/` (GitHub commit 978f9c2)
- **Features**: Stable Rakhi app with working iOS/Watch integration
- **Verification**: Successfully builds and runs without errors
- **Key Files**: All base services, models, and views working

#### 🔄 Phase B: Cultural Framework Creation (NEXT)
- **Status**: 🟡 PENDING
- **Approach**: Extend existing RakhiModel → CulturalGiftModel
- **Strategy**: Add cultural context enum, maintain backward compatibility
- **Test Requirement**: Rakhi functionality must remain 100% intact

#### 🔄 Phase C: Single Culture Addition (Chinese New Year)
- **Status**: 🟡 PENDING  
- **Implementation**: One culture at a time, thorough testing before next
- **Components**: Cultural context, AI prompts, UI elements, color schemes
- **Validation**: Build → Test → Cultural Accuracy → User Experience

#### 🔄 Phase D: Revenue Model Integration
- **Status**: 🟡 PENDING
- **Features**: Subscription system, re-generation tracking, cultural payments
- **Requirements**: Apple-compliant IAP, cultural pricing tiers
- **Testing**: Payment flow validation per culture

#### 🔄 Phase E: Cultural Expansion
- **Status**: 🟡 PENDING
- **Order**: Christmas → Diwali → Eid → Additional cultures
- **Rule**: Each culture must be 100% tested before adding next
- **Metrics**: Build success, cultural accuracy, user feedback

#### 🔄 Phase F: Production Deployment
- **Status**: 🟡 PENDING
- **Requirements**: App Store compliance, performance optimization
- **Validation**: Full multi-cultural test suite, accessibility compliance

### Core Architecture Components (Forava02 Fresh Start)

#### Current Working Foundation
```
Forava02/ForavaApp/Models/RakhiModel.swift          - Stable base model
Forava02/ForavaApp/Services/AIRakhiService.swift    - Working AI service
Forava02/ForavaApp/Views/RakhiDesignStudioView.swift - Functional UI
Forava02/ForavaApp/Views/ContactSelectionView.swift - Working contact system
```

#### Planned Cultural Framework (To Be Built)
```
Models/CulturalGiftModel.swift      - Extend RakhiModel to support multiple cultures
Services/CulturalContextManager.swift - Build from AIRakhiService foundation  
Services/CulturalAIService.swift    - Evolve from working AIRakhiService
Views/CulturalDesignStudioView.swift - Expand RakhiDesignStudioView
```

#### Cultural Expansion Pattern (One-at-a-Time)
```
Phase C: Chinese New Year
├── Models/ChineseNewYearContext.swift      - First cultural context
├── Services/ChineseNewYearAgent.swift      - Cultural AI agent  
├── Views/ChineseNewYearComponents.swift    - UI components
└── Testing/ChineseNewYearTests.swift       - Validation suite

Phase D: Christmas (Only after Chinese 100% complete)
Phase E: Diwali (Only after Christmas 100% complete)
```

### Revenue Model Integration

#### Subscription Tiers
- **Basic**: $2.99/month - 3 cultural contexts, unlimited first generations
- **Premium**: $4.99/month - All cultural contexts, priority processing  
- **Family**: $7.99/month - Up to 6 family members, shared preferences

#### Revenue Tracking
- **Re-generation Credits**: $2 per additional image generation after first free attempt
- **Cultural Packs**: Premium seasonal and cultural element packs
- **Apple-Compliant IAP**: Full StoreKit 2 integration with receipt validation

### AI-Powered Generation System

#### Primary AI Stack
- **SDXL Base Model**: High-quality cultural artwork generation
- **ControlNet Integration**: Precise cultural element control
- **Custom LoRA Models**: Fine-tuned for cultural authenticity
- **GPT-4 Integration**: Cultural validation and prompt enhancement

#### Cultural Authenticity Validation
- **Cultural Scoring System**: Automated authenticity assessment
- **Community Feedback**: User-driven cultural accuracy validation
- **Expert Review**: Cultural advisory board integration

### Cross-Platform Synchronization

#### iOS App (`ForavaApp/`)
- Cultural design studio with AI generation
- Subscription and payment management
- Cross-cultural preference management
- Social sharing with cultural context

#### Apple Watch App (`ForavaWatch/`)  
- Cultural gift display and animation
- Watch-optimized payment triggers
- Advanced haptic feedback for cultural elements
- Battery-optimized cultural animations

#### Communication Flow
1. AI-generated cultural gifts created on iOS
2. Cultural context synchronized to Watch via WatchConnectivity
3. Watch displays culturally-appropriate animations
4. Payment initiated from Watch with cultural presentation
5. Cultural gratitude expressions delivered across devices

## Brand Guidelines & Cultural Design

### Cultural Color Palettes

#### Chinese New Year
- Primary: `#DC143C` (Crimson Red)
- Secondary: `#FFD700` (Gold)
- Accent: `#B71C1C` (Dark Red)

#### Diwali  
- Primary: `#FF6B35` (Festival Orange)
- Secondary: `#673AB7` (Deep Purple)
- Accent: `#FFD700` (Gold)

#### Christmas
- Primary: `#C41E3A` (Christmas Red) 
- Secondary: `#228B22` (Forest Green)
- Accent: `#FFD700` (Gold)

### Cultural Design Elements

#### Symbol Libraries
- **Hindu**: Om, Lotus, Rangoli patterns, Diyas
- **Chinese**: Dragons, Phoenix, Bamboo, Prosperity symbols
- **Christian**: Holly, Stars, Angels, Crosses
- **Islamic**: Crescents, Stars, Geometric patterns, Calligraphy
- **Buddhist**: Lotus flowers, Dharma wheels, Peaceful imagery
- **Jewish**: Star of David, Menorahs, Hebrew text

## Testing & Quality Assurance

### Comprehensive Test Coverage
```bash
# Cultural Framework Core Tests
ForavaApp/Testing/CulturalFrameworkTests.swift

# Phase-Specific Validation
ForavaApp/Testing/Phase5DynamicTerminologyTests.swift
ForavaApp/Testing/Phase6CulturalDesignTests.swift  

# Production Test Suite
ForavaApp/Testing/ProductionTestSuite.swift
```

### Cultural Accuracy Validation
- **Automated Cultural Scoring**: AI-powered authenticity assessment
- **Community Feedback Integration**: User-driven cultural validation
- **Expert Review System**: Cultural advisory board validation
- **Cross-Cultural Sensitivity**: Inappropriate content filtering

## Performance & Optimization

### Technical Metrics
- **AI Generation Time**: <30 seconds per cultural design
- **Cultural Context Switching**: <1ms average performance  
- **App Stability**: >99.5% crash-free rate across all cultural contexts
- **Battery Optimization**: Watch animations optimized for minimal battery impact

### Business Metrics
- **Cultural Adoption**: >60% users explore multiple cultural contexts
- **Subscription Conversion**: >25% within first 30 days
- **Cultural Authenticity**: >4.0/5.0 average user rating per culture
- **Re-generation Revenue**: Target >$5 per monthly active user

## Apple Standards Compliance

### App Store Guidelines Adherence
- **Guideline 3.1**: All purchases through Apple IAP system
- **Guideline 4.3**: Each cultural context provides unique value
- **Guideline 5.1.1**: Privacy-first cultural data handling
- **Cultural Sensitivity**: Rigorous cultural appropriation prevention

### Accessibility & Localization
- **VoiceOver Support**: Full accessibility for cultural elements
- **Dynamic Type**: Cultural text scaling support
- **Cultural Color Contrast**: WCAG-compliant cultural color schemes
- **Multi-Language**: Cultural terminology in multiple languages

## Production Deployment Status

### Current State
- **All 6 Phases**: IMPLEMENTATION COMPLETE
- **Cultural Framework**: Production-ready with backward compatibility
- **Revenue Model**: Active subscription system with re-generation tracking
- **Cultural Validation**: Automated authenticity scoring operational
- **Apple Compliance**: Full App Store readiness achieved

### GitHub Repository
- **Latest Version**: https://github.com/KG191/Forava/tree/main
- **Universal Gift Payment**: Latest requirement with subscription-based regeneration
- **Production Checklist**: Comprehensive deployment validation complete

## Development Guidelines (Fresh Start Approach)

### Mandatory Development Rules
1. **Always work in Forava02**: Never edit files in `Forava_PreWired_Workspace/` or `Forava01/`
2. **One Culture at a Time**: Complete testing of current culture before adding next
3. **Backward Compatibility**: Rakhi functionality must remain 100% intact through all changes
4. **Test Before Expand**: Each cultural addition requires comprehensive validation
5. **Xcode Project Integration**: All new files must be properly added to Forava.xcodeproj
6. **Single Routing Source**: ONLY update `CulturalGiftDesignView.swift` for cultural routing (see Architectural Consolidation below)
7. **🚨 PREVENT XCODE CRASHES**: ALL DesignView files MUST be 250+ lines with FULL protocol conformance (see Crash Prevention Protocol below)

### 🚨 CRITICAL: Xcode Crash Prevention Protocol

**READ FIRST**: See `Forava02/CULTURAL_DESIGN_IMPLEMENTATION_PROTOCOL.md` for full details.

**The Golden Rule**:
> **ALL DesignView files MUST be 250+ lines with FULL protocol conformance**
> **NEVER commit stub/placeholder implementations**

**Why This Matters**: Stub DesignView files (< 50 lines using `PlaceholderCulturalView`) cause Swift type checker exhaustion → SWBBuildService crashes → "Xcode quit unexpectedly" error.

**The Crash Sequence**:
```
Stub DesignView (16 lines)
  ↓
Child views expect protocol conformance
  ↓
Swift type checker can't resolve typealiases
  ↓
Circular dependency errors accumulate
  ↓
SWBBuildService exhausts resources
  ↓
XCODE CRASH
```

**Mandatory Requirements**:
1. **DesignView Size**: 250+ lines minimum
2. **Protocol Conformance**: Must implement `CulturalDesignViewProtocol`
3. **Typealiases**: All 7 typealias declarations required
4. **State Management**: All @State and @StateObject properties
5. **ViewBuilder Functions**: All 7 @ViewBuilder functions implemented
6. **Generation Logic**: Complete async/await generation function
7. **NO Placeholders**: Never use `PlaceholderCulturalView`

**Property Naming Standards** (CRITICAL):
```
✅ STANDARD (Easter, Diwali, Anniversary):
   - primaryHex, secondaryHex, accentHex, backgroundHex, aiColorHint

⚠️ NON-STANDARD (Christmas - causes crashes):
   - primaryColor, secondaryColor, accentColor, backgroundHint
```

**Verification Before Build**:
```bash
# 1. Check file size
wc -l ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift
# MUST show 250+ lines

# 2. Check for placeholders
grep -r "PlaceholderCulturalView" ForavaApp/Views/CulturalDesigns/Christmas/

# 3. Check typealiases
grep "typealias" ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift | wc -l
# MUST show 7+

# 4. Verify protocol conformance
grep "CulturalDesignViewProtocol" ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift
```

**If Xcode Already Crashed**:
```bash
# 1. Force quit
killall Xcode
killall SWBBuildService

# 2. Clean build
rm -rf ~/Library/Developer/Xcode/DerivedData/Forava-*

# 3. Fix stub files (copy from Easter template)
cp ForavaApp/Views/CulturalDesigns/Easter/EasterDesignView.swift \
   ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift
# Then find/replace all "Easter" → "Christmas"

# 4. Reopen and build
open Forava.xcodeproj
```

**Reference Documents**:
- `Forava02/CULTURAL_DESIGN_IMPLEMENTATION_PROTOCOL.md` - Full 7-step protocol
- `Forava02/CULTURAL_DESIGN_CHECKLIST.md` - Implementation checklist

### 🎯 CRITICAL: Cultural Routing Architecture (Dual Routing Required)

**Issue Pattern (RECURRING)**: Tabs not appearing after selecting contact for new cultural designs.

**Root Cause**: Despite architectural consolidation attempts, the app still uses TWO routing systems:
- **Primary Router**: `ForavaApp/Views/CulturalGiftDesignView.swift` (intended single source of truth)
- **Legacy Router**: `TempCulturalGiftDesignView` (inside `CulturalGiftSelectionView.swift`, marked deprecated but STILL ACTIVE)

**Historical Failures**: This has caused recurring issues for:
- Vesak Day (November 1, 2025 - commit fd47bbc)
- Rosh Hashanah (November 2, 2025 - commit d591998)
- Christmas (November 7, 2025 - current fix)

**When Adding New Cultural Design (BOTH Locations Required)**:

**Step 1 - Update CulturalGiftDesignView.swift** (line ~45):
```swift
switch selectedEvent.name.lowercased() {
case "anniversary":
    AnniversaryDesignView(...)
case "chinese new year":
    ChineseNewYearDesignView(...)
case "christmas":  // ← Add new culture here FIRST
    ChristmasDesignView(...)
default:
    // Coming Soon placeholder
}
```

**Step 2 - ALSO Update TempCulturalGiftDesignView** in `CulturalGiftSelectionView.swift` (line ~530):
```swift
// Yes, you MUST add routing here too, despite it being deprecated
switch selectedEvent.name.lowercased() {
case "easter":
    EasterDesignView(...)
case "christmas":  // ← ALSO add here or tabs won't show
    ChristmasDesignView(...)
default:
    // Placeholder
}
```

**CRITICAL WARNING**:
- ⚠️ If you only add routing to CulturalGiftDesignView.swift, **tabs will NOT show**
- ⚠️ The app will display "Coming Soon" placeholder instead of the 7-tab interface
- ⚠️ This is technical debt: TempCulturalGiftDesignView must be fully removed, but until then ALL cultures need BOTH locations

**Checklist Reference**: See `Forava02/CULTURAL_DESIGN_CHECKLIST.md` for complete implementation guide

### Cultural Development Workflow
```bash
# 1. Verify current state
cd /Users/kirangokal/Documents/Forava/Forava02
xcodebuild -project Forava.xcodeproj -scheme ForavaApp clean build

# 2. Add new cultural feature (example: Chinese New Year)
# - Create models, services, views
# - Add to Xcode project

# 3. Test thoroughly
xcodebuild test -project Forava.xcodeproj -scheme ForavaApp
/opt/homebrew/bin/swiftlint lint

# 4. Cultural validation
# - Verify Rakhi still works
# - Test new culture functionality
# - UI/UX validation

# 5. Only then add next culture
```

### Code Quality Requirements
- **SwiftLint Compliance**: Zero violations in new code
- **Build Success**: Every commit must build successfully  
- **Test Coverage**: Each cultural feature requires dedicated tests
- **Type Safety**: Leverage Swift's type system for cultural data validation
- **Performance**: Cultural features must not impact app performance

### Xcode Project Management
- **File Organization**: Follow existing Forava02 structure
- **Target Membership**: Ensure new files added to correct targets
- **Scheme Configuration**: Test with existing ForavaApp/ForavaWatch schemes
- **Asset Management**: Use existing asset catalog structure

## Important Constraints

### Critical Requirements
- **NO Breaking Changes**: Existing Rakhi users must not experience any disruption
- **Cultural Authenticity**: All cultural representations must be validated for accuracy
- **Apple Compliance**: Strict adherence to App Store guidelines for cultural content
- **Performance First**: Cultural features must maintain existing app performance
- **One-at-a-Time**: Never develop multiple cultures simultaneously

### Reference Usage
- **Forava_PreWired_Workspace/**: Use ONLY for code pattern reference
- **Forava01/**: Use ONLY for code pattern reference 
- **Copy Patterns**: Extract useful patterns but rebuild from scratch in Forava02
- **Never Import**: Do not copy broken files directly into Forava02