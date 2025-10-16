#!/bin/bash
# Remove specific duplicate build file entries that cause "Multiple commands produce" errors

PROJECT_FILE="Forava.xcodeproj/project.pbxproj"

echo "Removing specific duplicate build file entries..."

# List of duplicate build IDs to remove (keeping the first occurrence of each file)
DUPLICATES_TO_REMOVE=(
    "213539C52E6BE51500CC85B0"  # BirthdayDesignView.swift (duplicate)
    "213539C72E6BE51F00CC85B0"  # ChineseNewYearDesignView.swift (duplicate)
    "213539CB2E6BE53400CC85B0"  # EasterDesignView.swift (duplicate)
    "2527D7B16A9447E1A11A8642"  # EidAlAdhaDesignView.swift (duplicate)
    "32DC6D07ACE74DB7A16CFBD4"  # HanukkahDesignView.swift (duplicate)
    "510C03F413C048AF833C48CD"  # RakshaBandhanDesignView.swift (duplicate)
    "63736A57EBA14574B9500C38"  # VesakDayDesignView.swift (duplicate)
    "6FCEFDAE81C244B1B62B156E"  # DiwaliDesignView.swift (duplicate)
    "99338DC8A7494F0095BA36DA"  # MidAutumnFestivalDesignView.swift (duplicate)
    "BA1AD0DE051342D79C39108F"  # ChristmasDesignView.swift (duplicate)
    "D3C75590AAD84403996A926A"  # AnniversaryDesignView.swift (duplicate)
    "D4960799A14A4E3D8D1921D6"  # RoshHashanahDesignView.swift (duplicate)
    "D749ECF7F3054DCFAE79A598"  # EidAlFitrDesignView.swift (duplicate)
)

# Remove lines containing these build IDs
for build_id in "${DUPLICATES_TO_REMOVE[@]}"; do
    echo "Removing lines containing build ID: $build_id"
    sed -i.temp "/$build_id/d" "$PROJECT_FILE"
done

echo "Cleanup completed!"

# Check the result
echo "Checking remaining DesignView file counts:"
grep "DesignView.swift in Sources" "$PROJECT_FILE" | sed 's/.*\/\* \(.*DesignView\.swift\) in Sources.*/\1/' | sort | uniq -c