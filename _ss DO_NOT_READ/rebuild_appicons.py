#!/usr/bin/env python3
"""
Systematically rebuild AppIcon asset catalogs to eliminate "unassigned children" warnings
Principal Developer approach: Complete reconstruction with Apple-spec precision
"""
import os
import shutil
import subprocess
import json

def create_clean_contents_json():
    """Create Contents.json exactly per Apple's specifications"""
    return {
        "images": [
            # iPhone Icons
            {"size": "20x20", "idiom": "iphone", "filename": "AppIcon-20x20@2x.png", "scale": "2x"},
            {"size": "20x20", "idiom": "iphone", "filename": "AppIcon-20x20@3x.png", "scale": "3x"},
            {"size": "29x29", "idiom": "iphone", "filename": "AppIcon-29x29@2x.png", "scale": "2x"},
            {"size": "29x29", "idiom": "iphone", "filename": "AppIcon-29x29@3x.png", "scale": "3x"},
            {"size": "40x40", "idiom": "iphone", "filename": "AppIcon-40x40@2x.png", "scale": "2x"},
            {"size": "40x40", "idiom": "iphone", "filename": "AppIcon-40x40@3x.png", "scale": "3x"},
            {"size": "60x60", "idiom": "iphone", "filename": "AppIcon-60x60@2x.png", "scale": "2x"},
            {"size": "60x60", "idiom": "iphone", "filename": "AppIcon-60x60@3x.png", "scale": "3x"},
            # iPad Icons
            {"size": "20x20", "idiom": "ipad", "filename": "AppIcon-20x20@1x.png", "scale": "1x"},
            {"size": "20x20", "idiom": "ipad", "filename": "AppIcon-20x20@2x.png", "scale": "2x"},
            {"size": "29x29", "idiom": "ipad", "filename": "AppIcon-29x29@1x.png", "scale": "1x"},
            {"size": "29x29", "idiom": "ipad", "filename": "AppIcon-29x29@2x.png", "scale": "2x"},
            {"size": "40x40", "idiom": "ipad", "filename": "AppIcon-40x40@1x.png", "scale": "1x"},
            {"size": "40x40", "idiom": "ipad", "filename": "AppIcon-40x40@2x.png", "scale": "2x"},
            {"size": "76x76", "idiom": "ipad", "filename": "AppIcon-76x76@1x.png", "scale": "1x"},
            {"size": "76x76", "idiom": "ipad", "filename": "AppIcon-76x76@2x.png", "scale": "2x"},
            {"size": "83.5x83.5", "idiom": "ipad", "filename": "AppIcon-83.5x83.5@2x.png", "scale": "2x"},
            # App Store
            {"size": "1024x1024", "idiom": "ios-marketing", "filename": "AppIcon-1024x1024@1x.png", "scale": "1x"}
        ],
        "info": {
            "version": 1,
            "author": "xcode"
        }
    }

def create_clean_watch_contents_json():
    """Create watchOS Contents.json per Apple specifications"""
    return {
        "images": [
            {"size": "24x24", "idiom": "watch", "filename": "AppIcon-24x24@2x.png", "scale": "2x", "role": "notificationCenter", "subtype": "38mm"},
            {"size": "27.5x27.5", "idiom": "watch", "filename": "AppIcon-27.5x27.5@2x.png", "scale": "2x", "role": "notificationCenter", "subtype": "42mm"},
            {"size": "29x29", "idiom": "watch", "filename": "AppIcon-29x29@2x.png", "scale": "2x", "role": "companionSettings"},
            {"size": "29x29", "idiom": "watch", "filename": "AppIcon-29x29@3x.png", "scale": "3x", "role": "companionSettings"},
            {"size": "40x40", "idiom": "watch", "filename": "AppIcon-40x40@2x.png", "scale": "2x", "role": "appLauncher", "subtype": "38mm"},
            {"size": "44x44", "idiom": "watch", "filename": "AppIcon-44x44@2x.png", "scale": "2x", "role": "appLauncher", "subtype": "40mm"},
            {"size": "46x46", "idiom": "watch", "filename": "AppIcon-46x46@2x.png", "scale": "2x", "role": "appLauncher", "subtype": "41mm"},
            {"size": "50x50", "idiom": "watch", "filename": "AppIcon-50x50@2x.png", "scale": "2x", "role": "appLauncher", "subtype": "44mm"},
            {"size": "86x86", "idiom": "watch", "filename": "AppIcon-86x86@2x.png", "scale": "2x", "role": "quickLook", "subtype": "38mm"},
            {"size": "98x98", "idiom": "watch", "filename": "AppIcon-98x98@2x.png", "scale": "2x", "role": "quickLook", "subtype": "42mm"},
            {"size": "108x108", "idiom": "watch", "filename": "AppIcon-108x108@2x.png", "scale": "2x", "role": "quickLook", "subtype": "44mm"},
            {"size": "1024x1024", "idiom": "watch-marketing", "filename": "AppIcon-1024x1024@1x.png", "scale": "1x"}
        ],
        "info": {
            "version": 1,
            "author": "xcode"
        }
    }

