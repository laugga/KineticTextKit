//: [Previous](@previous)

import SwiftUI
import KineticTextKit
import PlaygroundSupport

struct ContentView: View {
    
    private var textLabel = LAULabel(text: "2.0", font: .systemFont(ofSize: 40.0), textColor: .red)
    
    var body: some View {

        Button {
            textLabel.setFont(font: .systemFont(ofSize: 40.0, weight: .bold), animated: true)
        } label: {
            textLabel
        }
    }
}

PlaygroundPage.current.setLiveView(ContentView())

//: [Next](@next)
