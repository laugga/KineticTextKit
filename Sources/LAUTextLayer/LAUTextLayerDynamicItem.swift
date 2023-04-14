import UIKit

public class LAUTextLayerDynamicItem: NSObject, UIDynamicItem {
    
    private var layer: LAUTextLayer
    
    public init(layer: LAUTextLayer) {
        print("LAUTextLayerDynamicItem init")
        self.layer = layer
        super.init()
        self.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5) // FIXME
    }
    
    public var bounds: CGRect {
        return layer.bounds
    }
    
    public var center: CGPoint {
        get {
            return self.layer.position
        }
        set(center) {
            self.layer.position = center
        }
    }
    
    public var transform: CGAffineTransform {
        get {
            self.layer.affineTransform()
        }
        set(transform) {
            self.layer.setAffineTransform(transform)
        }
    }
}
