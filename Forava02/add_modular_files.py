#!/usr/bin/env python3
import os
import re
import uuid

# Generate UUID for Xcode project files
def generate_uuid():
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

project_file = "Forava.xcodeproj/project.pbxproj"

# New modular files to add
new_files = [
    # Shared components
    ("ForavaApp/Views/CulturalDesigns/Shared/CulturalDesignProtocol.swift", "CulturalDesignProtocol.swift"),
    ("ForavaApp/Views/CulturalDesigns/Shared/CulturalDesignComponents.swift", "CulturalDesignComponents.swift"),
    ("ForavaApp/Views/CulturalDesigns/Shared/CulturalDesignViewModel.swift", "CulturalDesignViewModel.swift"),
    
    # Christmas component
    ("ForavaApp/Views/CulturalDesigns/Christmas/ChristmasDesignView.swift", "ChristmasDesignView.swift"),
    
    # New coordinator
    ("ForavaApp/Views/CulturalGiftDesignView_New.swift", "CulturalGiftDesignView_New.swift"),
]

print(f"Adding {len(new_files)} new modular files to Xcode project...")

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
    print("✅ Added PBXBuildFile entries")

# Find the PBXFileReference section and add new entries
file_ref_section = re.search(r'(/\* Begin PBXFileReference section \*/)(.*?)(/\* End PBXFileReference section \*/)', content, re.DOTALL)
if file_ref_section:
    file_ref_content = file_ref_section.group(2)
    
    # Add new file reference entries
    for file_name, (file_ref_id, file_path) in file_refs.items():
        # Get just the filename from the full path
        filename_only = file_path.split('/')[-1]
        new_entry = f'\t\t{file_ref_id} /* {file_name} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {filename_only}; sourceTree = "<group>"; }};\n'
        file_ref_content += new_entry
    
    # Replace the section
    content = content.replace(file_ref_section.group(0), 
                             file_ref_section.group(1) + file_ref_content + file_ref_section.group(3))
    print("✅ Added PBXFileReference entries")

# Find groups and add files to appropriate groups
# This is a simplified approach - in reality, you'd want to create proper group hierarchy

# Find any existing group pattern and add our files there
# Look for a Views group or similar
views_group_pattern = r'(\/\* Views \*\/ = {[^}]*children = \([^)]*)'
views_match = re.search(views_group_pattern, content, re.DOTALL)

if views_match:
    print("✅ Found Views group, adding files")
    existing_views = views_match.group(1)
    new_views_content = existing_views
    for file_name, (file_ref_id, _) in file_refs.items():
        new_views_content += f'\n\t\t\t\t{file_ref_id} /* {file_name} */,'
    content = content.replace(existing_views, new_views_content)
else:
    print("⚠️ Views group not found, will add to ForavaApp group")
    # Fall back to adding to ForavaApp group
    foravaapp_pattern = r'(\w+ \/\* ForavaApp \*\/ = {[^}]*children = \([^)]*)'
    foravaapp_match = re.search(foravaapp_pattern, content, re.DOTALL)
    
    if foravaapp_match:
        existing_foravaapp = foravaapp_match.group(1)
        new_foravaapp_content = existing_foravaapp
        for file_name, (file_ref_id, _) in file_refs.items():
            new_foravaapp_content += f'\n\t\t\t\t{file_ref_id} /* {file_name} */,'
        content = content.replace(existing_foravaapp, new_foravaapp_content)
        print("✅ Added to ForavaApp group")

# Find the ForavaApp target's Sources build phase and add new files
sources_pattern = r'(\w+ \/\* Sources \*\/ = {[^}]*files = \([^)]*)'
sources_match = re.search(sources_pattern, content, re.DOTALL)

if sources_match:
    existing_sources = sources_match.group(1)
    new_sources_content = existing_sources
    for file_name, build_file_id in build_files.items():
        new_sources_content += f'\n\t\t\t\t{build_file_id} /* {file_name} in Sources */,'
    content = content.replace(existing_sources, new_sources_content)
    print("✅ Added to Sources build phase")

# Write the updated project file
with open(project_file, 'w') as f:
    f.write(content)

print("\n🎉 Successfully added new modular files to Xcode project!")
print("Files added:")
for file_path, file_name in new_files:
    print(f"  - {file_name} ({file_path})")

print("\n📝 Next steps:")
print("1. Open Forava.xcodeproj in Xcode")
print("2. Verify all new files are visible in the project navigator")
print("3. Build the project to check for any compilation errors")
print("4. Test the Christmas design component")