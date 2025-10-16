#!/usr/bin/env python3
"""
Remove additional problematic files from Xcode project to fix compilation errors.
"""

import re

def remove_files_from_project():
    project_file = "Forava.xcodeproj/project.pbxproj"
    
    # Files to remove
    problematic_files = [
        "CulturalGiftDesignView.swift",
        "CulturalDesignViewModel.swift"
    ]
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    original_length = len(content)
    
    # Remove lines containing problematic file references
    lines = content.split('\n')
    filtered_lines = []
    
    for line in lines:
        should_remove = False
        for file_pattern in problematic_files:
            if file_pattern in line:
                should_remove = True
                print(f"Removing line: {line.strip()}")
                break
        
        if not should_remove:
            filtered_lines.append(line)
    
    new_content = '\n'.join(filtered_lines)
    
    # Write back the modified content
    with open(project_file, 'w') as f:
        f.write(new_content)
    
    print(f"Removed {original_length - len(new_content)} characters from project file")
    print("Problematic files removed from Xcode project successfully")

if __name__ == "__main__":
    remove_files_from_project()