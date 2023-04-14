//: [Previous](@previous)

import PlaygroundSupport
import UIKit

class ViewController : UIViewController {
    
    private lazy var shapeLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.path = UIBezierPath(roundedRect: CGRect(x: 64, y: 64, width: 160, height: 160), cornerRadius: 50).cgPath
        layer.fillColor = UIColor.red.cgColor
        return layer
    }()
    
    lazy var animateButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 44.0))
        button.backgroundColor = .blue
        button.layer.cornerRadius = 15.0
        button.setTitle("Animate", for: .normal)
        return button
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        view.addSubview(animateButton)
        animateButton.addTarget(self, action: #selector(self.didTapAnimateButton(sender:)), for: .touchUpInside)
        
        view.layer.addSublayer(shapeLayer)

        self.view = view
    }
    
    // MARK: - Animations
    
    @objc func didTapAnimateButton(sender: UIButton) {
        implicitAnimation_PositionRight()
    }
    
    private func implicitAnimation_PositionRight() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(5.0)
        shapeLayer.position = __CGPointApplyAffineTransform(shapeLayer.position, .init(translationX: 100, y: 0))
        CATransaction.setCompletionBlock { [weak self] in
            self?.implicitAnimation_PositionLeft()
        }
        CATransaction.commit()
    }
    
    private func implicitAnimation_PositionLeft() {
        CATransaction.begin()
        CATransaction.setAnimationDuration(5.0)
        shapeLayer.position = __CGPointApplyAffineTransform(shapeLayer.position, .init(translationX: -100, y: 0))
        CATransaction.commit()
    }
}

PlaygroundPage.current.liveView = ViewController()

//: [Next](@next)
