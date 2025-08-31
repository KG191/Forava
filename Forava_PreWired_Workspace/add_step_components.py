#!/usr/bin/env python3
import os
import re
import uuid

# Generate UUID for Xcode project files
def generate_uuid():
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

project_file = "Forava.xcodeproj/project.pbxproj"

# Files to add - the missing step components
new_files = [
    ("ForavaApp/Views/DesignSteps/CulturalElementSelectionStep.swift", "CulturalElementSelectionStep.swift"),
    ("ForavaApp/Views/DesignSteps/CulturalColorSelectionStep.swift", "CulturalColorSelectionStep.swift"),
    ("ForavaApp/Views/DesignSteps/CulturalPersonalizationStep.swift", "CulturalPersonalizationStep.swift"),
    ("ForavaApp/Views/DesignSteps/CulturalPreviewStep.swift", "CulturalPreviewStep.swift"),
]

# Read the current project file
with open(project_file, 'r') as f:
    content = f.read()

# Generate UUIDs for each file
file_refs = {}
build_files = {}

for file_path, file_name in new_files:
    file_ref_id = generate_uuid()
    build_file_id = generate_uuid()
    file_refs[file_name] = (file_ref_id, file_path)
    build_files[file_name] = build_file_id

# Find the PBXBuildFile section and add new entries
build_file_section = re.search(r'(/\* Begin PBXBuildFile section \*/)(.*?)(/\* End PBXBuildFile section \*/)', content, re.DOTALL)
if build_file_section:
    build_file_content = build_file_section.group(2)
    
    # Add new build file entries
    for file_name, build_file_id in build_files.items():
        file_ref_id = file_refs[file_name][0]
        new_entry = f'\t\t{build_file_id} /* {file_name} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {file_name} */; }};\n'
        build_file_content += new_entry
    
    # Replace the section
    content = content.replace(build_file_section.group(0), 
                             build_file_section.group(1) + build_file_content + build_file_section.group(3))

# Find the PBXFileReference section and add new entries
file_ref_section = re.search(r'(/\* Begin PBXFileReference section \*/)(.*?)(/\* End PBXFileReference section \*/)', content, re.DOTALL)
if file_ref_section:
    file_ref_content = file_ref_section.group(2)
    
    # Add new file reference entries
    for file_name, (file_ref_id, file_path) in file_refs.items():
        new_entry = f'\t\t{file_ref_id} /* {file_name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {file_path}; sourceTree = "<group>"; }};\n'
        file_ref_content += new_entry
    
    # Replace the section
    content = content.replace(file_ref_section.group(0), 
                             file_ref_section.group(1) + file_ref_content + file_ref_section.group(3))

# Find the DesignSteps group and add new files to it
designsteps_group_pattern = r'(21C93A4C2E5C568C00200285 /\* DesignSteps \*/ = {[^}]*children = \()[^)]*(\);)'
designsteps_match = re.search(designsteps_group_pattern, content, re.DOTALL)

if designsteps_match:
    existing_children = designsteps_match.group(0)
    # Add new file references to the children array
    new_children_content = existing_children
    for file_name, (file_ref_id, _) in file_refs.items():
        new_children_content = new_children_content.replace(
            ');',
            f'\t\t\t\t{file_ref_id} /* {file_name} */,\n\t\t\t);'
        )
    content = content.replace(existing_children, new_children_content)

# Find the ForavaApp target's Sources build phase and add new files
sources_build_phase_pattern = r'(A1FC /\* Sources \*/ = {[^}]*files = \()[^)]*(\);)'
sources_match = re.search(sources_build_phase_pattern, content, re.DOTALL)

if sources_match:
    existing_sources = sources_match.group(0)
    new_sources_content = existing_sources
    for file_name, build_file_id in build_files.items():
        new_sources_content = new_sources_content.replace(
            ');',
            f'\t\t\t\t{build_file_id} /* {file_name} in Sources */,\n\t\t\t);'
        )
    content = content.replace(existing_sources, new_sources_content)

# Write the updated project file
with open(project_file, 'w') as f:
    f.write(content)

print("Successfully added step components to Xcode project!")
print("Files added:")
for file_path, file_name in new_files:
    print(f"  - {file_name}")

