#!/usr/bin/env python3
"""
Add Contact.swift to Xcode project targets
"""

import os
import subprocess
import uuid

# Change to project directory
os.chdir('/Users/kirangokal/Documents/Forava/Forava02')

# Generate unique IDs for the file reference and build references
file_ref_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
ios_build_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
watch_build_id = str(uuid.uuid4()).replace('-', '').upper()[:24]

# Read the current project file
with open('Forava.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# Add file reference in PBXFileReference section
file_ref_line = f'\t\t{file_ref_id} /* Contact.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Contact.swift; sourceTree = "<group>"; }};'

# Find the Models section and add the reference
models_section_start = content.find('/* Models */ = {')
if models_section_start != -1:
    children_start = content.find('children = (', models_section_start)
    if children_start != -1:
        # Find the end of the children array for Models
        children_end = content.find(');', children_start)
        # Insert the Contact.swift reference before the closing );
        insert_pos = children_end
        content = content[:insert_pos] + f'\t\t\t\t{file_ref_id} /* Contact.swift */,\n' + content[insert_pos:]

# Add build file references in PBXBuildFile section
build_file_section = content.find('/* Begin PBXBuildFile section */')
if build_file_section != -1:
    section_end = content.find('/* End PBXBuildFile section */', build_file_section)
    ios_build_line = f'\t\t{ios_build_id} /* Contact.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* Contact.swift */; }};\n'
    watch_build_line = f'\t\t{watch_build_id} /* Contact.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* Contact.swift */; }};\n'
    
    content = content[:section_end] + ios_build_line + watch_build_line + content[section_end:]

# Add file reference to PBXFileReference section
file_ref_section = content.find('/* End PBXBuildFile section */')
if file_ref_section != -1:
    next_section = content.find('/* Begin', file_ref_section + 1)
    content = content[:next_section] + file_ref_line + '\n' + content[next_section:]

# Add to ForavaApp target Sources
foravaapp_sources = content.find('/* ForavaApp */ = {')
if foravaapp_sources != -1:
    sources_start = content.find('files = (', foravaapp_sources)
    if sources_start != -1:
        sources_end = content.find(');', sources_start)
        content = content[:sources_end] + f'\t\t\t\t{ios_build_id} /* Contact.swift in Sources */,\n' + content[sources_end:]

# Add to ForavaWatch target Sources  
foravawatch_sources = content.find('/* ForavaWatch */ = {')
if foravawatch_sources != -1:
    sources_start = content.find('files = (', foravawatch_sources)
    if sources_start != -1:
        sources_end = content.find(');', sources_start)
        content = content[:sources_end] + f'\t\t\t\t{watch_build_id} /* Contact.swift in Sources */,\n' + content[sources_end:]

# Write the updated project file
with open('Forava.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

print("✅ Contact.swift added to both ForavaApp and ForavaWatch targets")