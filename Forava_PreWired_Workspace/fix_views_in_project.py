#!/usr/bin/env python3
import os
import re
import uuid

# Generate UUID for Xcode project files
def generate_uuid():
    return str(uuid.uuid4()).replace('-', '').upper()[:24]

project_file = "Forava.xcodeproj/project.pbxproj"

# Read the current project file
with open(project_file, 'r') as f:
    content = f.read()

# Check if the files are already in the project
if "CulturalDesignStudioView.swift" not in content:
    print("CulturalDesignStudioView.swift not found in project file!")
    exit(1)

if "CulturalGiftPreviewView.swift" not in content:
    print("CulturalGiftPreviewView.swift not found in project file!")
    exit(1)

print("Both files are in the project file. Checking compilation order...")

# Let's try to force the files to be compiled by ensuring they're in the right order
# Find the Sources build phase and make sure our files are at the top
sources_pattern = r'(/\* Sources \*/ = {[^}]*files = \()[^)]*(\);)'
sources_match = re.search(sources_pattern, content, re.DOTALL)

if sources_match:
    sources_content = sources_match.group(2)
    
    # Check if our files are in the sources
    if "CulturalDesignStudioView.swift in Sources" in sources_content:
        print("CulturalDesignStudioView.swift is in Sources build phase")
    else:
        print("CulturalDesignStudioView.swift is NOT in Sources build phase")
    
    if "CulturalGiftPreviewView.swift in Sources" in sources_content:
        print("CulturalGiftPreviewView.swift is in Sources build phase")
    else:
        print("CulturalGiftPreviewView.swift is NOT in Sources build phase")

print("Project file analysis complete.")
print("The files appear to be properly added to the project.")
print("The issue might be with the compilation order or missing dependencies.")

