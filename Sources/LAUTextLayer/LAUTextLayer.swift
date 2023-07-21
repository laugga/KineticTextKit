import UIKit

public class LAUTextLayer: CAShapeLayer {
    
    public override init(layer: Any) {
        print("LAUTextLayer init layer \(layer)")
        super.init(layer: layer)
    }
    
    public var text: String? {
        didSet {
            updatePath()
        }
    }
    
    public var font: UIFont? {
        didSet {
            updatePath()
        }
    }
    
    public var textColor: UIColor? {
        didSet {
            updateFillColor()
        }
    }
    
    public var contentMode: UIView.ContentMode = .center {
        didSet {
            updatePath()
        }
    }
    
    private var previousPath: CGPath?
    
    public func setFont(_ font: UIFont, animated: Bool) {
        print("setFont \(font) animated \(animated)")
        self.font = font
        
        if let oldPath = previousPath, let newPath = path, animated {
            let animation = createAnimation(from: oldPath, to: newPath)
            add(animation, forKey: "path")
        }
    }
    
    override public init() {
        super.init()
        print("LAUTextLayer init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updatePath() {
        guard let text = text, let font = font else {
            return
        }
        previousPath = path
        path = createTextPath(text: text, font: font)
        print("updated path")
    }
    
    private func updateFillColor() {
        guard let textColor = textColor else {
            return
        }
        fillColor = textColor.cgColor
    }
    
    // MARK: - Helpers
    
    private func createAnimation(from: CGPath, to: CGPath) -> CABasicAnimation {
        print("createAnimation")
        let animation = CABasicAnimation(keyPath: "path")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = 0.15 // duration is 1 sec
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = .both // why do we need this
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    private func createTextAttributedString(string: String, font: UIFont) -> NSAttributedString {
       
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.6
        paragraphStyle.alignment = .center
        
        let attributes = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.foregroundColor: UIColor.black,
                          NSAttributedString.Key.kern: NSNumber(value: 0)]
        
        return NSAttributedString(string: string, attributes:attributes)
    }
    
    private func createTextPath(text: String, font: UIFont) -> CGPath? {
        
        let containerPath = CGMutablePath()
        
        let textPath = CGMutablePath()
        
        let attributedString = createTextAttributedString(string: text, font: font)
        let line = CTLineCreateWithAttributedString(attributedString)
        let runs = (CTLineGetGlyphRuns(line) as [AnyObject]) as! [CTRun]
        
        for run in runs {
            
            let attributes: NSDictionary = CTRunGetAttributes(run)
            let font = attributes[kCTFontAttributeName as String] as! CTFont
            
            let glyphCount = CTRunGetGlyphCount(run)
            
            for index in 0..<glyphCount {
                
                let range = CFRangeMake(index, 1)
                
                var glyph = CGGlyph()
                CTRunGetGlyphs(run, range, &glyph)
                
                var position = CGPoint()
                CTRunGetPositions(run, range, &position)
                
                if let letterPath = CTFontCreatePathForGlyph(font, glyph, nil) {
                    let transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: position.x, ty: position.y)
                    textPath.addPath(letterPath, transform: transform)
                }
            }
        }
        
        let transform = contentModeTransform(textPath: textPath)
        print("transform \(transform)")
        containerPath.addPath(textPath, transform: transform)
   
        return containerPath
    }
    
    private func contentModeTransform(textPath: CGPath) -> CGAffineTransform {
        switch contentMode {
        case .center:
            return .init(translationX: 0, y: textPath.boundingBox.height + (frame.size.height-textPath.boundingBox.height)/2)  // FIXME will not work if frame is not set
        case .topLeft:
            return .init(translationX: 0, y: textPath.boundingBox.height)
        case .bottomLeft:
            return .init(translationX: 0, y: frame.size.height) // FIXME will not work if frame is not set
        default:
            return .identity // TODO other cases
        }
    }
}
