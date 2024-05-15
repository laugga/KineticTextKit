import UIKit

public class LAUTextView: UIView {
    
    public let textLayer = KineticTextLayer()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    private func setupLayers() {
        layer.addSublayer(textLayer)
    }
}
