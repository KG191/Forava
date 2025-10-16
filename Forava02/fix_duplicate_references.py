#!/usr/bin/env python3
"""
Fix duplicate file references in Xcode project.pbxproj
Each cultural design view file appears 4 times, causing build errors.
This script will keep only 1 reference per file.
"""

import re
import sys

def fix_duplicate_references(project_file):
    """Remove duplicate PBXBuildFile entries for design view files."""
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Track which design view files we've seen
    seen_files = set()
    
    # Pattern to match PBXBuildFile entries for design view files
    pattern = r'^\t\t([A-F0-9]+) /\* (\w+DesignView\.swift) in Sources \*/ = \{isa = PBXBuildFile; fileRef = ([A-F0-9]+) /\* \2 \*/; \};$'
    
    lines = content.split('\n')
    output_lines = []
    removed_build_ids = set()
    
    for line in lines:
        match = re.match(pattern, line)
        if match:
            build_id = match.group(1)
            filename = match.group(2)
            file_ref = match.group(3)
            
            if filename in seen_files:
                # This is a duplicate - remove it
                print(f"Removing duplicate build reference: {build_id} for {filename}")
                removed_build_ids.add(build_id)
                continue
            else:
                # First occurrence - keep it
                seen_files.add(filename)
                print(f"Keeping build reference: {build_id} for {filename}")
        
        output_lines.append(line)
    
    # Now remove references to the removed build IDs from PBXSourcesBuildPhase
    final_lines = []
    for line in lines:
        # Check if this line references a removed build ID
        skip_line = False
        for removed_id in removed_build_ids:
            if removed_id in line and 'PBXSourcesBuildPhase' not in line:
                if 'in Sources' in line or 'files = (' in line or removed_id + ' /* ' in line:
                    print(f"Removing sources reference: {line.strip()}")
                    skip_line = True
                    break
        
        if not skip_line:
            final_lines.append(line)
    
    # Write the cleaned content
    with open(project_file, 'w') as f:
        f.write('\n'.join(final_lines))
    
    print(f"\nFixed duplicate references in {project_file}")
    print(f"Removed {len(removed_build_ids)} duplicate build file references")
    return len(removed_build_ids)

if __name__ == "__main__":
    project_file = "Forava.xcodeproj/project.pbxproj"
    
    print("Fixing duplicate design view file references in Xcode project...")
    removed_count = fix_duplicate_references(project_file)
    
    if removed_count > 0:
        print(f"\nSuccess! Removed {removed_count} duplicate references.")
        print("You should now be able to build the project without duplicate output file errors.")
    else:
        print("\nNo duplicates found or removed.")