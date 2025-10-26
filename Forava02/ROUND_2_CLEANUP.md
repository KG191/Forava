# Round 2: Xcode Cleanup Required

## What Just Happened

After your first round of manual cleanup, the build revealed more legacy Rakhi files that needed deletion. I've now deleted them from the filesystem, but Xcode still has references to them.

## Files Just Deleted

### Directories:
- `ForavaApp/Views/DesignSteps/` (5 Swift files)
- `ForavaApp/Views/Sharing/`
- `ForavaApp/Views/History/`

### Files:
- `RealTimeGenerationView.swift`

These were all legacy files from the original Rakhi app that aren't needed for Anniversary.

## Quick Cleanup Instructions

1. **Refresh Xcode** (if already open):
   - File → Close Workspace
   - Re-open: `open Forava.xcodeproj`

2. **You'll now see 7 new RED file references**:
   - `ColorSelectionStep.swift`
   - `ElementSelectionStep.swift`
   - `GenreSelectionStep.swift`
   - `PersonalizationStep.swift`
   - `PreviewStep.swift`
   - `RealTimeGenerationView.swift`
   - `SocialSharingView.swift`

3. **Remove them**:
   - Select all 7 red files
   - Right-click → Delete → "Remove Reference"

4. **Clean & Build**:
   - Product → Clean Build Folder (⇧⌘K)
   - Product → Build (⌘B)

5. **If build succeeds, commit**:
   ```bash
   cd /Users/kirangokal/Documents/Forava/Forava02
   git add Forava.xcodeproj/project.pbxproj
   git commit -m "Round 2: Removed legacy Rakhi file references from Xcode project"
   git push
   ```

## Expected Result

After this cleanup, the Anniversary branch should build successfully with:
- ✅ Only Anniversary cultural design views
- ✅ Only AnniversaryAIService + BaseCulturalAIService
- ✅ Shared components intact
- ✅ No Rakhi legacy code

## If More Errors Appear

If there are still build errors after this cleanup, let me know what they are and I'll delete the remaining legacy files.
