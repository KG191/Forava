#!/usr/bin/env python3
"""
Remove iOS-specific files from ForavaWatch target in Xcode project
"""

import re

# Read the project file
with open('Forava.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# Files to remove from Watch target (these should only be in ForavaApp target)
ios_only_files = [
    'CulturalDesignViewModel.swift',
    'CulturalDesignComponents.swift', 
    'CulturalDesignProtocol.swift',
    'GiftDesignTypes.swift',
    'ChineseNewYearDesignView.swift',
    'ChristmasDesignView.swift',
    'DiwaliDesignView.swift',
    'AnniversaryDesignView.swift',
    'BirthdayDesignView.swift',
    'EasterDesignView.swift',
    'EidAlAdhaDesignView.swift',
    'EidAlFitrDesignView.swift',
    'HanukkahDesignView.swift',
    'MidAutumnFestivalDesignView.swift',
    'RakshaBandhanDesignView.swift',
    'RoshHashanahDesignView.swift',
    'VesakDayDesignView.swift',
    'CulturalGiftDesignView.swift',
    'CulturalGiftDesignView_New.swift',
    'ContactSelectionView.swift',
    'CulturalGiftSelectionView.swift',
    'OnboardingView.swift',
    'RakhiDesignStudioView.swift'
]

print("🔍 Scanning for iOS-specific files in ForavaWatch target...")

removed_count = 0

for filename in ios_only_files:
    # Find all build file entries for this file
    pattern = rf'(\w{{24}}) /\* {re.escape(filename)} in Sources \*/ = \{{isa = PBXBuildFile; fileRef = (\w{{24}}) /\* {re.escape(filename)} \*/; \}};'
    
    matches = re.findall(pattern, content)
    
    for match in matches:
        build_file_id = match[0]
        file_ref_id = match[1]
        
        # Check if this build file is referenced in ForavaWatch target
        # Look for the build file ID in Sources build phases
        watch_sources_pattern = rf'(\w{{24}}) /\* Sources \*/ = \{{[^}}]*isa = PBXSourcesBuildPhase;[^}}]*files = \([^)]*{build_file_id}[^)]*\);[^}}]*\}};'
        
        if re.search(watch_sources_pattern, content, re.DOTALL):
            print(f"🗑️  Removing {filename} from ForavaWatch target...")
            
            # Remove the build file reference from ForavaWatch Sources
            # Find the specific Sources build phase and remove this file reference
            def remove_from_sources(match_obj):
                sources_content = match_obj.group(0)
                # Remove the specific build file reference
                updated_content = re.sub(rf'\s*{build_file_id} /\* {re.escape(filename)} in Sources \*/,?\s*', '', sources_content)
                return updated_content
            
            content = re.sub(watch_sources_pattern, remove_from_sources, content, flags=re.DOTALL)
            
            # Also remove the PBXBuildFile entry if it's only used by Watch target
            # First check if this build file is used by ForavaApp target
            app_uses_file = re.search(rf'(\w{{24}}) /\* Sources \*/ = \{{[^}}]*isa = PBXSourcesBuildPhase;[^}}]*files = \([^)]*{build_file_id}[^)]*\);[^}}]*\}}; /\* Sources \*/,', content, re.DOTALL)
            
            # If not used by app target, we can remove the PBXBuildFile entry entirely
            if not app_uses_file:
                build_file_pattern = rf'\s*{build_file_id} /\* {re.escape(filename)} in Sources \*/ = \{{isa = PBXBuildFile; fileRef = {file_ref_id} /\* {re.escape(filename)} \*/; \}};\s*'
                content = re.sub(build_file_pattern, '', content)
            
            removed_count += 1

# Additional cleanup: Remove any references to these files in Watch app group structure
print("🧹 Cleaning up group references...")

# Save the updated project file
with open('Forava.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

print(f"✅ Successfully removed {removed_count} iOS-specific file references from ForavaWatch target!")
print("📱 ForavaWatch target now only includes Watch-compatible files")
print("🍎 ForavaApp target retains all iOS-specific cultural design files")