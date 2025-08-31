import Foundation
import UIKit

// MARK: - Cultural Mock Image Generator
class CulturalMockImageGenerator {
    static let shared = CulturalMockImageGenerator()

    private init() {}

    func createMockImageData(for context: CulturalContext) -> Data {
        let size = CGSize(width: 512, height: 512)
        let renderer = UIGraphicsImageRenderer(size: size)

        let image = renderer.image { cgContext in
            createCulturalBackground(in: cgContext.cgContext, size: size, context: context)
            addCulturalDecorations(to: cgContext.cgContext, size: size, context: context)
        }

        return image.pngData() ?? Data()
    }

    private func createCulturalBackground(in context: CGContext, size: CGSize, context culturalCtx: CulturalContext) {
        let colors = culturalCtx.colorPalettes.first?.colors ?? []
        let uiColors = colors.isEmpty ?
            [UIColor.orange, UIColor.red, UIColor.yellow] :
            colors.map { UIColor($0.color) }

        if let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: uiColors.map { $0.cgColor } as CFArray,
            locations: nil
        ) {
            context.drawRadialGradient(
                gradient,
                startCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                startRadius: 0,
                endCenter: CGPoint(x: size.width / 2, y: size.height / 2),
                endRadius: min(size.width, size.height) / 2,
                options: []
            )
        }
    }

    private func addCulturalDecorations(to context: CGContext, size: CGSize, context culturalCtx: CulturalContext) {
        switch culturalCtx.identifier {
        case "rakhi_indian":
            addRakhiDecorations(to: context, size: size)
        case "chinese_new_year":
            addChineseDecorations(to: context, size: size)
        case "christmas_christian":
            addChristmasDecorations(to: context, size: size)
        default:
            addGenericCulturalDecorations(to: context, size: size)
        }
    }

    private func addRakhiDecorations(to context: CGContext, size: CGSize) {
        context.setFillColor(UIColor.gold.cgColor)
        let circleSize: CGFloat = 40

        for index in 0..<8 {
            let angle = Double(index) * .pi / 4
            let centerX = size.width / 2 + cos(angle) * 100
            let centerY = size.height / 2 + sin(angle) * 100

            let circle = CGRect(
                x: centerX - circleSize / 2,
                y: centerY - circleSize / 2,
                width: circleSize,
                height: circleSize
            )
            context.fillEllipse(in: circle)
        }

        context.setFillColor(UIColor.darkRed.cgColor)
        let centerRect = CGRect(
            x: size.width / 2 - 30,
            y: size.height / 2 - 30,
            width: 60,
            height: 60
        )
        context.fillEllipse(in: centerRect)
    }

    private func addChineseDecorations(to context: CGContext, size: CGSize) {
        context.setFillColor(UIColor.red.cgColor)

        for index in 0..<4 {
            let x = CGFloat(index % 2) * (size.width / 2) + size.width / 4
            let y = CGFloat(index / 2) * (size.height / 2) + size.height / 4

            let rect = CGRect(x: x - 20, y: y - 20, width: 40, height: 40)
            context.fillEllipse(in: rect)
        }
    }

    private func addChristmasDecorations(to context: CGContext, size: CGSize) {
        context.setFillColor(UIColor.green.cgColor)

        let starPoints: [CGPoint] = [
            CGPoint(x: size.width / 2, y: size.height / 4),
            CGPoint(x: size.width * 0.6, y: size.height * 0.4),
            CGPoint(x: size.width * 0.4, y: size.height * 0.4)
        ]

        context.move(to: starPoints[0])
        context.addLine(to: starPoints[1])
        context.addLine(to: starPoints[2])
        context.closePath()
        context.fillPath()
    }

    private func addGenericCulturalDecorations(to context: CGContext, size: CGSize) {
        context.setFillColor(UIColor.systemBlue.cgColor)
        let centerRect = CGRect(
            x: size.width / 2 - 25,
            y: size.height / 2 - 25,
            width: 50,
            height: 50
        )
        context.fillEllipse(in: centerRect)
    }
}

// MARK: - Color Extensions
extension UIColor {
    static let gold = UIColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0)
    static let darkRed = UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0)
}
