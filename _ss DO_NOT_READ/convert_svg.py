#!/usr/bin/env python3
"""
Convert Forava SVG to PNG using built-in libraries
"""
import subprocess
import sys
import os

def convert_svg_to_png():
    svg_path = "/Users/kirangokal/Documents/Forava/Forava_AppIcon_1024.svg"
    png_path = "/Users/kirangokal/Documents/Forava/Forava_AppIcon_1024.png"
    
    # Try using rsvg-convert (if available)
    try:
        subprocess.run([
            "rsvg-convert", 
            "-w", "1024", 
            "-h", "1024", 
            "-o", png_path, 
            svg_path
        ], check=True)
        print(f"✅ Successfully converted SVG to PNG using rsvg-convert")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        pass
    
    # Try using ImageMagick convert
    try:
        subprocess.run([
            "convert", 
            "-density", "300",
            "-size", "1024x1024",
            svg_path, 
            png_path
        ], check=True)
        print(f"✅ Successfully converted SVG to PNG using ImageMagick")
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        pass
    
    # Try using Safari to render and screenshot
    try:
        # Create a simple HTML file that displays the SVG
        html_content = f"""
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body {{ margin: 0; padding: 0; background: white; }}
                svg {{ width: 1024px; height: 1024px; }}
            </style>
        </head>
        <body>
            {open(svg_path).read()}
        </body>
        </html>
        """
        
        html_path = "/Users/kirangokal/Documents/Forava/temp_svg.html"
        with open(html_path, 'w') as f:
            f.write(html_content)
        
        print("📝 Created HTML file for Safari rendering")
        print(f"🌐 Open file://{html_path} in Safari")
        print("📸 Use Command+Shift+4 to screenshot the icon")
        print("💾 Save as Forava_AppIcon_1024.png")
        
        return False
    except Exception as e:
        print(f"❌ Error creating HTML file: {e}")
        return False

if __name__ == "__main__":
    if not convert_svg_to_png():
        print("\n🔧 Alternative methods:")
        print("1. Install ImageMagick: brew install imagemagick")
        print("2. Install librsvg: brew install librsvg") 
        print("3. Use the HTML file method above")
        print("4. Open SVG in web browser and screenshot")