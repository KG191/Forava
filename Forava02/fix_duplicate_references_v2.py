#!/usr/bin/env python3
"""
Fix duplicate file references in Xcode project.pbxproj - Version 2
More comprehensive approach to handle all remaining duplicates.
"""

import re

def fix_all_duplicates(project_file):
    """Remove ALL duplicate PBXBuildFile entries for design view files."""
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    output_lines = []
    seen_files = {}  # filename -> first occurrence line
    removed_build_ids = set()
    
    # First pass: identify duplicates and collect IDs to remove
    for i, line in enumerate(lines):
        # Match any DesignView.swift file reference
        match = re.search(r'([A-F0-9]+) /\* (\w*DesignView\.swift) in Sources \*/', line)
        if match:
            build_id = match.group(1)
            filename = match.group(2)
            
            if filename in seen_files:
                # This is a duplicate - mark for removal
                print(f"Marking duplicate for removal: {build_id} for {filename} (line {i+1})")
                removed_build_ids.add(build_id)
            else:
                # First occurrence - keep it
                seen_files[filename] = i
                print(f"Keeping first occurrence: {build_id} for {filename} (line {i+1})")
    
    # Second pass: remove lines containing removed build IDs
    for line in lines:
        should_remove = False
        for removed_id in removed_build_ids:
            if removed_id in line:
                print(f"Removing line: {line.strip()}")
                should_remove = True
                break
        
        if not should_remove:
            output_lines.append(line)
    
    # Write the cleaned content
    with open(project_file, 'w') as f:
        f.write('\n'.join(output_lines))
    
    print(f"\nFixed all duplicate references in {project_file}")
    print(f"Removed {len(removed_build_ids)} duplicate build file references")
    return len(removed_build_ids)

if __name__ == "__main__":
    project_file = "Forava.xcodeproj/project.pbxproj"
    
    print("Fixing ALL duplicate design view file references in Xcode project...")
    removed_count = fix_all_duplicates(project_file)
    
    if removed_count > 0:
        print(f"\nSuccess! Removed {removed_count} total duplicate references.")
        print("Checking final state...")
        
        # Verify the fix worked
        import subprocess
        result = subprocess.run([
            'bash', '-c', 
            'grep "DesignView.swift in Sources" Forava.xcodeproj/project.pbxproj | sed "s/.*\\/\\* \\(.*DesignView\\.swift\\) in Sources.*/\\1/" | sort | uniq -c | sort -nr'
        ], capture_output=True, text=True)
        
        print("Final count per file:")
        print(result.stdout)
        
    else:
        print("\nNo duplicates found or removed.")