#!/usr/bin/env python3
"""Remove Birthday and EidAlFitr references from Xcode project file"""

import re

# Read the project file
with open('Forava.xcodeproj/project.pbxproj', 'r') as f:
    content = f.read()

# Remove Birthday group definition (including all lines in the block)
content = re.sub(
    r'\t\t218FF3632E642A86008C12BF /\* Birthday \*/ = \{\n'
    r'\t\t\tisa = PBXGroup;\n'
    r'\t\t\tchildren = \(\n'
    r'\t\t\t\);\n'
    r'\t\t\tpath = Birthday;\n'
    r'\t\t\tsourceTree = "<group>";\n'
    r'\t\t\};\n',
    '',
    content
)

# Remove EidAlFitr group definition
content = re.sub(
    r'\t\t218FF36A2E642A86008C12BF /\* EidAlFitr \*/ = \{\n'
    r'\t\t\tisa = PBXGroup;\n'
    r'\t\t\tchildren = \(\n'
    r'\t\t\t\);\n'
    r'\t\t\tpath = EidAlFitr;\n'
    r'\t\t\tsourceTree = "<group>";\n'
    r'\t\t\};\n',
    '',
    content
)

# Remove Birthday reference in children array
content = re.sub(
    r'\t\t\t\t218FF3632E642A86008C12BF /\* Birthday \*/,\n',
    '',
    content
)

# Remove EidAlFitr reference in children array
content = re.sub(
    r'\t\t\t\t218FF36A2E642A86008C12BF /\* EidAlFitr \*/,\n',
    '',
    content
)

# Write back
with open('Forava.xcodeproj/project.pbxproj', 'w') as f:
    f.write(content)

print("✓ Removed Birthday and EidAlFitr group references from project file")
