import WatchKit
import Foundation

class WatchHapticManager: ObservableObject {
    static let shared = WatchHapticManager()

    private init() {}

    enum HapticType {
        case selection
        case success
        case failure
        case warning
        case start
        case stop
        case click
        case directionalUp
        case directionalDown
    }

    func playHaptic(_ type: HapticType) {
        DispatchQueue.main.async {
            switch type {
            case .selection:
                WKInterfaceDevice.current().play(.click)
            case .success:
                WKInterfaceDevice.current().play(.success)
            case .failure:
                WKInterfaceDevice.current().play(.failure)
            case .warning:
                WKInterfaceDevice.current().play(.failure) // Use failure for warning
            case .start:
                WKInterfaceDevice.current().play(.start)
            case .stop:
                WKInterfaceDevice.current().play(.stop)
            case .click:
                WKInterfaceDevice.current().play(.click)
            case .directionalUp:
                WKInterfaceDevice.current().play(.directionUp)
            case .directionalDown:
                WKInterfaceDevice.current().play(.directionDown)
            }
        }
    }

    func playRakhiReceived() {
        // Special sequence for new rakhi arrival
        playHaptic(.start)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.playHaptic(.success)
        }
    }

    func playPaymentInitiated() {
        // Payment flow start haptic
        playHaptic(.click)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.playHaptic(.click)
        }
    }

    func playPaymentCompleted() {
        // Payment success sequence
        playHaptic(.success)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.playHaptic(.success)
        }
    }

    func playNavigationFeedback() {
        playHaptic(.selection)
    }
}
