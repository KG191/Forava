#!/usr/bin/env python3
import os
import re
import uuid

# Generate UUID for Xcode project files
def generate_uuid():
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

project_file = "Forava.xcodeproj/project.pbxproj"

# Service files to add that are missing from build target
service_files = [
    ("ForavaApp/Services/SubscriptionManager.swift", "SubscriptionManager.swift"),
    ("ForavaApp/Services/CulturalSystemMigrationService.swift", "CulturalSystemMigrationService.swift"),
    ("ForavaApp/Services/DynamicCulturalTerminologyService.swift", "DynamicCulturalTerminologyService.swift"),
    ("ForavaApp/Services/GlobalTerminologyUpdateService.swift", "GlobalTerminologyUpdateService.swift"),
    ("ForavaApp/Services/CulturalContextManager.swift", "CulturalContextManager.swift"),
    ("ForavaApp/Services/CulturalDesignAgentService.swift", "CulturalDesignAgentService.swift"),
    ("ForavaApp/Services/CulturalConfiguration.swift", "CulturalConfiguration.swift"),
    ("ForavaApp/Models/CulturalFramework.swift", "CulturalFramework.swift"),
    ("ForavaApp/Models/CulturalValidator.swift", "CulturalValidator.swift"),
]

print(f"Adding {len(service_files)} service files to Xcode project...")

# Read the current project file
with open(project_file, 'r') as f:
    content = f.read()

# Generate UUIDs for each file
file_refs = {}
build_files = {}

for file_path, file_name in service_files:
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
        new_entry = f'\t\t{file_ref_id} /* {file_name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {file_name}; sourceTree = "<group>"; }};\n'
        file_ref_content += new_entry
    
    # Replace the section
    content = content.replace(file_ref_section.group(0), 
                             file_ref_section.group(1) + file_ref_content + file_ref_section.group(3))

# Find the Sources build phase and add new files
sources_build_phase_pattern = r'(sources = \()[^)]*(\);)'
sources_matches = re.findall(sources_build_phase_pattern, content, re.DOTALL)

if sources_matches:
    # Find the ForavaApp target's sources build phase (usually the first one)
    sources_pattern = r'(sources = \([^)]*?)(\);)'
    def add_sources(match):
        sources_content = match.group(1)
        closing = match.group(2)
        
        # Add each build file to sources
        for file_name, build_file_id in build_files.items():
            sources_content += f'\n\t\t\t\t{build_file_id} /* {file_name} in Sources */,'
        
        return sources_content + closing
    
    # Replace only the first sources section (ForavaApp target)
    content = re.sub(sources_pattern, add_sources, content, count=1)

# Write the updated project file
with open(project_file, 'w') as f:
    f.write(content)

print("✅ Successfully added service files to Xcode project!")
print("Files added:")
for file_path, file_name in service_files:
    print(f"  - {file_name}")
print("\nYou may need to clean and rebuild the project.")