# Cultural Festival Branch Separation Plan

## Executive Summary

This document outlines the detailed plan to create 14 separate GitHub branches, each containing only the code for a specific cultural festival. Each branch will be a standalone, buildable version of the Forava app focused on a single cultural celebration.

---

## Branch Mapping

| Branch Name | Cultural Festival | Code Directory | Model File |
|------------|------------------|----------------|------------|
| `Xcode03_Anv` | Anniversary | `Anniversary/` | `AnniversaryModels.swift` |
| `Xcode03_Bth` | Birthdays | `Birthday/` | `BirthdayModels.swift` |
| `Xcode03_Cny` | Chinese New Year | `ChineseNewYear/` | `ChineseNewYearModels.swift` |
| `Xcode03_Csm` | Christmas | `Christmas/` | `ChristmasModels.swift` |
| `Xcode03_Dwl` | Diwali | `Diwali/` | `DiwaliModels.swift` |
| `Xcode03_Est` | Easter | `Easter/` | `EasterModels.swift` |
| `Xcode03_Eaa` | Eid al-Adha | `EidAlAdha/` | `EidAlAdhaModels.swift` |
| `Xcode03_Eaf` | Eid al-Fitr | `EidAlFitr/` | `EidAlFitrModels.swift` |
| `Xcode03_Hnk` | Hanukkah | `Hanukkah/` | `HanukkahModels.swift` |
| `XCode03_Hli` | Holi | *(Not yet implemented)* | *(TBD)* |
| `Xcode03_Maf` | Mid-Autumn Festival | `MidAutumnFestival/` | `MidAutumnFestivalModels.swift` |
| `Xcode03_Rkb` | Raksha Bandhan | `RakshaBandhan/` | `RakshaBandhanModels.swift` |
| `Xcode03_Rsh` | Rosh Hashanah | `RoshHashanah/` | `RoshHashanahModels.swift` |
| `Xcode03_Vsk` | Vesak Day | `VesakDay/` | `VesakDayModels.swift` |

**NOTE**: Holi (XCode03_Hli) is defined in `CulturalEvent.swift` but does not yet have implementation files. This branch will require implementation before creation.

---

## Architecture Analysis

### Common Code (Retained in All Branches)

These components are essential for all cultural festivals and will be retained in every branch:

#### Core Infrastructure
```
ForavaApp/
├── Services/
│   ├── BaseCulturalAIService.swift          ✅ KEEP (base class)
│   ├── CulturalAIConfiguration.swift        ✅ KEEP (SDXL configuration)
│   └── [OTHER_FESTIVAL]AIService.swift      ❌ DELETE (13 other festivals)
│
├── Models/
│   ├── Contact.swift                        ✅ KEEP
│   ├── CoreTypes.swift                      ✅ KEEP
│   ├── CulturalEvent.swift                  ⚠️  MODIFY (filter to single event)
│   ├── CulturalGiftModel.swift              ✅ KEEP
│   ├── SharedCulturalTypes.swift            ✅ KEEP
│   ├── SocialSharingModels.swift            ✅ KEEP
│   ├── SubscriptionModels.swift             ✅ KEEP
│   └── [OTHER_FESTIVAL]Models.swift         ❌ DELETE (13 other festivals)
│
├── Views/
│   ├── ContentView.swift                    ⚠️  MODIFY (landing page)
│   ├── SettingsView.swift                   ✅ KEEP (minor modifications)
│   ├── ContactSelectionView.swift           ✅ KEEP
│   ├── CulturalCarouselView.swift           ⚠️  MODIFY (single event only)
│   ├── AnimatedTitleView.swift              ✅ KEEP
│   └── CulturalDesigns/
│       ├── Shared/                          ✅ KEEP ALL (6 files)
│       │   ├── CachedAsyncImage.swift
│       │   ├── CulturalDesignComponents.swift
│       │   ├── CulturalDesignProtocol.swift
│       │   ├── CulturalDesignViewModel.swift
│       │   ├── GiftDesignTypes.swift
│       │   └── OptimizedCulturalDesignComponents.swift
│       ├── [TARGET_FESTIVAL]/               ✅ KEEP (this branch's festival)
│       └── [OTHER_FESTIVALS]/               ❌ DELETE (13 other festivals)
```

