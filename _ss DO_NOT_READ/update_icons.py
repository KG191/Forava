#!/usr/bin/env python3
"""
Update Forava app icons from the master 1024x1024 PNG
"""
import subprocess
import os
from pathlib import Path

def resize_image(source_path, output_path, size):
    """Resize image using sips (built into macOS)"""
    try:
        subprocess.run([
            "sips", 
            "-z", str(size), str(size),
            source_path,
            "--out", output_path
        ], check=True, capture_output=True)
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Error resizing to {size}x{size}: {e}")
        return False

def update_app_icons():
    base_path = "/Users/kirangokal/Documents/Forava"
    source_png = f"{base_path}/Forava_AppIcon_1.png"
    
    # iOS AppIcon paths and sizes
    ios_icons = {
        "AppIcon-20x20@2x.png": 40,
        "AppIcon-20x20@3x.png": 60,
        "AppIcon-29x29@2x.png": 58,
        "AppIcon-29x29@3x.png": 87,
        "AppIcon-40x40@2x.png": 80,
        "AppIcon-40x40@3x.png": 120,
        "AppIcon-60x60@2x.png": 120,
        "AppIcon-60x60@3x.png": 180,
        "AppIcon-20x20@1x.png": 20,
        "AppIcon-29x29@1x.png": 29,
        "AppIcon-40x40@1x.png": 40,
        "AppIcon-76x76@1x.png": 76,
        "AppIcon-76x76@2x.png": 152,
        "AppIcon-83.5x83.5@2x.png": 167,
        "AppIcon-1024x1024@1x.png": 1024
    }
    
    # Update iOS icons
    ios_icon_path = f"{base_path}/Forava_Assets.xcassets/AppIcon.appiconset"
    print(f"🍎 Updating iOS icons in {ios_icon_path}")
    
    for filename, size in ios_icons.items():
        output_path = f"{ios_icon_path}/{filename}"
        if size == 1024:
            # Copy the master file directly
            subprocess.run(["cp", source_png, output_path], check=True)
            print(f"✅ Copied master icon: {filename}")
        else:
            if resize_image(source_png, output_path, size):
                print(f"✅ Created {filename} ({size}x{size})")
            else:
                print(f"❌ Failed to create {filename}")
    
    # watchOS icons (simplified set)
    watch_icons = {
        "AppIcon-24x24@2x.png": 48,
        "AppIcon-27.5x27.5@2x.png": 55,
        "AppIcon-29x29@2x.png": 58,
        "AppIcon-29x29@3x.png": 87,
        "AppIcon-40x40@2x.png": 80,
        "AppIcon-44x44@2x.png": 88,
        "AppIcon-50x50@2x.png": 100,
        "AppIcon-86x86@2x.png": 172,
        "AppIcon-98x98@2x.png": 196,
        "AppIcon-108x108@2x.png": 216,
        "AppIcon-1024x1024@1x.png": 1024
    }
    
    # Update watchOS icons
    watch_icon_path = f"{base_path}/Forava_WatchAssets.xcassets/AppIcon.appiconset"
    print(f"⌚ Updating watchOS icons in {watch_icon_path}")
    
    for filename, size in watch_icons.items():
        output_path = f"{watch_icon_path}/{filename}"
        if size == 1024:
            # Copy the master file directly
            subprocess.run(["cp", source_png, output_path], check=True)
            print(f"✅ Copied master icon: {filename}")
        else:
            if resize_image(source_png, output_path, size):
                print(f"✅ Created {filename} ({size}x{size})")
            else:
                print(f"❌ Failed to create {filename}")

if __name__ == "__main__":
    print("🎨 Updating Forava app icons...")
    update_app_icons()
    print("🎉 Icon update complete! Build your project to see the new icons.")