def create_precise_icon(source_path, output_path, size, force_srgb=True):
    """Create icon with Apple-precise specifications"""
    try:
        # Ensure output directory exists
        os.makedirs(os.path.dirname(output_path), exist_ok=True)
        
        # Use sips with Apple-precise parameters
        cmd = [
            "sips",
            "-z", str(size), str(size),
            "-s", "format", "png",
            "-s", "formatOptions", "default",
            source_path,
            "--out", output_path
        ]
        
        if force_srgb:
            cmd.extend(["-m", "/System/Library/ColorSync/Profiles/sRGB Profile.icc"])
        
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        
        # Verify output
        if os.path.exists(output_path) and os.path.getsize(output_path) > 100:
            # Set correct permissions
            os.chmod(output_path, 0o644)
            return True
        return False
    except Exception as e:
        print(f"Error creating {output_path}: {e}")
        return False

def rebuild_appicon_completely():
    """Completely rebuild AppIcon asset catalogs"""
    base_path = "/Users/kirangokal/Documents/Forava"
    source_png = f"{base_path}/Forava_AppIcon_1.png"
    
    # Verify source exists
    if not os.path.exists(source_png):
        print(f"❌ Source not found: {source_png}")
        return False
    
    print("🔧 Systematically rebuilding AppIcon asset catalogs...")
    
    # iOS AppIcon rebuild
    ios_path = f"{base_path}/Forava_PreWired_Workspace/Forava_Assets.xcassets/AppIcon.appiconset"
    print(f"📱 Rebuilding iOS AppIcon at {ios_path}")
    
    # Remove and recreate directory
    if os.path.exists(ios_path):
        shutil.rmtree(ios_path)
    os.makedirs(ios_path, exist_ok=True)
    
    # Create Contents.json
    contents = create_clean_contents_json()
    with open(f"{ios_path}/Contents.json", 'w') as f:
        json.dump(contents, f, indent=2)
    
    # Create all iOS icons
    ios_sizes = {
        "AppIcon-20x20@2x.png": 40, "AppIcon-20x20@3x.png": 60,
        "AppIcon-29x29@2x.png": 58, "AppIcon-29x29@3x.png": 87,
        "AppIcon-40x40@2x.png": 80, "AppIcon-40x40@3x.png": 120,
        "AppIcon-60x60@2x.png": 120, "AppIcon-60x60@3x.png": 180,
        "AppIcon-20x20@1x.png": 20, "AppIcon-29x29@1x.png": 29,
        "AppIcon-40x40@1x.png": 40, "AppIcon-76x76@1x.png": 76,
        "AppIcon-76x76@2x.png": 152, "AppIcon-83.5x83.5@2x.png": 167,
        "AppIcon-1024x1024@1x.png": 1024
    }
    
    ios_success = 0
    for filename, size in ios_sizes.items():
        output_path = f"{ios_path}/{filename}"
        if create_precise_icon(source_png, output_path, size):
            print(f"✅ {filename}")
            ios_success += 1
        else:
            print(f"❌ {filename}")
    
    # watchOS AppIcon rebuild
    watch_path = f"{base_path}/Forava_PreWired_Workspace/Forava_WatchAssets.xcassets/AppIcon.appiconset"
    print(f"⌚ Rebuilding watchOS AppIcon at {watch_path}")
    
    # Remove and recreate directory
    if os.path.exists(watch_path):
        shutil.rmtree(watch_path)
    os.makedirs(watch_path, exist_ok=True)
    
    # Create Contents.json
    watch_contents = create_clean_watch_contents_json()
    with open(f"{watch_path}/Contents.json", 'w') as f:
        json.dump(watch_contents, f, indent=2)
    
    # Create all watchOS icons
    watch_sizes = {
        "AppIcon-24x24@2x.png": 48, "AppIcon-27.5x27.5@2x.png": 55,
        "AppIcon-29x29@2x.png": 58, "AppIcon-29x29@3x.png": 87,
        "AppIcon-40x40@2x.png": 80, "AppIcon-44x44@2x.png": 88,
        "AppIcon-46x46@2x.png": 92, "AppIcon-50x50@2x.png": 100,
        "AppIcon-86x86@2x.png": 172, "AppIcon-98x98@2x.png": 196,
        "AppIcon-108x108@2x.png": 216, "AppIcon-1024x1024@1x.png": 1024
    }
    
    watch_success = 0
    for filename, size in watch_sizes.items():
        output_path = f"{watch_path}/{filename}"
        if create_precise_icon(source_png, output_path, size):
            print(f"✅ {filename}")
            watch_success += 1
        else:
            print(f"❌ {filename}")
    
    print(f"📊 Results: iOS {ios_success}/15, watchOS {watch_success}/12")
    return ios_success == 15 and watch_success == 12

if __name__ == "__main__":
    success = rebuild_appicon_completely()
    if success:
        print("🎉 AppIcon asset catalogs rebuilt successfully!")
    else:
        print("❌ Some icons failed to rebuild")