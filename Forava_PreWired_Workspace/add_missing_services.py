#!/usr/bin/env python3

import os
import uuid
import re

# List of service files that need to be added to the project
missing_services = [
    "Services/DynamicCulturalTerminologyService.swift",
    "Services/CulturalDesignAgentService.swift", 
    "Services/CulturalValidationFramework.swift",
    "Services/SubscriptionManager.swift",
    "Services/GlobalTerminologyUpdateService.swift",
    "Services/CulturalSystemMigrationService.swift",
    "Services/FixedSocialSharingService.swift",
    "Services/PaymentPageUpdateService.swift",
    "Services/CulturalAgents/ChineseNewYearAgent.swift",
    "Services/CulturalAgents/DiwaliAgent.swift",
    "Services/CulturalAgents/ChristmasAgent.swift",
    "Services/CulturalAgents/EidAgent.swift",
    "Services/CulturalAgents/VesakAgent.swift",
    "Services/CulturalAgents/JewishAgent.swift",
    "Services/CulturalAgents/AdditionalAgents.swift",
    "Models/RakhiDesignModels.swift",
    "Models/CulturalFramework.swift",
    "Views/Settings/SettingsView.swift",
    "Views/Settings/CulturalPreferencesView.swift",
    "Views/Settings/SubscriptionManagementView.swift"
]

def add_services_to_project():
    project_file = "Forava.xcodeproj/project.pbxproj"
    
    if not os.path.exists(project_file):
        print(f"Project file not found: {project_file}")
        return False
        
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Find the end of PBXBuildFile section
    build_file_section = re.search(r'(.*/* End PBXBuildFile section */)', content, re.DOTALL)
    if not build_file_section:
        print("Could not find PBXBuildFile section")
        return False
        
    # Find the end of PBXFileReference section  
    file_ref_section = re.search(r'(.*/* End PBXFileReference section */)', content, re.DOTALL)
    if not file_ref_section:
        print("Could not find PBXFileReference section")
        return False
    
    # Find the ForavaApp group files section
    forava_app_files = re.search(r'(A000.*?);', content, re.DOTALL)
    if not forava_app_files:
        print("Could not find ForavaApp files group")
        return False
        
    # Find the sources build phase
    sources_build_phase = re.search(r'(A014.*?in Sources.*?);', content, re.DOTALL)
    if not sources_build_phase:
        print("Could not find sources build phase")
        return False
    
    new_content = content
    build_files_added = []
    file_refs_added = []
    
    for service_path in missing_services:
        # Check if file exists
        full_path = f"ForavaApp/{service_path}"
        if not os.path.exists(full_path):
            print(f"Warning: File does not exist: {full_path}")
            continue
            
        # Check if already in project
        if service_path in content:
            print(f"File already in project: {service_path}")
            continue
            
        # Generate UUIDs for the file
        build_file_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
        file_ref_id = str(uuid.uuid4()).replace('-', '').upper()[:24]
        
        filename = os.path.basename(service_path)
        
        # Add to build files section
        build_file_entry = f"\t\t{build_file_id} /* {filename} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {filename} */; }};"
        
        # Add to file references section  
        file_ref_entry = f"\t\t{file_ref_id} /* {filename} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = \"{service_path}\"; sourceTree = \"<group>\"; }};"
        
        build_files_added.append((build_file_id, filename, build_file_entry))
        file_refs_added.append(file_ref_entry)
    
    if not build_files_added:
        print("No new files to add")
        return True
        
    # Insert build files before "/* End PBXBuildFile section */"
    build_section_end = "/* End PBXBuildFile section */"
    build_entries = '\n'.join([entry[2] for entry in build_files_added])
    new_content = new_content.replace(
        build_section_end,
        build_entries + '\n\t\t' + build_section_end
    )
    
    # Insert file references before "/* End PBXFileReference section */"  
    file_ref_section_end = "/* End PBXFileReference section */"
    file_ref_entries = '\n'.join(file_refs_added)
    new_content = new_content.replace(
        file_ref_section_end, 
        file_ref_entries + '\n\t\t' + file_ref_section_end
    )
    
    # Add to ForavaApp group (find the children array)
    group_pattern = r'(A000.*?children = \(\s*)(.*?)(\s*\);)'
    group_match = re.search(group_pattern, new_content, re.DOTALL)
    if group_match:
        existing_children = group_match.group(2)
        new_file_refs = []
        for file_ref_entry in file_refs_added:
            file_ref_id = re.search(r'(\w+) /\*', file_ref_entry).group(1)
            filename = re.search(r'/\* (.*?) \*/', file_ref_entry).group(1)
            new_file_refs.append(f"\t\t\t\t{file_ref_id} /* {filename} */,")
        
        new_children = existing_children + '\n' + '\n'.join(new_file_refs)
        new_content = new_content.replace(group_match.group(0), 
                                        group_match.group(1) + new_children + group_match.group(3))
    
    # Add to sources build phase
    sources_pattern = r'(buildActionMask = 2147483647;\s*files = \(\s*)(.*?)(\s*\);\s*runOnlyForDeploymentPostprocessing = 0;)'
    sources_match = re.search(sources_pattern, new_content, re.DOTALL)
    if sources_match:
        existing_sources = sources_match.group(2)
        new_source_refs = []
        for build_file_id, filename, _ in build_files_added:
            new_source_refs.append(f"\t\t\t\t{build_file_id} /* {filename} in Sources */,")
        
        new_sources = existing_sources + '\n' + '\n'.join(new_source_refs)
        new_content = new_content.replace(sources_match.group(0),
                                        sources_match.group(1) + new_sources + sources_match.group(3))
    
    # Write updated project file
    with open(project_file, 'w') as f:
        f.write(new_content)
    
    print("Successfully added missing services to Xcode project!")
    print("Files added:")
    for _, filename, _ in build_files_added:
        print(f"  - {filename}")
    
    return True

if __name__ == "__main__":
    add_services_to_project()