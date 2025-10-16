#!/usr/bin/env python3
"""
Simple script to add SharedModels.swift to Watch target
"""

import uuid

# Read the project file
with open('Forava.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# Generate a unique build file ID for Watch target
watch_build_id = 'C' + str(uuid.uuid4()).replace('-', '').upper()[:3]  # Keep it short like C005

print(f"📱 Adding SharedModels.swift to Watch target with ID: {watch_build_id}")

# 1. Add a new PBXBuildFile entry
build_file_line = f'\t\t{watch_build_id} /* SharedModels.swift in Sources */ = {{isa = PBXBuildFile; fileRef = C004 /* SharedModels.swift */; }};\n'

# Find where to insert it (after the last PBXBuildFile entry)
last_build_file_pos = content.rfind('/* End PBXBuildFile section */')
content = content[:last_build_file_pos] + build_file_line + content[last_build_file_pos:]

print(f"✅ Added PBXBuildFile entry: {watch_build_id}")

# 2. Add to the Watch target Sources build phase (B1FC)
# Find the Watch Sources section
watch_sources_start = content.find('B1FC /* Sources */ = {')
if watch_sources_start != -1:
    # Find the files array
    files_start = content.find('files = (', watch_sources_start)
    files_end = content.find(');', files_start)
    
    # Add our build file reference before the closing );
    new_line = f'\t\t\t\t{watch_build_id} /* SharedModels.swift in Sources */,\n'
    content = content[:files_end] + f'\t\t\t\t{new_line}' + content[files_end:]
    
    print(f"✅ Added to Watch Sources build phase: {watch_build_id}")
else:
    print("❌ Could not find Watch Sources build phase")
    exit(1)

# Write the updated project file
with open('Forava.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

print("🎉 SharedModels.swift successfully added to ForavaWatch target!")
print("📱 Watch app should now have access to RitualToken and GiftKind types")