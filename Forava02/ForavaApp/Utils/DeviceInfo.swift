import UIKit
import SwiftUI

struct DeviceInfo {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    // Get screen height in points
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }

    // Compact iPhone detection (iPhone 16e, 13, 14, SE, etc. - screens < 850pt)
    static var isCompactIPhone: Bool {
        isIPhone && screenHeight < 850
    }

    // Calculate responsive spacing - iPad gets 150% more spacing (2.5x)
    static func verticalSpacing(_ base: CGFloat) -> CGFloat {
        isIPad ? base * 2.5 : base
    }

    // Adaptive spacing for all device sizes
    // compact: Small iPhones (< 850pt height like iPhone 16e, SE)
    // standard: Large iPhones (≥ 850pt like 12 Pro Max, 6.5")
    // large: iPads
    static func adaptiveSpacing(compact: CGFloat, standard: CGFloat, large: CGFloat) -> CGFloat {
        if isIPad {
            return large
        } else if isCompactIPhone {
            return compact
        } else {
            return standard
        }
    }
}
