# Cultural Design Implementation Protocol

## ⚠️ CRITICAL: XcodePrevent SWBBuildService Crashes

**Last Updated**: 2025-11-06
**Purpose**: Prevent Xcode compiler crashes when implementing new cultural designs

---

## 🚨 ROOT CAUSE: Why Xcode Crashes

### The Crash Sequence
```
1. Child views expect parent with protocol conformance
   ↓
2. Swift type checker tries to resolve undefined typealiases
   ↓
3. Encounters circular dependencies (views reference undefined types)
   ↓
4. SWBBuildService exhausts resources trying to resolve types
   ↓
5. Xcode crashes with "SWBBuildService quit unexpectedly"
```

### What Triggers the Crash
- **Stub DesignView files** (< 50 lines with `PlaceholderCulturalView`)
- **Missing protocol conformance** in main DesignView
- **Property name mismatches** between Models and Views
- **Missing typealias declarations** (child views can't resolve types)

---

## 📏 THE GOLDEN RULE

> **ALL DesignView files MUST be 250+ lines with FULL protocol conformance**
>
> **NEVER commit placeholder/stub implementations**

**Why 250+ lines?**
- Ensures full protocol implementation
- Contains all 7 @ViewBuilder functions
- Includes proper state management
- Has complete generation logic
- Prevents type checker exhaustion

---

## 🔄 MANDATORY: 7-Step Cultural Design Implementation Process

### Step 1: Read Existing Model (if it exists)
```bash
# Check if [Culture]Models.swift already exists
ls ForavaApp/Models/[Culture]Models.swift

# If yes: READ ENTIRE FILE
cat ForavaApp/Models/[Culture]Models.swift

# Note these critical property names:
# - ColorPalette: primaryHex OR primaryColor?
# - ColorPalette: secondaryHex OR secondaryColor?
# - ColorPalette: accentHex OR accentColor?
# - ColorPalette: backgroundHex OR backgroundHint?
# - ColorPalette: aiColorHint present?
```

**Why This Matters**: Property naming inconsistency is the #1 cause of type errors that crash Xcode.

### Step 2: Verify Model Matches Standard Pattern

**✅ STANDARD PATTERN (Easter, Diwali, Anniversary)**:
```swift
struct EasterColorPalette {
    let primaryHex: String      // ← "Hex" suffix
    let secondaryHex: String    // ← "Hex" suffix
    let accentHex: String       // ← "Hex" suffix
    let backgroundHex: String   // ← "Hex" suffix
    let aiColorHint: String     // ← Has AI hint

    // Computed Color properties
    var primary: Color { Color(hex: primaryHex) }
    var secondary: Color { Color(hex: secondaryHex) }
    var accent: Color { Color(hex: accentHex) }
    var background: Color { Color(hex: backgroundHex) }
}
```

**⚠️ NON-STANDARD PATTERN (Christmas)**:
```swift
struct ChristmasColorPalette {
    let primaryColor: String    // ← "Color" suffix (different!)
    let secondaryColor: String  // ← "Color" suffix (different!)
    let accentColor: String     // ← "Color" suffix (different!)
    let backgroundHint: String  // ← "Hint" not "Hex" (different!)

    // Tuple-based computed property
    var swiftUIColors: (primary: Color, secondary: Color, accent: Color) {
        return (
            primary: Color(hex: primaryColor),
            secondary: Color(hex: secondaryColor),
            accent: Color(hex: accentColor)
        )
    }
}
```

### Step 3: If Model Doesn't Match, FIX IT FIRST

**🛑 STOP! Do NOT create views that match wrong model naming**

**Option A: Standardize Model (Recommended)**
```bash
# Update ChristmasModels.swift to match standard pattern
# Change: primaryColor → primaryHex
# Change: secondaryColor → secondaryHex
# Change: accentColor → accentHex
# Change: backgroundHint → backgroundHex
# Add: aiColorHint property
```

**Option B: Update Views to Match Model**
```bash
# If model can't be changed, ensure ALL views use correct names
# Example: palette.primaryColor (not palette.primaryHex)
```

**Rule**: Always fix model FIRST, then create views to match it.

### Step 4: Create AIService

**Template** (copy from working example like EasterAIService.swift):
```swift
import Foundation

class ChristmasAIService: BaseCulturalAIService, CulturalAIServiceProtocol {
    static let shared = ChristmasAIService()

    @Published var error: CulturalAIConfiguration.CulturalAIError?

    private init() {
        super.init(culturalContext: "Christmas")
    }

    func generateChristmasGift(
        theme: ChristmasTheme,
        element: ChristmasElement,
        colorPalette: ChristmasColorPalette,
        message: String,
        contactName: String,
        format: GiftFormat
    ) async throws -> String {
        // Implementation here
    }
}
```

**Verify**:
- ✅ Extends `BaseCulturalAIService`
- ✅ Implements `CulturalAIServiceProtocol`
- ✅ Property access matches model (primaryHex vs primaryColor)
- ✅ Has format-specific prompt adjustments

### Step 5: Create DesignView (FULL implementation)

**🚨 CRITICAL**: Never create stub/placeholder. Must be 250+ lines.

```bash
# Copy from working example (EasterDesignView recommended)
cp ForavaApp/Views/CulturalDesigns/Easter/EasterDesignView.swift \
   ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift

# Find and replace all occurrences:
# "Easter" → "Christmas"
# "easter" → "christmas"
# "EasterAI" → "ChristmasAI"
```

**Mandatory Components**:
```swift
struct ChristmasDesignView: View, CulturalDesignViewProtocol {
    // MUST HAVE: 7 typealias declarations
    typealias CulturalTheme = ChristmasTheme
    typealias CulturalElement = ChristmasElement
    typealias CulturalColorPalette = ChristmasColorPalette
    typealias CulturalPersonalTouch = ChristmasPersonalTouch
    typealias StyleContent = ChristmasStyleSelectionView
    typealias ElementsContent = ChristmasElementsSelectionView
    typealias ColorContent = ChristmasColorPaletteView
    typealias TouchContent = ChristmasPersonalTouchView
    typealias CreateContent = ChristmasCreateSummaryView
    typealias CheckContent = ChristmasCheckImageView
    typealias SendContent = ChristmasSendShareView

    // MUST HAVE: @StateObject for AI service
    @StateObject private var christmasAI = ChristmasAIService.shared

    // MUST HAVE: All state properties
    @State var currentTab: GiftDesignTab = .style
    @State var selectedTheme: ChristmasTheme?
    @State var selectedElements: [ChristmasElement] = []
    @State var selectedColorPalette: ChristmasColorPalette?
    @State var selectedMessage: ChristmasPersonalTouch?
    @State var personalMessage: String = ""
    @State private var isGenerating = false
    @State private var generatedImages: [String: String] = [:]
    @State private var showingShareSheet = false

    // MUST HAVE: 7 @ViewBuilder functions
    @ViewBuilder func styleContent() -> StyleContent { /* ... */ }
    @ViewBuilder func elementsContent() -> ElementsContent { /* ... */ }
    @ViewBuilder func colorContent() -> ColorContent { /* ... */ }
    @ViewBuilder func touchContent() -> TouchContent { /* ... */ }
    @ViewBuilder func createContent() -> CreateContent { /* ... */ }
    @ViewBuilder func checkContent() -> CheckContent { /* ... */ }
    @ViewBuilder func sendContent() -> SendContent { /* ... */ }

    // MUST HAVE: Generation function
    private func generateChristmasGift() {
        // Full async/await implementation
    }
}
```

**Line Count Check**:
```bash
wc -l ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift
# Must show 250+ lines
```

### Step 6: Create 7 Child Views

**Option A: Use Agent (Faster)**
```bash
# Specify exact property names from model in the agent prompt
"Create ChristmasColorPaletteView that accesses palette.primaryColor,
palette.secondaryColor, palette.accentColor (NOT primaryHex)"
```

**Option B: Manual Creation**
```bash
# Copy from working example
cp ForavaApp/Views/CulturalDesigns/Easter/EasterStyleSelectionView.swift \
   ForavaApp/Views/CulturalDesigns/Christmas/ChristmasStyleSelectionView.swift

# Find/replace: "Easter" → "Christmas"
```

**Required Files**:
1. `ChristmasStyleSelectionView.swift` - Theme selection
2. `ChristmasElementsSelectionView.swift` - Element selection
3. `ChristmasColorPaletteView.swift` - Color palette selection
4. `ChristmasPersonalTouchView.swift` - Message customization
5. `ChristmasCreateSummaryView.swift` - Review and generate
6. `ChristmasCheckImageView.swift` - Image preview
7. `ChristmasSendShareView.swift` - Share options

### Step 7: MANDATORY VERIFICATION (Before First Build)

**Pre-Build Checklist**:
```bash
# 1. Model Validation
grep -E "(primaryHex|primaryColor)" ForavaApp/Models/ChristmasModels.swift
# Note which pattern is used

# 2. Read created view files (at least 2)
cat ForavaApp/Views/CulturalDesigns/Christmas/ChristmasColorPaletteView.swift | grep "palette\."
# Verify property access matches model

# 3. Check DesignView size
wc -l ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift
# MUST be 250+ lines

# 4. Check protocol conformance
grep "CulturalDesignViewProtocol" ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift
# MUST exist

# 5. Check typealiases
grep "typealias" ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift | wc -l
# MUST show 7 or more

# 6. Check for placeholders
grep -i "placeholder\|coming soon\|TODO" ForavaApp/Views/CulturalDesigns/Christmas/*.swift

# 7. Run SwiftLint
/opt/homebrew/bin/swiftlint lint ForavaApp/Views/CulturalDesigns/Christmas/

# 8. Add files to Xcode project
open Forava.xcodeproj
# Manually add all files via GUI

# 9. Build immediately
xcodebuild -project Forava.xcodeproj -scheme ForavaApp build
```

---

## 🛡️ Pre-Build Validation Checklist

### Model Validation
- [ ] ColorPalette uses consistent naming (`primaryHex` OR `primaryColor`, not mixed)
- [ ] ColorPalette has 4-5 required properties
- [ ] ColorPalette has computed Color properties OR tuple
- [ ] Theme enum has rawValue and description
- [ ] Element has all 5 required properties (id, name, category, priority, aiPromptModifier)
- [ ] PersonalTouch has all 3 required properties (id, message, tone)

### DesignView Validation
- [ ] File is **250+ lines** (not a stub)
- [ ] Conforms to `CulturalDesignViewProtocol`
- [ ] Has **7 typealias declarations**
- [ ] Has **9+ @State properties**
- [ ] Has **@StateObject for AI service**
- [ ] Implements all **7 @ViewBuilder functions**
- [ ] Has generation logic with **async/await**
- [ ] No `PlaceholderCulturalView` references

### Child Views Validation
- [ ] All 7 view files exist
- [ ] Property access uses correct names (check model first!)
- [ ] No references to wrong culture (no "Easter" in Christmas files)
- [ ] All imports present
- [ ] Preview code uses valid enum cases

### Cross-Check Validation (CRITICAL)
```bash
# Step 1: Identify model pattern
grep "struct.*ColorPalette" ForavaApp/Models/ChristmasModels.swift -A 10

# Step 2: Verify ColorPaletteView uses same pattern
grep "palette\." ForavaApp/Views/CulturalDesigns/Christmas/ChristmasColorPaletteView.swift

# Step 3: Check DesignView has @StateObject
grep "@StateObject" ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift

# Step 4: Verify all computed properties exist in model
grep "var.*Color" ForavaApp/Models/ChristmasModels.swift

# Step 5: Search for TODOs
grep -r "TODO\|FIXME" ForavaApp/Views/CulturalDesigns/Christmas/
```

---

## 🔍 Common Failure Patterns

### Pattern 1: Property Name Mismatch
**Symptoms**:
```swift
// Error: Value of type 'ChristmasColorPalette' has no member 'primaryHex'
palette.primaryHex  // ❌ Doesn't exist in model
```

**Root Cause**: Child view uses `primaryHex` but model has `primaryColor`

**Fix**:
```swift
// Check model first:
grep "primaryColor\|primaryHex" ForavaApp/Models/ChristmasModels.swift

// If model uses primaryColor:
palette.primaryColor  // ✅ Matches model
```

### Pattern 2: Stub DesignView
**Symptoms**:
```swift
// ChristmasDesignView.swift (16 lines - STUB!)
struct ChristmasDesignView: View {
    var body: some View {
        PlaceholderCulturalView(...)  // ❌ CAUSES CRASH
    }
}
```

**Root Cause**: Child views expect protocol conformance but get placeholder

**Fix**:
```bash
# Copy full implementation from working example
cp ForavaApp/Views/CulturalDesigns/Easter/EasterDesignView.swift \
   ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift
# Find/replace all "Easter" → "Christmas"
```

### Pattern 3: Missing Typealiases
**Symptoms**:
```
Error: Type 'ChristmasDesignView' does not conform to protocol 'CulturalDesignViewProtocol'
```

**Root Cause**: Missing or incorrect typealias declarations

**Fix**:
```swift
// MUST have all 7 typealiases:
typealias CulturalTheme = ChristmasTheme
typealias CulturalElement = ChristmasElement
typealias CulturalColorPalette = ChristmasColorPalette
typealias CulturalPersonalTouch = ChristmasPersonalTouch
typealias StyleContent = ChristmasStyleSelectionView
typealias ElementsContent = ChristmasElementsSelectionView
typealias ColorContent = ChristmasColorPaletteView
typealias TouchContent = ChristmasPersonalTouchView
typealias CreateContent = ChristmasCreateSummaryView
typealias CheckContent = ChristmasCheckImageView
typealias SendContent = ChristmasSendShareView
```

### Pattern 4: Files Not in Xcode Project
**Symptoms**:
```
Error: Cannot find 'ChristmasAIService' in scope
```

**Root Cause**: Files exist on disk but not added to Xcode project.pbxproj

**Fix**:
```bash
# Open Xcode
open Forava.xcodeproj

# Right-click folder → "Add Files to 'Forava'..."
# Select files, check "ForavaApp" target, click "Add"
```

---

## 🚑 Recovery Procedures

### If Xcode Already Crashed

**Step 1: Force Quit Xcode**
```bash
killall Xcode
killall SWBBuildService
```

**Step 2: Clean Build Folder**
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData/Forava-*
```

**Step 3: Identify Problem Files**
```bash
# Find stub DesignViews (< 100 lines)
find ForavaApp/Views/CulturalDesigns -name "*DesignView.swift" -exec wc -l {} \; | sort -n

# Check for PlaceholderCulturalView usage
grep -r "PlaceholderCulturalView" ForavaApp/Views/CulturalDesigns/
```

**Step 4: Replace Stubs**
```bash
# Option A: Replace with full implementation
cp ForavaApp/Views/CulturalDesigns/Easter/EasterDesignView.swift \
   ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift

# Option B: Remove routing temporarily
# Edit CulturalGiftDesignView.swift
# Comment out the problematic case
```

**Step 5: Reopen and Rebuild**
```bash
open Forava.xcodeproj
# Clean Build Folder (Cmd+Shift+K)
# Build (Cmd+B)
```

---

## 📊 Success Metrics

### Before First Build
- [ ] All DesignView files are 250+ lines
- [ ] No `PlaceholderCulturalView` references
- [ ] Property naming verified consistent
- [ ] All files added to Xcode project
- [ ] SwiftLint shows 0 errors (warnings OK)

### After Successful Build
- [ ] Build completes without SWBBuildService crash
- [ ] All 7 tabs appear in UI
- [ ] Can navigate between tabs
- [ ] Generate button accessible
- [ ] AI service instantiates without crash

---

## 🎯 Quick Reference

**Property Naming Standards**:
```
Easter/Diwali/Anniversary: primaryHex, secondaryHex, accentHex, backgroundHex, aiColorHint
Christmas (non-standard):  primaryColor, secondaryColor, accentColor, backgroundHint
```

**File Size Requirements**:
```
DesignView:  250+ lines (MANDATORY)
Child Views: 50+ lines each
AIService:   100+ lines
Models:      200+ lines
```

**Critical Files**:
```
[Culture]DesignView.swift     - 250+ lines with protocol conformance
[Culture]AIService.swift      - Must be in Xcode project
[Culture]Models.swift         - Defines property naming standard
CulturalGiftDesignView.swift  - Single source of truth for routing
```

---

## 📝 Version History

- **2025-11-06**: Initial creation after Christmas crash incident
- Documented root cause: stub DesignView files cause type checker exhaustion
- Established 250+ line requirement for DesignView files
- Added 7-step mandatory process
- Added pre-build validation checklist
- Added recovery procedures

---

## 🔗 Related Documentation

- `CULTURAL_DESIGN_CHECKLIST.md` - Step-by-step implementation guide
- `CLAUDE.md` - Project architecture and guidelines
- `CulturalDesignProtocol.swift` - Protocol definitions

---

**Remember**: Prevention is 100x easier than recovery. Always follow the 7-step process!
