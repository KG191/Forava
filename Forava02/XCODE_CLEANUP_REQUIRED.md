# Xcode Project Cleanup Required - Branch Xcode03_Anv

## Status
✅ Filesystem cleanup complete - all other festival files deleted
⚠️  Xcode project file still references deleted files
❌ Build currently fails due to missing file references

## What Was Done
- Deleted 12 festival view directories (kept Anniversary + Shared)
- Deleted 13 festival model files (kept AnniversaryModels.swift + shared models)
- Modified `CulturalEvent.swift` to contain only Anniversary event
- Updated `ContentView.swift` for Anniversary-only display

## Manual Steps Required

### Option 1: Open Xcode and Clean Up (Recommended)
1. Open the project in Xcode:
   ```bash
   cd /Users/kirangokal/Documents/Forava/Forava02
   open Forava.xcodeproj
   ```

2. In Xcode Project Navigator, you'll see RED file references for deleted files

3. Select all red files and press DELETE → Choose "Remove Reference"

4. Clean build folder: Product → Clean Build Folder (⇧⌘K)

5. Build the project: Product → Build (⌘B)

6. Verify build succeeds

7. Close Xcode, then commit the updated project file:
   ```bash
   git add Forava.xcodeproj/project.pbxproj
   git commit -m "Clean up Xcode project references for Anniversary-only branch"
   git push -u origin Xcode03_Anv
   ```

### Option 2: Alternative - Let Me Handle It
If you prefer automated cleanup, I can attempt to modify the project.pbxproj file programmatically (riskier but faster).

##Files to Remove from Xcode Project

The following files need to be removed from project references:

### Models (13 files)
- BirthdayModels.swift
- ChineseNewYearModels.swift
- ChristmasModels.swift
- DiwaliModels.swift
- EasterModels.swift
- EidAlAdhaModels.swift
- EidAlFitrModels.swift
- EidAlFitrModels_BACKUP.swift
- EidAlFitrModels_NEW.swift
- HanukkahModels.swift
- MidAutumnFestivalModels.swift
- RakhiDesignModels.swift
- RakhiModel.swift
- RakshaBandhanModels.swift
- RoshHashanahModels.swift
- VesakDayModels.swift

### View Directories (12 directories + all files within)
- Birthday/
- ChineseNewYear/
- Christmas/
- Diwali/
- Easter/
- EidAlAdha/
- EidAlFitr/
- Hanukkah/
- MidAutumnFestival/
- RakshaBandhan/
- RoshHashanah/
- VesakDay/

## Verification Checklist

After cleanup:
- [ ] No red file references in Xcode Project Navigator
- [ ] Build succeeds (⌘B) with zero errors
- [ ] Only Anniversary and Shared folders visible in CulturalDesigns
- [ ] Only AnniversaryModels.swift in Models (plus shared models)
- [ ] `CulturalEvent.allEvents` contains 1 event (verify in code)
- [ ] App launches successfully in simulator

## Next Steps After Cleanup

Once Xcode project is clean and building:
1. Push to GitHub: `git push -u origin Xcode03_Anv`
2. Verify on GitHub: https://github.com/KG191/Forava/tree/Xcode03_Anv
3. Mark pilot complete
4. Proceed with remaining 12 branches using same process

---

**Current Branch**: Xcode03_Anv
**Commit**: 6b4a001
**Status**: Awaiting manual Xcode cleanup

## Update: Attempted Automated Cleanup

**Date**: 2025-10-26 16:51

### What Was Attempted
Programmatic editing of `project.pbxproj` file to remove deleted file references.

### Result
❌ **FAILED** - Project file became corrupted
✅ **RESTORED** from backup

### Additional Files Deleted
- AIRakhiService.swift
- RakhiHistoryService.swift
- GeneratedRakhiView.swift
- RakhiSelectionView.swift  
- RakhiHistoryView.swift
- RakhiDesignStudioView.swift
- AdvancedCustomizationView.swift (entire Customization/ directory)

These are legacy files from the original Rakhi app that aren't needed for Anniversary.

### Conclusion
**Manual Xcode cleanup is REQUIRED** and is the safest approach.

Programmatic editing of project.pbxproj is too risky and leads to corruption.