#### Assets & Resources
```
ForavaApp/Assets.xcassets/
├── [TARGET_FESTIVAL] images                 ✅ KEEP
└── [OTHER_FESTIVALS] images                 ⚠️  OPTIONAL DELETE (reduce size)
```

---

## Modification Strategy

### 1. CulturalEvent.swift Modification

**Current State**: Contains all 14 cultural events in `allEvents` array
**Target State**: Contains only the specific festival for that branch

**Example for `Xcode03_Anv` (Anniversary)**:

```swift
extension CulturalEvent {
    static let allEvents = [
        CulturalEvent(
            name: "Anniversary",
            imageName: "Anniversaries",
            description: "Commemorating special relationships and milestones",
            category: .universal,
            colors: ["#DC143C", "#FFD700", "#FF69B4"],
            culturalContext: "Universal celebration of lasting bonds and cherished memories"
        )
    ]
}
```

### 2. ContentView.swift Modification

**Current State**: Generic landing page with carousel showing all festivals
**Options**:

#### Option A: Direct Navigation (Recommended)
```swift
struct ContentView: View {
    var body: some View {
        NavigationStack {
            // Directly navigate to Anniversary design
            AnniversaryDesignView()
        }
    }
}
```

#### Option B: Single-Event Carousel
```swift
struct ContentView: View {
    @State private var navigateToDesign = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
                // Hero image for Anniversary
                // Single event carousel showing only Anniversary
                CulturalCarouselView { event in
                    navigateToDesign = true
                }
            }
            .navigationDestination(isPresented: $navigateToDesign) {
                ContactSelectionView(selectedEvent: CulturalEvent.allEvents[0])
            }
        }
    }
}
```

**Decision Point**: User must choose Option A or B before execution.

### 3. ContactSelectionView.swift Routing

**Current Logic**: Routes to different design views based on `event.name`

```swift
switch selectedEvent.name {
case "Anniversary": return AnyView(AnniversaryDesignView())
case "Birthdays": return AnyView(BirthdayDesignView())
// ... 12 other cases
}
```

**Modified for Anniversary Branch**:
```swift
// Simplified - only routes to Anniversary
return AnyView(AnniversaryDesignView())
```

### 4. SettingsView.swift Modification

**Current State**: Generic settings
**Target State**: Remove debug/test options for other festivals

**Minimal Changes Required**:
- Update app title to "Forava - Anniversary Edition" (or keep generic)
- Remove test runner for other festivals (if present)

---

## Xcode Project Modifications

### File Deletion from Target
For each branch, files from other festivals must be:
1. **Removed from Xcode project targets**
2. **Deleted from filesystem**

**Example for `Xcode03_Anv` branch**:

```bash
# Files to DELETE
ForavaApp/Services/BirthdayAIService.swift
ForavaApp/Services/ChineseNewYearAIService.swift
# ... (12 other AI services)

ForavaApp/Models/BirthdayModels.swift
ForavaApp/Models/ChineseNewYearModels.swift
# ... (12 other model files)

ForavaApp/Views/CulturalDesigns/Birthday/
ForavaApp/Views/CulturalDesigns/ChineseNewYear/
# ... (12 other festival directories)
```

### project.pbxproj Update
After file deletion, Xcode project file must be updated:
- Remove file references from `PBXFileReference` section
- Remove files from `PBXSourcesBuildPhase` section
- Update `PBXGroup` hierarchy

**Automated via**: `xcodebuild` clean + Xcode project regeneration

---

## Execution Plan

### Phase 1: Pre-Flight Checks ✈️

1. **Verify Current Branch**: Ensure `XCode03_All` is clean and pushed
2. **Create Backup**: Tag current state as `XCode03_All_backup`
3. **Build Verification**: Confirm `XCode03_All` builds successfully
4. **Document Festival Mapping**: Verify all 14 festivals exist (Holi check)

