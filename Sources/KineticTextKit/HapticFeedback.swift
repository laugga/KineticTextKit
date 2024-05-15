import UIKit

protocol HapticFeedbackPlaying {
    static var shared: HapticFeedbackPlaying { get }
    var isEnabled: Bool { get set }
    func play(style: UIImpactFeedbackGenerator.FeedbackStyle)
}

class HapticFeedbackPlayer: HapticFeedbackPlaying {
    
    static var shared: HapticFeedbackPlaying = HapticFeedbackPlayer()
    
    var isEnabled: Bool = true
    
    public func play(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        
        guard isEnabled else {
            return
        }
        
        triggerImpactFeedbackGenerator(style: style)
    }
    
    init() {
        prepareImpactFeedbackGenerator()
    }
    
    // MARK: - Haptic Feedback
    
    private var lightFeedbackGenerator: UIImpactFeedbackGenerator?
    private var mediumFeedbackGenerator: UIImpactFeedbackGenerator?
    
    private func prepareImpactFeedbackGenerator() {
        lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        lightFeedbackGenerator?.prepare()
        mediumFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        mediumFeedbackGenerator?.prepare()
    }
    
    private func triggerImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        switch style {
        case .light:
            lightFeedbackGenerator?.impactOccurred()
            lightFeedbackGenerator?.prepare()
        case .medium:
            mediumFeedbackGenerator?.impactOccurred()
            mediumFeedbackGenerator?.prepare()
        default:
            break
        }
    }
}
