//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import KineticTextKit
import Combine

let toggleSwitch = LAUSwitch()

//var toggleSwitchSubscriber: AnyCancellable?
//toggleSwitchSubscriber = toggleSwitch.publisher(for: \.isOn)
//    .sink { isOn in
//        // Handle value change
//        if isOn {
//            print("isOn")
//        } else {
//            print("isOff")
//        }
//    }

let handler = Handler()
toggleSwitch.addTarget(handler, action: #selector(Handler.toggleSwitchValueChanged(_:)), for: .valueChanged)

class Handler: NSObject {
    @objc func toggleSwitchValueChanged(_ sender: LAUSwitch) {
        Task { @MainActor in
            // Handle value change
            if sender.isOn {
                print("isOn")
            } else {
                print("isOff")
            }
        }
    }
}


Task { @MainActor in
    
    toggleSwitch.setNeedsLayout()
    let enabledStyle = LAUSwitch.Configuration.Style.TitleStyle(font: .systemFont(ofSize: 30), color: .black)
    let disabledStyle = LAUSwitch.Configuration.Style.TitleStyle(font: .systemFont(ofSize: 28), color: .black.withAlphaComponent(0.5))
    
    toggleSwitch.configuration = .init(title: .init(on: "FRONT",
                                                    off: "BACK"),
                                       style: .init(enabled: enabledStyle,
                                                    disabled: disabledStyle))
    
    PlaygroundPage.current.liveView = toggleSwitch
}

//: [Next](@next)
