#!/usr/bin/env python3
"""
Add SharedModels.swift to ForavaWatch target
"""

import re
import uuid

# Read the project file
with open('Forava.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# Generate a unique ID for the Watch target build file reference
watch_build_id = str(uuid.uuid4()).replace('-', '').upper()[:24]

# Find the existing file reference for SharedModels.swift
file_ref_match = re.search(r'(\w+) /\* SharedModels\.swift \*/ = \{isa = PBXFileReference', content)
if not file_ref_match:
    print("❌ Could not find SharedModels.swift file reference")
    exit(1)

file_ref_id = file_ref_match.group(1)
print(f"📁 Found SharedModels.swift file reference: {file_ref_id}")

# Add a new PBXBuildFile entry for the Watch target
build_file_line = f'\t\t{watch_build_id} /* SharedModels.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* SharedModels.swift */; }};\n'

# Find the PBXBuildFile section and add the new entry
build_file_section_end = content.find('/* End PBXBuildFile section */')
if build_file_section_end == -1:
    print("❌ Could not find PBXBuildFile section")
    exit(1)

content = content[:build_file_section_end] + build_file_line + content[build_file_section_end:]
print(f"✅ Added PBXBuildFile entry for Watch target: {watch_build_id}")

# Find the ForavaWatch Sources build phase and add the file
# Look for the Sources build phase in ForavaWatch target
watch_sources_pattern = r'(\w{24}) /\* Sources \*/ = \{\s*isa = PBXSourcesBuildPhase;\s*buildActionMask = [^;]*;\s*files = \(\s*([^)]*)\s*\);'
watch_sources_match = re.search(watch_sources_pattern, content, re.DOTALL)

if watch_sources_match:
    sources_id = watch_sources_match.group(1)
    current_files = watch_sources_match.group(2)
    
    # Add our new build file reference
    new_files = current_files.rstrip() + f'\n\t\t\t\t{watch_build_id} /* SharedModels.swift in Sources */,'
    
    # Replace the sources section
    old_sources = watch_sources_match.group(0)
    new_sources = f'{sources_id} /* Sources */ = {{\n\t\t\tisa = PBXSourcesBuildPhase;\n\t\t\tbuildActionMask = 2147483647;\n\t\t\tfiles = ({new_files}\n\t\t\t);'
    
    content = content.replace(old_sources, new_sources)
    print(f"✅ Added SharedModels.swift to ForavaWatch Sources build phase")
else:
    print("❌ Could not find ForavaWatch Sources build phase")
    exit(1)

# Write the updated project file
with open('Forava.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

print("🎉 SharedModels.swift successfully added to ForavaWatch target!")
print("📱 Watch app should now have access to RitualToken and GiftKind types")