### Phase 2: Branch Creation Strategy 🌳

**Approach**: Automated script with manual verification per branch

#### Script Workflow (Per Festival):

```bash
#!/bin/bash
# Example for Anniversary branch

FESTIVAL_NAME="Anniversary"
BRANCH_NAME="Xcode03_Anv"
KEEP_DIR="Anniversary"
KEEP_MODEL="AnniversaryModels.swift"
KEEP_SERVICE="AnniversaryAIService.swift"

# Step 1: Create branch from XCode03_All
git checkout XCode03_All
git checkout -b ${BRANCH_NAME}

# Step 2: Delete other festival directories
cd ForavaApp/Views/CulturalDesigns
for dir in */; do
    if [[ "$dir" != "${KEEP_DIR}/" ]] && [[ "$dir" != "Shared/" ]]; then
        rm -rf "$dir"
    fi
done

# Step 3: Delete other festival models
cd ../../Models
for file in *Models.swift; do
    if [[ "$file" != "${KEEP_MODEL}" ]] && [[ "$file" != "Contact.swift" ]] && \
       [[ "$file" != "CoreTypes.swift" ]] && [[ "$file" != "CulturalEvent.swift" ]] && \
       [[ "$file" != "CulturalGiftModel.swift" ]] && [[ "$file" != "SharedCulturalTypes.swift" ]] && \
       [[ "$file" != "SocialSharingModels.swift" ]] && [[ "$file" != "SubscriptionModels.swift" ]]; then
        rm "$file"
    fi
done

# Step 4: Delete other festival AI services
cd ../Services
for file in *AIService.swift; do
    if [[ "$file" != "${KEEP_SERVICE}" ]] && [[ "$file" != "BaseCulturalAIService.swift" ]]; then
        rm "$file"
    fi
done

# Step 5: Modify CulturalEvent.swift (manual or scripted)
# This requires careful Swift code editing

# Step 6: Update Xcode project
cd ../../..
# Manual: Open Xcode, remove red file references, rebuild

# Step 7: Build verification
xcodebuild -project Forava.xcodeproj -scheme ForavaApp clean build \
    CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=""

# Step 8: Commit changes
git add .
git commit -m "Branch ${BRANCH_NAME}: Isolated ${FESTIVAL_NAME} cultural festival

- Removed 13 other festival implementations
- Modified CulturalEvent.swift to contain only ${FESTIVAL_NAME}
- Updated ContentView for single-festival navigation
- Cleaned Xcode project references

Branch contains standalone ${FESTIVAL_NAME} app ready for independent development.

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"

# Step 9: Push to GitHub
git push -u origin ${BRANCH_NAME}
```

### Phase 3: Execution Order 📋

**Recommended Order** (Start with most complete implementation):

1. ✅ **Xcode03_Anv** (Anniversary) - PRIORITY: Just optimized, most tested
2. ✅ **Xcode03_Rkb** (Raksha Bandhan) - Original stable foundation
3. ✅ **Xcode03_Bth** (Birthdays)
4. ✅ **Xcode03_Cny** (Chinese New Year)
5. ✅ **Xcode03_Csm** (Christmas)
6. ✅ **Xcode03_Dwl** (Diwali)
7. ✅ **Xcode03_Est** (Easter)
8. ✅ **Xcode03_Eaa** (Eid al-Adha)
9. ✅ **Xcode03_Eaf** (Eid al-Fitr) - NOTE: marked `isComingSoon: true`
10. ✅ **Xcode03_Hnk** (Hanukkah)
11. ⚠️  **XCode03_Hli** (Holi) - REQUIRES IMPLEMENTATION FIRST
12. ✅ **Xcode03_Maf** (Mid-Autumn Festival)
13. ✅ **Xcode03_Rsh** (Rosh Hashanah)
14. ✅ **Xcode03_Vsk** (Vesak Day)

### Phase 4: Validation Per Branch ✔️

After each branch creation:

1. **Build Verification**
   ```bash
   xcodebuild -project Forava.xcodeproj -scheme ForavaApp clean build \
       CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=""
   ```

