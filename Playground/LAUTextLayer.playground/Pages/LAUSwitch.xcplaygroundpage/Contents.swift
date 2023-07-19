//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import LAUTextLayer
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
    toggleSwitch.configuration = .init(title: .init(on: "FRONT", off: "BACK"),
                                       style: .init(isOn: .init(on: .init(font: .systemFont(ofSize: 30),
                                                                          color: .black),
                                                                off: .init(font: .systemFont(ofSize: 22),
                                                                           color: .black.withAlphaComponent(0.5))),
                                                    isOff: .init(on: .init(font: .systemFont(ofSize: 22),
                                                                           color: .black.withAlphaComponent(0.5)),
                                                                 off: .init(font: .systemFont(ofSize: 30),
                                                                            color: .black))))
    PlaygroundPage.current.liveView = toggleSwitch
}

//: [Next](@next)
