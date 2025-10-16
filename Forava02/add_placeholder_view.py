#!/usr/bin/env python3

import uuid

# Read the project file
with open('Forava.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# Generate unique IDs
file_ref_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
ios_build_id = str(uuid.uuid4()).replace('-', '').upper()[:24]

# Add file reference
file_ref_line = f'\t\t{file_ref_id} /* PlaceholderCulturalView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PlaceholderCulturalView.swift; sourceTree = "<group>"; }};'

# Add build file reference
build_file_line = f'\t\t{ios_build_id} /* PlaceholderCulturalView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* PlaceholderCulturalView.swift */; }};\n'

# Find the Shared group and add the file reference
shared_group_start = content.find('21120D042E659D3F00555EA5 /* Shared */ = {')
if shared_group_start != -1:
    children_start = content.find('children = (', shared_group_start)
    children_end = content.find(');', children_start)
    content = content[:children_end] + f'\t\t\t\t{file_ref_id} /* PlaceholderCulturalView.swift */,\n' + content[children_end:]

# Add build file to PBXBuildFile section
build_file_section_end = content.find('/* End PBXBuildFile section */')
content = content[:build_file_section_end] + build_file_line + content[build_file_section_end:]

# Add file reference to PBXFileReference section  
file_ref_section_end = content.find('/* End PBXFileReference section */')
content = content[:file_ref_section_end] + file_ref_line + '\n' + content[file_ref_section_end:]

# Add to ForavaApp Sources
foravaapp_sources_start = content.find('21C93BB52E615BB800200285 /* Sources */ = {')
if foravaapp_sources_start != -1:
    files_start = content.find('files = (', foravaapp_sources_start)
    files_end = content.find(');', files_start)
    content = content[:files_end] + f'\t\t\t\t{ios_build_id} /* PlaceholderCulturalView.swift in Sources */,\n' + content[files_end:]

# Write updated project file
with open('Forava.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

print("✅ PlaceholderCulturalView.swift added to Xcode project")