2. **File Count Verification**
   ```bash
   # Should have exactly 1 festival directory
   ls -1 ForavaApp/Views/CulturalDesigns/ | grep -v Shared | wc -l
   # Expected: 1

   # Should have exactly 1 festival AI service
   ls -1 ForavaApp/Services/*AIService.swift | grep -v BaseCultural | wc -l
   # Expected: 1
   ```

3. **CulturalEvent.allEvents Verification**
   ```bash
   grep "CulturalEvent(" ForavaApp/Models/CulturalEvent.swift | wc -l
   # Expected: 1
   ```

4. **SwiftLint Check**
   ```bash
   /opt/homebrew/bin/swiftlint lint
   ```

5. **Git Status Clean**
   ```bash
   git status
   # Should show clean working directory after commit
   ```

### Phase 5: Post-Creation Verification 🔍

After all 14 branches created:

1. **Branch List Verification**
   ```bash
   git branch -r | grep "Xcode03_" | wc -l
   # Expected: 15 (14 cultural + 1 XCode03_All)
   ```

2. **GitHub Verification**
   - Visit https://github.com/KG191/Forava/branches
   - Confirm all 14 branches visible
   - Check last commit message for each

3. **Build Status Matrix**
   Create spreadsheet tracking:
   - Branch name
   - Build status (✅ SUCCESS / ❌ FAILED)
   - File count (views/models/services)
   - Last commit hash
   - Notes/issues

---

## Special Cases & Edge Cases

### Case 1: Holi Branch (XCode03_Hli)

**Problem**: Holi is defined in `CulturalEvent.swift` but has no implementation

**Options**:
1. **Skip** - Create only 13 branches, document Holi as future work
2. **Placeholder** - Create branch with minimal placeholder implementation
3. **Implement First** - Build complete Holi implementation before branching

**Recommendation**: Option 1 (Skip) - Create branch only when implementation exists

### Case 2: Eid al-Fitr (Xcode03_Eaf)

**Note**: Marked `isComingSoon: true` in `CulturalEvent.swift`

**Action**: Create branch normally, leave `isComingSoon` flag in place

### Case 3: Rakhi Legacy Files

**Problem**: Multiple Rakhi-related models exist:
- `RakhiDesignModels.swift`
- `RakhiModel.swift`
- `RakshaBandhanModels.swift`

**Solution for Xcode03_Rkb**: Keep all three, delete only in other branches

### Case 4: Shared Component Updates

**Scenario**: After branch creation, shared components need updates

**Strategy**:
- Update `XCode03_All` first
- Create script to merge shared component changes to all 14 branches
- Use `git cherry-pick` for targeted updates

---

## Risk Mitigation

### Risk 1: Xcode Project Corruption

**Mitigation**:
- Backup `Forava.xcodeproj/project.pbxproj` before each branch
- Use `git diff` to verify project file changes are only deletions
- Test build immediately after Xcode modifications

### Risk 2: Broken Navigation Flow

**Mitigation**:
- Create navigation test checklist per branch
- Manual test: Launch app → Select contact → Design → Generate → Share
- Automated: UI tests for navigation paths (future)

### Risk 3: Missing Dependencies

**Mitigation**:
- Verify all shared components present
- Check import statements in festival-specific files
- Build with verbose logging to catch missing references

### Risk 4: Asset Conflicts

**Mitigation**:
- Document required assets per festival
- Optionally delete unused assets to reduce app size
- Verify image loading in each branch

---

## Automation Scripts

### Master Script: `create_cultural_branches.sh`

