#!/usr/bin/env python3

import re
import shutil
from pathlib import Path

def cleanup_xcode_duplicates():
    """Remove duplicate file references from Xcode project.pbxproj"""
    
    project_file = Path("Forava.xcodeproj/project.pbxproj")
    backup_file = Path("Forava.xcodeproj/project.pbxproj.backup")
    
    print("🧹 Cleaning up duplicate file references in Xcode project...")
    
    # Create backup
    shutil.copy2(project_file, backup_file)
    print(f"📦 Backup created: {backup_file}")
    
    # Read the project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Files that need duplicate cleanup
    duplicate_files = [
        'CulturalDesignComponents.swift',
        'CulturalDesignProtocol.swift', 
        'CulturalDesignViewModel.swift',
        'ChristmasDesignView.swift'
    ]
    
    # UUIDs to remove (the ones added by Python script - these are the newer ones)
    uuids_to_remove = [
        '218FF36F2E642A86008C12BF',  # CulturalDesignComponents.swift
        '218FF3702E642A86008C12BF',  # CulturalDesignProtocol.swift  
        '218FF3712E642A86008C12BF',  # CulturalDesignViewModel.swift
        '218FF3652E642A86008C12BF',  # ChristmasDesignView.swift
        '218FF3752E642A86008C12BF',  # PBXBuildFile for CulturalDesignComponents
        '218FF3762E642A86008C12BF',  # PBXBuildFile for ChristmasDesignView
        '218FF3772E642A86008C12BF',  # PBXBuildFile for CulturalDesignProtocol
        '218FF3782E642A86008C12BF',  # PBXBuildFile for CulturalDesignViewModel
        '218FF3792E642A86008C12BF',  # PBXBuildFile for CulturalDesignComponents (Watch)
        '218FF37A2E642A86008C12BF',  # PBXBuildFile for ChristmasDesignView (Watch)
        '218FF37B2E642A86008C12BF',  # PBXBuildFile for CulturalDesignProtocol (Watch)
        '218FF37C2E642A86008C12BF',  # PBXBuildFile for CulturalDesignViewModel (Watch)
    ]
    
    lines_removed = 0
    lines = content.split('\n')
    cleaned_lines = []
    
    for line in lines:
        # Check if this line contains any of the UUIDs to remove
        should_remove = any(uuid in line for uuid in uuids_to_remove)
        
        if should_remove:
            lines_removed += 1
            print(f"🗑️  Removing duplicate: {line.strip()}")
        else:
            cleaned_lines.append(line)
    
    # Write the cleaned content back
    cleaned_content = '\n'.join(cleaned_lines)
    
    with open(project_file, 'w') as f:
        f.write(cleaned_content)
    
    print(f"✅ Cleanup complete! Removed {lines_removed} duplicate lines")
    print(f"💾 Backup available at: {backup_file}")
    
    return lines_removed

if __name__ == "__main__":
    cleanup_xcode_duplicates()