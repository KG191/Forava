#!/usr/bin/env python3
"""
Complete fix for Forava app icons and Apple compliance
"""
import subprocess
import os
import shutil
import json

def ensure_alpha_channel(source_png, output_png):
    """Ensure PNG has alpha channel for Apple compliance"""
    try:
        # Use sips to ensure RGBA format
        subprocess.run([
            "sips", "-s", "format", "png",
            "-s", "formatOptions", "default",
            source_png, "--out", output_png
        ], check=True, capture_output=True)
        
        # Verify it has alpha channel
        result = subprocess.run([
            "sips", "-g", "hasAlpha", output_png
        ], capture_output=True, text=True)
        
        if "hasAlpha: no" in result.stdout:
            # Force add alpha channel
            subprocess.run([
                "sips", "-s", "hasAlpha", "yes", output_png
            ], check=True, capture_output=True)
        
        return True
    except subprocess.CalledProcessError:
        return False

def create_compliant_icon(source, output_path, size):
    """Create Apple-compliant icon"""
    try:
        # Create temporary file with alpha channel
        temp_file = f"/tmp/temp_icon_{size}.png"
        
        # First ensure source has alpha
        ensure_alpha_channel(source, temp_file)
        
        # Then resize with high quality
        subprocess.run([
            "sips", "-z", str(size), str(size),
            "-s", "format", "png",
            "-s", "formatOptions", "default",
            temp_file, "--out", output_path
        ], check=True, capture_output=True)
        
        # Clean up temp file
        if os.path.exists(temp_file):
            os.remove(temp_file)
            
        # Verify output file
        if os.path.exists(output_path) and os.path.getsize(output_path) > 200:
            return True
        return False
    except Exception as e:
        print(f"Error creating {output_path}: {e}")
        return False

def fix_all_icons():
    base_path = "/Users/kirangokal/Documents/Forava"
    source_png = f"{base_path}/Forava_AppIcon_1.png"
    
    # All required iOS icons (complete list)
    ios_icons = {
        "AppIcon-20x20@2x.png": 40,     # iPhone Settings
        "AppIcon-20x20@3x.png": 60,     # iPhone Settings
        "AppIcon-29x29@2x.png": 58,     # iPhone Spotlight
        "AppIcon-29x29@3x.png": 87,     # iPhone Spotlight
        "AppIcon-40x40@2x.png": 80,     # iPhone Spotlight
        "AppIcon-40x40@3x.png": 120,    # iPhone Spotlight
        "AppIcon-60x60@2x.png": 120,    # iPhone App
        "AppIcon-60x60@3x.png": 180,    # iPhone App
        "AppIcon-20x20@1x.png": 20,     # iPad Settings
        "AppIcon-29x29@1x.png": 29,     # iPad Spotlight
        "AppIcon-40x40@1x.png": 40,     # iPad Spotlight
        "AppIcon-76x76@1x.png": 76,     # iPad App
        "AppIcon-76x76@2x.png": 152,    # iPad App
        "AppIcon-83.5x83.5@2x.png": 167, # iPad Pro App
        "AppIcon-1024x1024@1x.png": 1024 # App Store
    }
    
    # watchOS icons
    watch_icons = {
        "AppIcon-24x24@2x.png": 48,      # Watch Settings
        "AppIcon-27.5x27.5@2x.png": 55,  # Watch Settings
        "AppIcon-29x29@2x.png": 58,      # Watch Companion
        "AppIcon-29x29@3x.png": 87,      # Watch Companion
        "AppIcon-40x40@2x.png": 80,      # Watch Companion
        "AppIcon-44x44@2x.png": 88,      # Watch App (40mm)
        "AppIcon-50x50@2x.png": 100,     # Watch App (44mm)
        "AppIcon-86x86@2x.png": 172,     # Watch App (40mm)
        "AppIcon-98x98@2x.png": 196,     # Watch App (44mm)
        "AppIcon-108x108@2x.png": 216,   # Watch App (45mm)
        "AppIcon-1024x1024@1x.png": 1024 # App Store
    }
    
    print("🎨 Creating Apple-compliant icons...")
    
    # First, ensure source icon has alpha channel
    compliant_source = f"{base_path}/Forava_AppIcon_1_compliant.png"
    if ensure_alpha_channel(source_png, compliant_source):
        print("✅ Source icon made Apple-compliant with alpha channel")
        source_png = compliant_source
    
    # Fix iOS icons
    ios_path = f"{base_path}/Forava_Assets.xcassets/AppIcon.appiconset"
    print(f"🍎 Creating all {len(ios_icons)} iOS icons...")
    
    for filename, size in ios_icons.items():
        output_path = f"{ios_path}/{filename}"
        if create_compliant_icon(source_png, output_path, size):
            print(f"✅ {filename} ({size}x{size})")
        else:
            print(f"❌ Failed: {filename}")
    
    # Fix watchOS icons  
    watch_path = f"{base_path}/Forava_WatchAssets.xcassets/AppIcon.appiconset"
    print(f"⌚ Creating all {len(watch_icons)} watchOS icons...")
    
    for filename, size in watch_icons.items():
        output_path = f"{watch_path}/{filename}"
        if create_compliant_icon(source_png, output_path, size):
            print(f"✅ {filename} ({size}x{size})")
        else:
            print(f"❌ Failed: {filename}")
    
    # Clean up temp compliant source
    if os.path.exists(compliant_source):
        os.remove(compliant_source)

def update_xcode_settings():
    """Update Xcode project to recommended settings"""
    print("🔧 Updating Xcode project settings...")
    
    project_file = "/Users/kirangokal/Documents/Forava/Forava_PreWired_Workspace/Forava.xcodeproj/project.pbxproj"
    
    # Read current project file
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Update to recommended settings
    updates = [
        ('IPHONEOS_DEPLOYMENT_TARGET = 16.0;', 'IPHONEOS_DEPLOYMENT_TARGET = 17.0;'),
        ('WATCHOS_DEPLOYMENT_TARGET = 9.0;', 'WATCHOS_DEPLOYMENT_TARGET = 10.0;'),
        ('LastUpgradeCheck = 1500;', 'LastUpgradeCheck = 1600;'),
        ('LastSwiftUpdateCheck = 1500;', 'LastSwiftUpdateCheck = 1600;'),
    ]
    
    for old, new in updates:
        if old in content:
            content = content.replace(old, new)
            print(f"✅ Updated: {old.split('=')[0].strip()}")
    
    # Write back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print("✅ Xcode settings updated to recommended values")

if __name__ == "__main__":
    print("🚀 Starting complete Forava icon and settings fix...")
    fix_all_icons()
    update_xcode_settings()
    print("🎉 Complete fix finished!")