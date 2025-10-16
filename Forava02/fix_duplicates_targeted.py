#!/usr/bin/env python3
"""
Fix duplicate file references - targeted approach.
Keep only the first occurrence of each DesignView.swift file.
"""

import re

def fix_duplicates_targeted():
    """Remove duplicate entries but keep exactly one per file."""
    
    with open("Forava.xcodeproj/project.pbxproj", 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    output_lines = []
    
    # Keep track of which files we've seen
    seen_design_files = set()
    
    for line in lines:
        # Check if this is a PBXBuildFile line for a DesignView
        build_match = re.match(r'\t\t([A-F0-9]+) /\* (\w*DesignView\.swift) in Sources \*/', line)
        
        if build_match:
            build_id = build_match.group(1)
            filename = build_match.group(2)
            
            if filename in seen_design_files:
                print(f"Skipping duplicate PBXBuildFile: {build_id} for {filename}")
                continue
            else:
                seen_design_files.add(filename)
                print(f"Keeping PBXBuildFile: {build_id} for {filename}")
        
        # Check if this is a sources list entry for a duplicate
        sources_match = re.search(r'([A-F0-9]+) /\* (\w*DesignView\.swift) in Sources \*/', line)
        if sources_match and 'files = (' not in line:
            build_id = sources_match.group(1)
            filename = sources_match.group(2)
            
            # Check if this build_id was for a duplicate we should skip
            if filename in seen_design_files:
                # This means we've already seen this file, check if this is the same build_id we kept
                is_first_occurrence = True
                for prev_line in output_lines:
                    if build_id in prev_line and f"/* {filename} in Sources */" in prev_line and "isa = PBXBuildFile" in prev_line:
                        is_first_occurrence = False
                        break
                
                if not is_first_occurrence:
                    print(f"Skipping duplicate sources entry: {build_id} for {filename}")
                    continue
        
        output_lines.append(line)
    
    # Write back the fixed content
    with open("Forava.xcodeproj/project.pbxproj", 'w') as f:
        f.write('\n'.join(output_lines))
    
    print(f"\nCompleted targeted duplicate removal")

if __name__ == "__main__":
    print("Running targeted duplicate removal...")
    fix_duplicates_targeted()
    
    # Verify the result
    import subprocess
    result = subprocess.run([
        'bash', '-c', 
        'grep "DesignView.swift in Sources" Forava.xcodeproj/project.pbxproj | sed "s/.*\\/\\* \\(.*DesignView\\.swift\\) in Sources.*/\\1/" | sort | uniq -c'
    ], capture_output=True, text=True)
    
    print("\nFinal file counts:")
    print(result.stdout)