```bash
#!/bin/bash

# Configuration
REPO_DIR="/Users/kirangokal/Documents/Forava/Forava02"
BASE_BRANCH="XCode03_All"

# Festival configurations (name:branch:dir:model:service)
declare -a FESTIVALS=(
    "Anniversary:Xcode03_Anv:Anniversary:AnniversaryModels.swift:AnniversaryAIService.swift"
    "Birthdays:Xcode03_Bth:Birthday:BirthdayModels.swift:BirthdayAIService.swift"
    "Chinese New Year:Xcode03_Cny:ChineseNewYear:ChineseNewYearModels.swift:ChineseNewYearAIService.swift"
    "Christmas:Xcode03_Csm:Christmas:ChristmasModels.swift:ChristmasAIService.swift"
    "Diwali:Xcode03_Dwl:Diwali:DiwaliModels.swift:DiwaliAIService.swift"
    "Easter:Xcode03_Est:Easter:EasterModels.swift:EasterAIService.swift"
    "Eid al-Adha:Xcode03_Eaa:EidAlAdha:EidAlAdhaModels.swift:EidAlAdhaAIService.swift"
    "Eid al-Fitr:Xcode03_Eaf:EidAlFitr:EidAlFitrModels.swift:EidAlFitrAIService.swift"
    "Hanukkah:Xcode03_Hnk:Hanukkah:HanukkahModels.swift:HanukkahAIService.swift"
    "Mid-Autumn Festival:Xcode03_Maf:MidAutumnFestival:MidAutumnFestivalModels.swift:MidAutumnFestivalAIService.swift"
    "Raksha Bandhan:Xcode03_Rkb:RakshaBandhan:RakshaBandhanModels.swift:RakshaBandhanAIService.swift"
    "Rosh Hashanah:Xcode03_Rsh:RoshHashanah:RoshHashanahModels.swift:RoshHashanahAIService.swift"
    "Vesak Day:Xcode03_Vsk:VesakDay:VesakDayModels.swift:VesakDayAIService.swift"
)

cd "$REPO_DIR" || exit 1

# Function to create single branch
create_festival_branch() {
    local festival_config=$1
    IFS=':' read -r NAME BRANCH DIR MODEL SERVICE <<< "$festival_config"

    echo "========================================="
    echo "Creating branch: $BRANCH ($NAME)"
    echo "========================================="

    # Checkout base and create new branch
    git checkout "$BASE_BRANCH"
    git checkout -b "$BRANCH"

    # Delete other festival directories
    # Delete other festival models
    # Delete other festival services
    # Modify CulturalEvent.swift
    # Update ContentView.swift
    # Clean Xcode project

    # Build verification
    xcodebuild -project Forava.xcodeproj -scheme ForavaApp clean build \
        CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY="" || {
        echo "❌ BUILD FAILED for $BRANCH"
        return 1
    }

    # Commit and push
    git add .
    git commit -m "Branch $BRANCH: Isolated $NAME cultural festival"
    git push -u origin "$BRANCH"

    echo "✅ $BRANCH created successfully"
}

# Execute for all festivals
for festival in "${FESTIVALS[@]}"; do
    create_festival_branch "$festival" || {
        echo "⚠️ Failed to create branch, continuing with next..."
    }
done

echo "========================================="
echo "Branch creation complete!"
echo "========================================="
```

### Helper Script: `modify_cultural_event.py`

```python
#!/usr/bin/env python3
"""
Script to modify CulturalEvent.swift to contain only specified festival
"""

import sys
import re

def filter_cultural_event(input_file, output_file, festival_name):
    with open(input_file, 'r') as f:
        content = f.read()

    # Find the allEvents array
    pattern = r'static let allEvents = \[(.*?)\]'
    match = re.search(pattern, content, re.DOTALL)

    if not match:
        print("ERROR: Could not find allEvents array")
        sys.exit(1)

    all_events = match.group(1)

    # Extract only the target festival
    festival_pattern = rf'CulturalEvent\([^)]*name: "{festival_name}"[^)]*\)'
    # ... (complex regex to extract single event)

    # Replace allEvents with filtered version
    # ... (implementation)

    with open(output_file, 'w') as f:
        f.write(modified_content)

if __name__ == "__main__":
    filter_cultural_event(sys.argv[1], sys.argv[2], sys.argv[3])
```

---

## Timeline Estimate

### Conservative Estimate (Manual Execution)
- **Per Branch**: 30-45 minutes (file deletion, modification, testing)
- **Total Time**: 14 branches × 40 min = **~9-10 hours**

