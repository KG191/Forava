#!/usr/bin/env python3
"""
Fix red square icons by properly copying and resizing Forava_AppIcon_1.png
"""
import subprocess
import os
import shutil

def fix_app_icons():
    base_path = "/Users/kirangokal/Documents/Forava"
    source_png = f"{base_path}/Forava_AppIcon_1.png"
    
    # Verify source exists
    if not os.path.exists(source_png):
        print(f"❌ Source file not found: {source_png}")
        return False
    
    print(f"✅ Using source: {source_png}")
    
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
    
    # watchOS icons
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
    
    def create_icon(source, output_path, size):
        """Create icon using multiple fallback methods"""
        try:
            # Method 1: Try sips with high quality
            result = subprocess.run([
                "sips", "-z", str(size), str(size),
                "-s", "format", "png",
                "-s", "formatOptions", "100",
                source, "--out", output_path
            ], check=True, capture_output=True, text=True)
            return True
        except subprocess.CalledProcessError:
            try:
                # Method 2: Try Python PIL if available
                from PIL import Image
                with Image.open(source) as img:
                    resized = img.resize((size, size), Image.Resampling.LANCZOS)
                    resized.save(output_path, "PNG")
                return True
            except ImportError:
                pass
            except Exception:
                pass
            
            try:
                # Method 3: Try basic sips
                subprocess.run([
                    "sips", "-z", str(size), str(size), source, "--out", output_path
                ], check=True, capture_output=True)
                return True
            except subprocess.CalledProcessError:
                pass
            
            # Method 4: For 1024x1024, just copy the file
            if size == 1024:
                shutil.copy2(source, output_path)
                return True
                
        return False
    
    # Fix iOS icons
    ios_path = f"{base_path}/Forava_Assets.xcassets/AppIcon.appiconset"
    print(f"🍎 Fixing iOS icons in {ios_path}")
    
    for filename, size in ios_icons.items():
        output_path = f"{ios_path}/{filename}"
        if create_icon(source_png, output_path, size):
            print(f"✅ Created {filename} ({size}x{size})")
            # Verify the file was created properly
            if os.path.exists(output_path) and os.path.getsize(output_path) > 100:
                print(f"   ✓ Verified {filename}")
            else:
                print(f"   ⚠️  Warning: {filename} may be corrupted")
        else:
            print(f"❌ Failed to create {filename}")
    
    # Fix watchOS icons
    watch_path = f"{base_path}/Forava_WatchAssets.xcassets/AppIcon.appiconset"
    print(f"⌚ Fixing watchOS icons in {watch_path}")
    
    for filename, size in watch_icons.items():
        output_path = f"{watch_path}/{filename}"
        if create_icon(source_png, output_path, size):
            print(f"✅ Created {filename} ({size}x{size})")
            # Verify the file was created properly
            if os.path.exists(output_path) and os.path.getsize(output_path) > 100:
                print(f"   ✓ Verified {filename}")
            else:
                print(f"   ⚠️  Warning: {filename} may be corrupted")
        else:
            print(f"❌ Failed to create {filename}")

if __name__ == "__main__":
    print("🔧 Fixing red square icons...")
    fix_app_icons()
    print("🎉 Icon fix complete! Check Xcode Asset Catalog.")