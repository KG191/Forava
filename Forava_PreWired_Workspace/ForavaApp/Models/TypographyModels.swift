import Foundation
import SwiftUI

// MARK: - Typography Models

struct TypographyStyle {
    let primaryFont: Font.Variant
    let secondaryFont: Font.Variant
    let culturalAlignment: CulturalAlignment
    let textDirection: TextDirection
    let fontScale: FontScale
    
    enum Font {
        enum Variant {
            case modern
            case traditional
            case decorative
            case minimalist
            case custom(String)
        }
    }
    
    enum CulturalAlignment {
        case leftToRight
        case rightToLeft
        case centerAligned
        case radial
        case custom(String)
    }
    
    enum TextDirection {
        case horizontal
        case vertical
        case mixed
    }
    
    enum FontScale {
        case compact
        case balanced
        case expanded
    }
}