### With Automation (Scripted)
- **Script Development**: 3-4 hours (one-time)
- **Per Branch Execution**: 10-15 minutes (mostly build time)
- **Total Time**: 4 hours (script) + (14 × 12 min) = **~7 hours**

### Recommended Approach
**Hybrid**: Manual for first 2 branches (Anniversary, Raksha Bandhan) to verify process, then automated script for remaining 12.

**Estimated Total**: **6-8 hours**

---

## Success Criteria

### Per Branch ✅
- [ ] Branch created and pushed to GitHub
- [ ] Contains exactly 1 cultural festival implementation
- [ ] Build succeeds with zero errors
- [ ] SwiftLint violations resolved or documented
- [ ] Navigation flow functional (landing → contact → design → generate)
- [ ] CulturalEvent.allEvents contains exactly 1 event
- [ ] Xcode project contains no red file references

### Overall Project ✅
- [ ] All 14 branches created (or 13 if skipping Holi)
- [ ] Each branch builds independently
- [ ] No cross-branch dependencies
- [ ] Documentation updated with branch structure
- [ ] Build status matrix created and verified
- [ ] GitHub repository organized with clear branch naming

---

## Next Steps After Branch Creation

1. **Create Branch Protection Rules**
   - Protect `XCode03_All` as master integration branch
   - Require pull requests for cultural branch modifications

2. **Set Up CI/CD Per Branch**
   - GitHub Actions workflow per cultural branch
   - Automated build verification on push
   - TestFlight deployment per festival (optional)

3. **Documentation Updates**
   - Update CLAUDE.md with branch structure
   - Create BRANCH_GUIDE.md explaining branch strategy
   - Document merge strategy for shared component updates

4. **Independent Development**
   - Each festival can now evolve independently
   - Specialized developers can focus on single culture
   - Faster iteration without cross-festival conflicts

---

## Appendix A: File Deletion Checklist

### Per Branch (Example: Anniversary)

**DELETE These Directories**:
```
ForavaApp/Views/CulturalDesigns/Birthday/
ForavaApp/Views/CulturalDesigns/ChineseNewYear/
ForavaApp/Views/CulturalDesigns/Christmas/
ForavaApp/Views/CulturalDesigns/Diwali/
ForavaApp/Views/CulturalDesigns/Easter/
ForavaApp/Views/CulturalDesigns/EidAlAdha/
ForavaApp/Views/CulturalDesigns/EidAlFitr/
ForavaApp/Views/CulturalDesigns/Hanukkah/
ForavaApp/Views/CulturalDesigns/MidAutumnFestival/
ForavaApp/Views/CulturalDesigns/RakshaBandhan/
ForavaApp/Views/CulturalDesigns/RoshHashanah/
ForavaApp/Views/CulturalDesigns/VesakDay/
```

**DELETE These Model Files**:
```
ForavaApp/Models/BirthdayModels.swift
ForavaApp/Models/ChineseNewYearModels.swift
ForavaApp/Models/ChristmasModels.swift
ForavaApp/Models/DiwaliModels.swift
ForavaApp/Models/EasterModels.swift
ForavaApp/Models/EidAlAdhaModels.swift
ForavaApp/Models/EidAlFitrModels.swift
ForavaApp/Models/EidAlFitrModels_BACKUP.swift
ForavaApp/Models/EidAlFitrModels_NEW.swift
ForavaApp/Models/HanukkahModels.swift
ForavaApp/Models/MidAutumnFestivalModels.swift
ForavaApp/Models/RakhiDesignModels.swift (UNLESS Raksha Bandhan branch)
ForavaApp/Models/RakhiModel.swift (UNLESS Raksha Bandhan branch)
ForavaApp/Models/RakshaBandhanModels.swift
ForavaApp/Models/RoshHashanahModels.swift
ForavaApp/Models/VesakDayModels.swift
```

