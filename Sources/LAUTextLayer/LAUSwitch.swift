import UIKit

@MainActor public class LAUSwitch : UIControl {
    
    // MARK: - Creating a switch
    
    override init(frame: CGRect) {
        configuration = .defaultConfiguration
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        configuration = .defaultConfiguration
        super.init(coder: coder)
    }
    
    // MARK: - Setting the on/off state
    
    open var isOn: Bool = false
    
    open func setOn(_ on: Bool, animated: Bool) {
        
    }
    
    // MARK: - Configuration
    
    open var configuration: Configuration
    
    public struct Configuration {
        let title: Title
        let style: Style
        
        struct Title {
            let on: String
            let off: String
            
            fileprivate static let defaultTitle: Title = .init(on: "ON", off: "OFF")
        }
        
        struct Style {
            let isOn: SwitchState
            let isOff: SwitchState
            
            struct SwitchState {
                let on: TitleState
                let off: TitleState
            }
            
            struct TitleState {
                let font: UIFont
                let color: UIColor
            }
            
            fileprivate static let defaultStyle: Style = .init(isOn: .init(on: .init(font: .systemFont(ofSize: 30), color: .white),
                                                                           off: .init(font: .systemFont(ofSize: 22), color: .white.withAlphaComponent(0.5))),
                                                               isOff: .init(on: .init(font: .systemFont(ofSize: 22), color: .white.withAlphaComponent(0.5)),
                                                                            off: .init(font: .systemFont(ofSize: 30), color: .white)))
        }
        
        fileprivate static let defaultConfiguration: Configuration = .init(title: .defaultTitle, style: .defaultStyle)
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
