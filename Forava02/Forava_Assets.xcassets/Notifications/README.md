# Notification Image Assets

This folder contains image assets for cultural notification attachments.

## Required Images

| Image Set | Cultural Context | Description |
|-----------|------------------|-------------|
| `rakhi_notification` | Raksha Bandhan | Colorful Rakhi bracelet image |
| `diya_notification` | Diwali | Traditional Diya lamp with flame |
| `dragon_notification` | Chinese New Year | Red dragon or prosperity symbol |
| `christmas_notification` | Christmas | Christmas tree, ornament, or gift |
| `cultural_default` | All others | Generic celebration/gift image |

## Image Requirements

### Size Recommendations
- **1x:** 100x100 pixels (for standard displays)
- **2x:** 200x200 pixels (for Retina displays)
- **3x:** 300x300 pixels (for Super Retina displays)

### Format
- **Preferred:** PNG with transparency
- **Alternative:** JPEG for photographic images

### Design Guidelines
- Use vibrant, culturally-appropriate colors
- Keep images simple and recognizable at small sizes
- Ensure good contrast for notification visibility
- Avoid text in images (will be too small to read)

## Adding Images

1. Create images at all three resolutions (@1x, @2x, @3x)
2. Name files with appropriate suffix:
   - `rakhi_notification.png` (1x)
   - `rakhi_notification@2x.png` (2x)
   - `rakhi_notification@3x.png` (3x)
3. Drag images into the corresponding `.imageset` folder
4. Xcode will automatically update the Contents.json

## Usage in Code

Images are loaded in `CulturalNotificationManager.swift`:

```swift
private func getCulturalImageURL(for context: CulturalContext) -> URL? {
    let imageName: String
    switch context {
    case .rakshabandhan: imageName = "rakhi_notification"
    case .diwali: imageName = "diya_notification"
    case .chineseNewYear: imageName = "dragon_notification"
    case .christmas: imageName = "christmas_notification"
    default: imageName = "cultural_default"
    }

    return Bundle.main.url(forResource: imageName, withExtension: "jpg")
}
```

**Note:** The code currently looks for `.jpg` files. If using PNG, update the extension in the code.