**DELETE These Service Files**:
```
ForavaApp/Services/BirthdayAIService.swift
ForavaApp/Services/ChineseNewYearAIService.swift
ForavaApp/Services/ChristmasAIService.swift
ForavaApp/Services/DiwaliAIService.swift
ForavaApp/Services/EasterAIService.swift
ForavaApp/Services/EidAlAdhaAIService.swift
ForavaApp/Services/EidAlFitrAIService.swift
ForavaApp/Services/HanukkahAIService.swift
ForavaApp/Services/MidAutumnFestivalAIService.swift
ForavaApp/Services/RakshaBandhanAIService.swift
ForavaApp/Services/RoshHashanahAIService.swift
ForavaApp/Services/VesakDayAIService.swift
```

**KEEP These Files** (In ALL branches):
```
ForavaApp/Services/BaseCulturalAIService.swift
ForavaApp/Services/CulturalAIConfiguration.swift
ForavaApp/Models/Contact.swift
ForavaApp/Models/CoreTypes.swift
ForavaApp/Models/CulturalEvent.swift (MODIFIED)
ForavaApp/Models/CulturalGiftModel.swift
ForavaApp/Models/SharedCulturalTypes.swift
ForavaApp/Models/SocialSharingModels.swift
ForavaApp/Models/SubscriptionModels.swift
ForavaApp/Views/CulturalDesigns/Shared/ (ALL 6 files)
ForavaApp/Views/ContentView.swift (MODIFIED)
ForavaApp/Views/SettingsView.swift
ForavaApp/Views/ContactSelectionView.swift
ForavaApp/Views/CulturalCarouselView.swift (MODIFIED)
ForavaApp/Views/AnimatedTitleView.swift
```

---

## Appendix B: Testing Checklist Per Branch

### Build Testing
- [ ] Clean build succeeds (`xcodebuild clean build`)
- [ ] No compilation errors
- [ ] No critical SwiftLint violations
- [ ] Xcode opens project without errors

### Navigation Testing
- [ ] App launches successfully
- [ ] Landing page displays correctly
- [ ] Cultural event card/button visible
- [ ] Selecting event navigates to contact selection
- [ ] Contact selection loads properly
- [ ] Design view loads with correct festival theme
- [ ] All tabs functional (Style/Elements/Colors/Message)

### Generation Testing
- [ ] Generate button enabled after selections
- [ ] AI generation request sends successfully
- [ ] Progress indicator works
- [ ] Generated image displays correctly
- [ ] Image matches selected parameters (colors/elements/theme)

### Share Testing
- [ ] Share button functional
- [ ] Social sharing options appear
- [ ] Message includes correct festival context

---

## Appendix C: Quick Reference

### Command Cheat Sheet

```bash
# Create new branch
git checkout XCode03_All
git checkout -b Xcode03_Anv

# Build verification
xcodebuild -project Forava.xcodeproj -scheme ForavaApp clean build \
    CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=""

# SwiftLint check
/opt/homebrew/bin/swiftlint lint

# Count festival directories (should be 1)
ls -1 ForavaApp/Views/CulturalDesigns/ | grep -v Shared | wc -l

# Commit and push
git add .
git commit -m "Branch Xcode03_Anv: Isolated Anniversary"
git push -u origin Xcode03_Anv

# Return to base
git checkout XCode03_All
```

### File Paths

```
Models: /Users/kirangokal/Documents/Forava/Forava02/ForavaApp/Models/
Services: /Users/kirangokal/Documents/Forava/Forava02/ForavaApp/Services/
Views: /Users/kirangokal/Documents/Forava/Forava02/ForavaApp/Views/
Cultural: /Users/kirangokal/Documents/Forava/Forava02/ForavaApp/Views/CulturalDesigns/
```

---

## Document Version

- **Version**: 1.0
- **Created**: 2025-10-26
- **Last Updated**: 2025-10-26
- **Author**: Claude Code
- **Status**: DRAFT - Awaiting User Approval

---

## Approval & Execution

**User Decision Required**:
1. ✅ Approve plan as-is
2. ⚠️ Request modifications
3. ❌ Cancel branch separation

**Once Approved**:
- [ ] Begin with Xcode03_Anv (Anniversary) as pilot
- [ ] Verify pilot branch success before mass execution
- [ ] Execute remaining 13 branches
- [ ] Final verification and documentation

---

**END OF PLAN**
