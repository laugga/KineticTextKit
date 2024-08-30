import UIKit

@MainActor public class LAUSwitch : UIControl {
    
    // MARK: - Creating a switch
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        addTextLayers()
        updateContent()
    }
    
    // MARK: - Setting the on/off state
    
    private var value: Bool = false
    open var isOn: Bool {
        get {
            return value
        }
        set {
            update(value: newValue)
        }
    }
    
    open func setOn(_ newValue: Bool, animated: Bool) {
        update(value: newValue, animated: animated)
    }
    
    private func update(value newValue: Bool, animated: Bool = false) {
        if value != newValue {
            value = newValue
            sendActions(for: .valueChanged)
            updateStyle(animated: animated)
        }
    }
    
    // MARK: - Configuration
    
    open var configuration: Configuration = .defaultConfiguration {
        didSet {
            updateContent()
        }
    }
    
    public struct Configuration {
        let title: Title
        let style: Style
        
        public init(title: LAUSwitch.Configuration.Title, style: LAUSwitch.Configuration.Style) {
            self.title = title
            self.style = style
        }
        
        public struct Title {
            let on: String
            let off: String
            
            public init(on: String, off: String) {
                self.on = on
                self.off = off
            }
            
            fileprivate static let defaultTitle: Title = .init(on: "ON", off: "OFF")
        }
        
        public struct Style {
            let enabled: TitleStyle
            let disabled: TitleStyle
            
            public init(enabled: LAUSwitch.Configuration.Style.TitleStyle, disabled: LAUSwitch.Configuration.Style.TitleStyle) {
                self.enabled = enabled
                self.disabled = disabled
            }
            
            public struct TitleStyle {
                let font: UIFont
                let color: UIColor
                
                public init(font: UIFont, color: UIColor) {
                    self.font = font
                    self.color = color
                }
            }
            
            fileprivate static let defaultStyle: Style = .init(enabled: .init(font: .systemFont(ofSize: 30), color: .black),
                                                               disabled: .init(font: .systemFont(ofSize: 22), color: .black.withAlphaComponent(0.5)))
        }
        
        fileprivate static let defaultConfiguration: Configuration = .init(title: .defaultTitle, style: .defaultStyle)
    }
    
    // MARK: - Private
    
    private let onLayer = KineticTextLayer()
    private let offLayer = KineticTextLayer()
    
    private func addTextLayers() {
        layer.addSublayer(onLayer)
        layer.addSublayer(offLayer)
        offLayer.contentMode = .topLeft
        onLayer.contentMode = .bottomLeft
    }
    
    private func updateContent() {
        updateTextLayersFrames()
        updateTitle()
        updateStyle()
        invalidateIntrinsicContentSize()
    }
    
    private func updateTitle() {
        onLayer.text = configuration.title.on
        offLayer.text = configuration.title.off
    }
    
    private func updateStyle(animated: Bool = false) {
        onLayer.textColor = switchState.onLayer.color
        offLayer.textColor = switchState.offLayer.color
        onLayer.setFont(switchState.onLayer.font, animated: animated)
        offLayer.setFont(switchState.offLayer.font, animated: animated)
    }
    
    private struct SwitchState {
        let onLayer: Configuration.Style.TitleStyle
        let offLayer: Configuration.Style.TitleStyle
    }
    
    private var switchState: SwitchState {
        switch isOn {
        case true:
            return .init(onLayer: configuration.style.enabled,
                         offLayer: configuration.style.disabled)
        case false:
            return .init(onLayer: configuration.style.disabled,
                         offLayer: configuration.style.enabled)
        }
    }
    
    // MARK: - Intrinsic Content Size
    
    public override var intrinsicContentSize: CGSize {
        return calculateTextLayersBounds(title: configuration.title, state: switchState)
    }
    
    private func updateTextLayersFrames() {
        let bounds = calculateTextLayersBounds(title: configuration.title, state: switchState)
        onLayer.frame = .init(origin: .zero, size: bounds)
        offLayer.frame = .init(origin: .zero, size: bounds)
    }
    
    private func calculateTextLayersBounds(title: Configuration.Title, state: SwitchState) -> CGSize {
        let onLayerSize = sizeThatFits(title.on, font: state.onLayer.font)
        let offLayerSize = sizeThatFits(title.off, font: state.offLayer.font)
        let spacing: CGFloat = 4
        return .init(width: max(onLayerSize.width, offLayerSize.width), height: onLayerSize.height+spacing+offLayerSize.height)
    }
    
    private func sizeThatFits(_ text: String, font: UIFont) -> CGSize {
        let attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font]
        let boundingRect = text.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesDeviceMetrics, attributes: attributes, context: nil).size
        let size = CGSize(width: ceil(boundingRect.width), height: ceil(boundingRect.height))
        return size
    }
    
    // MARK: - Interaction
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let shouldBegin = super.beginTracking(touch, with: event)
        return shouldBegin
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let shouldContinue = super.continueTracking(touch, with: event)
        
        // Check if the touch is still inside the control's bounds
        if bounds.contains(touch.location(in: self)) {
            // Handle touch continuation, if needed
        } else {
            // Handle touch moved outside the control, if needed
        }
        
        return shouldContinue
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        if let touch = touch, bounds.contains(touch.location(in: self)) {
            // sendActions(for: .touchUpInside)
            setOn(!isOn, animated: true)
            HapticFeedbackPlayer.shared.play(style: .light) // TODO check impact on thread and ui change for perceived response
        } else {
            // sendActions(for: .touchUpOutside)
        }
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
    }
}

//@available(iOS 17.0, *)
//#Preview {
//    let lauswitch = LAUSwitch()
//    return lauswitch
//}
