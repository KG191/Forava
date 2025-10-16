#!/usr/bin/env python3
"""
Fix incorrect file path references in Xcode project.pbxproj
Files are being referenced from wrong root directory instead of proper subdirectories.
"""

import re

def fix_file_paths():
    """Fix file path references that are pointing to wrong locations."""
    
    project_file = "Forava.xcodeproj/project.pbxproj"
    
    # Mapping of incorrect file paths to correct file paths
    path_fixes = {
        'SharedCulturalTypes.swift': 'ForavaApp/Models/SharedCulturalTypes.swift',
        'SubscriptionModels.swift': 'ForavaApp/Models/SubscriptionModels.swift', 
        'CoreTypes.swift': 'ForavaApp/Models/CoreTypes.swift',
        'LazyLoadingManager.swift': 'ForavaApp/Services/LazyLoadingManager.swift',
        'PerformanceMonitor.swift': 'ForavaApp/Services/PerformanceMonitor.swift',
        'SubscriptionManager.swift': 'ForavaApp/Services/SubscriptionManager.swift',
        'CulturalCalendarService.swift': 'ForavaApp/Services/Calendar/CulturalCalendarService.swift',
        'CulturalNotificationManager.swift': 'ForavaApp/Services/Calendar/CulturalNotificationManager.swift',
        'CulturalCommunityService.swift': 'ForavaApp/Services/Social/CulturalCommunityService.swift',
        'CulturalDesignProtocol.swift': 'ForavaApp/Views/CulturalDesigns/Shared/CulturalDesignProtocol.swift',
        'CulturalDesignComponents.swift': 'ForavaApp/Views/CulturalDesigns/Shared/CulturalDesignComponents.swift',
        'CulturalDesignViewModel.swift': 'ForavaApp/Views/CulturalDesigns/Shared/CulturalDesignViewModel.swift',
        'GiftDesignTypes.swift': 'ForavaApp/Views/CulturalDesigns/Shared/GiftDesignTypes.swift',
        'OptimizedCulturalDesignComponents.swift': 'ForavaApp/Views/CulturalDesigns/Shared/OptimizedCulturalDesignComponents.swift',
        'SubscriptionTierView.swift': 'ForavaApp/Views/Subscription/SubscriptionTierView.swift',
        'PremiumCulturalPacksView.swift': 'ForavaApp/Views/Subscription/PremiumCulturalPacksView.swift',
        'UsageDashboardView.swift': 'ForavaApp/Views/Subscription/UsageDashboardView.swift'
    }
    
    with open(project_file, 'r') as f:
        content = f.read()
    
    # Fix each incorrect path reference
    fixed_count = 0
    for incorrect_filename, correct_path in path_fixes.items():
        # Look for file reference patterns
        old_pattern = f'path = {incorrect_filename};'
        new_pattern = f'path = {correct_path};'
        
        if old_pattern in content:
            content = content.replace(old_pattern, new_pattern)
            print(f"Fixed: {incorrect_filename} -> {correct_path}")
            fixed_count += 1
        else:
            print(f"Not found: {incorrect_filename}")
    
    # Write the fixed content back
    with open(project_file, 'w') as f:
        f.write(content)
    
    print(f"\nFixed {fixed_count} file path references")
    return fixed_count

if __name__ == "__main__":
    print("Fixing incorrect file path references in Xcode project...")
    fix_file_paths()