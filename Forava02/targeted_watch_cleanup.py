#!/usr/bin/env python3
"""
Remove specific iOS file references from ForavaWatch target
"""

import re

# Read the project file
with open('Forava.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# Specific build file IDs that need to be removed from Watch target
# These are the ones that showed up in the error output
watch_build_ids_to_remove = [
    '21120D092E659D3F00555EA5',  # CulturalDesignViewModel.swift
    '21120D0F2E659D3F00555EA5',  # CulturalDesignComponents.swift  
    '21120D102E659D3F00555EA5',  # CulturalDesignProtocol.swift
    '21120D122E659D8000555EA5',  # ChineseNewYearDesignView.swift
    '21120D132E659D8000555EA5',  # ChineseNewYearDesignView.swift (duplicate)
    '21120D152E659D9900555EA5',  # ChristmasDesignView.swift
    '21120D162E659D9900555EA5',  # ChristmasDesignView.swift (duplicate)
    '21120D182E659DAE00555EA5',  # DiwaliDesignView.swift
    '21120D192E659DAE00555EA5'   # DiwaliDesignView.swift (duplicate)
]

print("🔍 Removing specific build file references from ForavaWatch target...")

original_length = len(content)
removed_count = 0

for build_id in watch_build_ids_to_remove:
    # Remove from Sources build phase (where it appears in files = ( ... ) arrays)
    # Look for lines like: "				21120D092E659D3F00555EA5 /* CulturalDesignViewModel.swift in Sources */,"
    pattern1 = rf'\s*{build_id} /\* [^*]+ in Sources \*/,?\s*\n'
    if build_id in content:
        content = re.sub(pattern1, '', content)
        removed_count += 1
        print(f"✅ Removed build file reference {build_id}")

# Also remove any PBXBuildFile entries that are Watch-only
# These are the lines like: "21120D092E659D3F00555EA5 /* CulturalDesignViewModel.swift in Sources */ = {isa = PBXBuildFile; fileRef = ...; };"
watch_only_build_files = [
    '21120D092E659D3F00555EA5',  # CulturalDesignViewModel Watch build
    '21120D132E659D8000555EA5',  # ChineseNewYear Watch build
    '21120D162E659D9900555EA5',  # Christmas Watch build  
    '21120D192E659DAE00555EA5'   # Diwali Watch build
]

for build_id in watch_only_build_files:
    pattern2 = rf'\s*{build_id} /\* [^*]+ in Sources \*/ = \{{isa = PBXBuildFile; fileRef = [^;]+; \}};\s*\n'
    if build_id in content:
        content = re.sub(pattern2, '', content)
        print(f"✅ Removed PBXBuildFile entry {build_id}")

# Write the updated project file
with open('Forava.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

new_length = len(content)
print(f"🧹 Project file reduced by {original_length - new_length} characters")
print(f"✅ Completed cleanup of {removed_count} build file references")
print("📱 ForavaWatch target should now build without iOS-specific files")