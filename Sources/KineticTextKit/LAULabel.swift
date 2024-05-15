import SwiftUI

@available(iOS 14.0, *)
public struct LAULabel: UIViewRepresentable {
    public var text: String
    public var font: UIFont
    public var textColor: Color
//    @Binding public var text: String
//    @Binding public var font: UIFont
//    @Binding public var textColor: Color
    
    public init(text: String, font: UIFont, textColor: Color) {
        self.text = text
        self.font = font
        self.textColor = textColor
    }
    
    public func setFont(font: UIFont, animated: Bool) {
        textView.textLayer.setFont(font, animated: animated)
    }
    
    private var textView: LAUTextView = .init()
    
    public func makeUIView(context: Context) -> LAUTextView {
        return textView
    }

    public func updateUIView(_ uiView: LAUTextView, context: Context) {
        uiView.textLayer.text = text
        uiView.textLayer.font = font
        uiView.textLayer.textColor = .init(textColor)
    }
}
