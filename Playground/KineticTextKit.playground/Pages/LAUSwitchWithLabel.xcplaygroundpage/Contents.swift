//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import KineticTextKit
import Combine

let toggleSwitch = LAUSwitch()

toggleSwitch.frame = .init(x: 16, y: 16, width: 200, height: 30)
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
    let enabledStyle = LAUSwitch.Configuration.Style.TitleStyle(font: .systemFont(ofSize: 26), color: .black.withAlphaComponent(0.5))
    let disabledStyle = LAUSwitch.Configuration.Style.TitleStyle(font: .systemFont(ofSize: 14), color: .blue)
    
    toggleSwitch.configuration = .init(title: .init(on: "     ",
                                                    off: "Title"),
                                       style: .init(enabled: enabledStyle,
                                                    disabled: disabledStyle))
    
    PlaygroundPage.current.liveView = toggleSwitch
}

//: [Next](@next)
