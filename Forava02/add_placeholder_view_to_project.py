#!/usr/bin/env python3
"""
Add the placeholder cultural gift design view to the Xcode project.
"""

import uuid

def add_placeholder_to_project():
    project_file = "Forava.xcodeproj/project.pbxproj"
    
    # Generate UUIDs for the new file
    file_ref_uuid = str(uuid.uuid4()).replace('-', '')[:24].upper()
    build_file_uuid = str(uuid.uuid4()).replace('-', '')[:24].upper()
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Add PBXBuildFile entry
    build_file_entry = f'\t\t{build_file_uuid} /* PlaceholderCulturalGiftDesignView.swift in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_uuid} /* PlaceholderCulturalGiftDesignView.swift */; }};'
    
    # Find a place to insert the build file entry
    build_file_section = '/* Begin PBXBuildFile section */'
    content = content.replace(build_file_section, f'{build_file_section}\n{build_file_entry}')
    
    # Add PBXFileReference entry
    file_ref_entry = f'\t\t{file_ref_uuid} /* PlaceholderCulturalGiftDesignView.swift */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PlaceholderCulturalGiftDesignView.swift; sourceTree = "<group>"; }};'
    
    # Find a place to insert the file reference
    file_ref_section = '/* Begin PBXFileReference section */'
    content = content.replace(file_ref_section, f'{file_ref_section}\n{file_ref_entry}')
    
    # Add to Views group
    views_group_pattern = '21C93B7B2E5FE78800200285 /* SharedUIComponents.swift */,'
    replacement = f'21C93B7B2E5FE78800200285 /* SharedUIComponents.swift */,\n\t\t\t\t{file_ref_uuid} /* PlaceholderCulturalGiftDesignView.swift */,'
    content = content.replace(views_group_pattern, replacement)
    
    # Add to build sources
    sources_pattern = 'C005 /* SharedModels.swift in Sources */,'
    sources_replacement = f'C005 /* SharedModels.swift in Sources */,\n\t\t\t\t{build_file_uuid} /* PlaceholderCulturalGiftDesignView.swift in Sources */,'
    content = content.replace(sources_pattern, sources_replacement)
    
    # Write back the modified content
    with open(project_file, 'w') as f:
        f.write(content)
    
    print(f"Added PlaceholderCulturalGiftDesignView.swift to Xcode project")
    print(f"File Reference UUID: {file_ref_uuid}")
    print(f"Build File UUID: {build_file_uuid}")

if __name__ == "__main__":
    add_placeholder_to_project()