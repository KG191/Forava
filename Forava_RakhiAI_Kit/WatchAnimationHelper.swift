import SwiftUI
import WatchKit

struct FrameAnimatorView: View {
    let baseName: String
    let frameCount: Int
    let fps: Double
    
    @State private var currentFrame = 0
    private var timer: Timer.TimerPublisher
    
    init(baseName: String, frameCount: Int, fps: Double) {
        self.baseName = baseName
        self.frameCount = frameCount
        self.fps = fps
        self.timer = Timer.publish(every: 1.0/fps, on: .main, in: .common)
    }
    
    var body: some View {
        Image("\(baseName)\(String(format: "%04d", currentFrame))")
            .resizable()
            .scaledToFit()
            .onReceive(timer.autoconnect()) { _ in
                currentFrame = (currentFrame + 1) % frameCount
            }
    }
}
