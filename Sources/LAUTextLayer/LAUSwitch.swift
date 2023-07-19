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
        updateFrame()
        updateTitle()
        updateStyle()
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
            updateFrame()
            updateTitle()
            updateStyle()
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
            let isOn: SwitchState
            let isOff: SwitchState
            
            public init(isOn: LAUSwitch.Configuration.Style.SwitchState, isOff: LAUSwitch.Configuration.Style.SwitchState) {
                self.isOn = isOn
                self.isOff = isOff
            }
            
            public struct SwitchState {
                let on: TitleState
                let off: TitleState
                
                public init(on: LAUSwitch.Configuration.Style.TitleState, off: LAUSwitch.Configuration.Style.TitleState) {
                    self.on = on
                    self.off = off
                }
            }
            
            public struct TitleState {
                let font: UIFont
                let color: UIColor
                
                public init(font: UIFont, color: UIColor) {
                    self.font = font
                    self.color = color
                }
            }
            
            fileprivate static let defaultStyle: Style = .init(isOn: .init(on: .init(font: .systemFont(ofSize: 30), color: .black),
                                                                           off: .init(font: .systemFont(ofSize: 22), color: .black.withAlphaComponent(0.5))),
                                                               isOff: .init(on: .init(font: .systemFont(ofSize: 22), color: .black.withAlphaComponent(0.5)),
                                                                            off: .init(font: .systemFont(ofSize: 30), color: .black)))
        }
        
        fileprivate static let defaultConfiguration: Configuration = .init(title: .defaultTitle, style: .defaultStyle)
    }
    
    // MARK: - Private
    
    private let onLayer = LAUTextLayer()
    private let offLayer = LAUTextLayer()
    
    private func addTextLayers() {
        layer.addSublayer(onLayer)
        layer.addSublayer(offLayer)
        offLayer.contentMode = .topLeft
        onLayer.contentMode = .bottomLeft
    }
    
    private func updateTitle() {
        onLayer.text = configuration.title.on
        offLayer.text = configuration.title.off
    }
    
    private func updateStyle(animated: Bool = false) {
        onLayer.textColor = switchState.on.color
        offLayer.textColor = switchState.off.color
        onLayer.setFont(switchState.on.font, animated: animated)
        offLayer.setFont(switchState.off.font, animated: animated)
    }
    
    private var switchState: Configuration.Style.SwitchState {
        switch isOn {
        case true:
            return configuration.style.isOn
        case false:
            return configuration.style.isOff
        }
    }
    
    private func updateFrame() {
        let textLayersBounds = calculateTextLayersBounds(title: configuration.title, state: switchState)
        frame = CGRect(origin: .zero, size: textLayersBounds)
        onLayer.frame = frame
        offLayer.frame = frame
    }
    
    private func calculateTextLayersBounds(title: Configuration.Title, state: Configuration.Style.SwitchState) -> CGSize {
        
        let onAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: state.on.font]
        let onBoundingRect = NSString(string: title.on).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesDeviceMetrics, attributes: onAttributes, context: nil)
        let onStringSize = CGSize(width: ceil(onBoundingRect.width), height: ceil(onBoundingRect.height))
        
        let offAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: state.off.font]
        let offBoundingRect = NSString(string: title.off).boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: .usesDeviceMetrics, attributes: offAttributes, context: nil)
        let offStringSize = CGSize(width: ceil(offBoundingRect.width), height: ceil(offBoundingRect.height))
        
        let spacing: CGFloat = 4
        return .init(width: max(onStringSize.width, offStringSize.width), height: onStringSize.height+spacing+offStringSize.height)
    }
    
    // MARK: - Interaction
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        setOn(!isOn, animated: true)
    }
}
