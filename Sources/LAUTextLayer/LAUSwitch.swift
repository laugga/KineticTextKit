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
        offLayer.contentMode = .bottomLeft
        onLayer.contentMode = .topLeft
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

/*
 //
 //  CameraSwitchButton.swift
 //  Lightmate
 //
 //  Created by Luis Laugga on 27.07.22.
 //  Copyright © 2022 Laugga Practice. All rights reserved.
 //

 import Foundation
 import UIKit

 protocol CameraSwitchButtonDelegate: AnyObject {
     
     /*!
      Called when switch button changes.
      @param cameraSwitchButton The CameraSwitchButton for which the mode changed.
      @param CameraMode The new CameraSwitchButton mode value.
      */
     func cameraSwitchButton(_ button: CameraSwitchButton, didChangeMode: CameraPosition) -> Bool
 }

 class CameraSwitchButton: UIControl {
     
     public weak var delegate: CameraSwitchButtonDelegate?
     
     var labelF: UILabel
     var labelB: UILabel
     
     // Mode (default is back)
     public var mode: CameraPosition = .back {
         didSet {
             if mode != oldValue {
                 updateLabels()
                 HapticFeedbackPlayer.shared.play(style: .medium)
             }
         }
     }
     
     enum LayoutConstants: CGFloat {
         case left = 12.0
         case right = -12.0
         case top = 6.0
         case bottom = -6.0
         case inner = -10.0
     }
     
     required init() {
         
         self.labelF = CameraSwitchButton.createLabel(title: Localization.Localizable.cameraSwitchFrontButtonTitle)
         self.labelB = CameraSwitchButton.createLabel(title: Localization.Localizable.cameraSwitchBackButtonTitle)
         
         super.init(frame: .zero)
         
         addSubview(labelB)
         labelB.sizeToFit()
         
         addSubview(labelF)
         labelF.sizeToFit()
         
         // Update state
         updateLabels()
         
         // Layout Constraints
         let layoutConstraints: [NSLayoutConstraint] = [
             labelB.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.top.rawValue),
             labelB.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.left.rawValue),
             labelB.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: LayoutConstants.right.rawValue),
             labelF.topAnchor.constraint(equalTo: labelB.bottomAnchor, constant: LayoutConstants.inner.rawValue),
             labelF.bottomAnchor.constraint(equalTo: bottomAnchor, constant: LayoutConstants.bottom.rawValue),
             labelF.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.left.rawValue),
             labelF.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: LayoutConstants.right.rawValue)
         ]
         NSLayoutConstraint.activate(layoutConstraints)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     private static func createLabel(title: String) -> UILabel {
         let label = UILabel()
         label.translatesAutoresizingMaskIntoConstraints = false
         label.text = title.uppercased()
         label.textColor = UIColor.lightmateWhite
         label.font = UIFont.lightmate30ptRegular
         return label
     }
         
     // MARK: - UISwitch
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
         
         // Notify delegate
         if let didSwitch = delegate?.cameraSwitchButton(self, didChangeMode: mode), didSwitch {
             
             // Toggle mode
             self.mode = (mode == .front ? CameraPosition.back : CameraPosition.front);
         }
     }
     
     // MARK: - Label
     
     private func updateLabels() {
         
         if mode == .back {
             labelB.textColor = UIColor.lightmateWhite
             labelF.textColor = UIColor.lightmateWhiteTranslucent
         } else {
             labelF.textColor = UIColor.lightmateWhite
             labelB.textColor = UIColor.lightmateWhiteTranslucent
         }
     }
 }

 */
