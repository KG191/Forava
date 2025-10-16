#!/bin/bash
# Remove duplicate entries from the sources list section (keep PBXBuildFile entries)

PROJECT_FILE="Forava.xcodeproj/project.pbxproj"

echo "Removing duplicate sources list entries..."

# Remove the sources list lines but keep the PBXBuildFile definitions
sed -i.temp2 '/^\t\t\t\t213539C[0-9A-F].*DesignView\.swift in Sources.*,$/d' "$PROJECT_FILE"
sed -i.temp3 '/^\t\t\t\t213539D[0-9A-F].*DesignView\.swift in Sources.*,$/d' "$PROJECT_FILE"  
sed -i.temp4 '/^\t\t\t\t216BDD4E.*PlaceholderCulturalGiftDesignView\.swift in Sources.*,$/d' "$PROJECT_FILE"

echo "Cleanup completed!"

# Check the result
echo "Checking remaining DesignView file counts:"
grep "DesignView.swift in Sources" "$PROJECT_FILE" | sed 's/.*\/\* \(.*DesignView\.swift\) in Sources.*/\1/' | sort | uniq -c