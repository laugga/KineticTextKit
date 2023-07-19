//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import LAUTextLayer

let toggleSwitch = LAUSwitch()
print(toggleSwitch.frame)
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
    print(toggleSwitch.frame)
    PlaygroundPage.current.liveView = toggleSwitch
}

//: [Next](@next)
