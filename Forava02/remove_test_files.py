#!/usr/bin/env python3
"""
Remove test files from Xcode project to fix compilation errors.
The test files were incorrectly included in the main app target.
"""

import re

def remove_test_files_from_project():
    project_file = "Forava.xcodeproj/project.pbxproj"
    
    # Test file patterns to remove
    test_patterns = [
        "HoliExpansionTest.swift",
        "ChristmasExpansionTest.swift", 
        "ChineseNewYearTest.swift",
        "ProductionTestSuite.swift",
        "DiwaliExpansionTest.swift",
        "PerformanceValidationSuite.swift",
        "CulturalAuthenticityTests.swift",
        "IntegrationTestSuite.swift",
        "BackwardCompatibilityTests.swift"
    ]
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    original_length = len(content)
    
    # Remove lines containing test file references
    lines = content.split('\n')
    filtered_lines = []
    
    for line in lines:
        should_remove = False
        for pattern in test_patterns:
            if pattern in line:
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
    print("Test files removed from Xcode project successfully")

if __name__ == "__main__":
    remove_test_files_from_project()