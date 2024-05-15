//: [Previous](@previous)

import PlaygroundSupport
import UIKit
import KineticTextKit

class ViewController : UIViewController {
    
    lazy var textLayerA = KineticTextLayer()
    var textLayerDynamicItemA: KineticTextKitDynamicItem?
    
    lazy var textLayerB = KineticTextLayer()
    var textLayerDynamicItemB: KineticTextKitDynamicItem?
    
    lazy var button: UIButton =
    {
        let button = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 300.0, height: 200.0))
        button.backgroundColor = .red
        button.layer.cornerRadius = 15.0
        button.setTitle("Tap Me", for: .normal)
        return button
    }()
    
    var buttonBounds = CGRect.zero
    var animator: UIDynamicAnimator?
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        textLayerA.frame = CGRect(x: 100, y: 200, width: 100, height: 100)
        textLayerA.text = "A"
        textLayerA.font = .systemFont(ofSize: 30, weight: .semibold)
        textLayerA.textColor = .black
        view.layer.addSublayer(textLayerA)
        self.view = view
        
        textLayerDynamicItemA = .init(layer: textLayerA)
        
        textLayerB.frame = CGRect(x: 200, y: 200, width: 100, height: 100)
        textLayerB.text = "B"
        textLayerB.font = .systemFont(ofSize: 30, weight: .semibold)
        textLayerB.textColor = .black
        view.layer.addSublayer(textLayerB)
        self.view = view
        
        textLayerDynamicItemB = .init(layer: textLayerB)
        
        view.addSubview(button)
        button.addTarget(self, action: #selector(self.didPressButton(sender:)), for: .touchUpInside)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white

        buttonBounds = button.bounds
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        button.center = view.center
    }
    
    @objc func didPressButton(sender: UIButton)
    {
        guard let dynamicItemA = textLayerDynamicItemA, let dynamicItemB = textLayerDynamicItemB else {
            return
        }
        
        // Reset bounds so if button is press twice in a row, previous changes don't propogate
        button.bounds = buttonBounds
        let animator = UIDynamicAnimator(referenceView: view)
        
        let attachmentBehavior = UIAttachmentBehavior.limitAttachment(with: dynamicItemA, offsetFromCenter: .init(horizontal: 0.1, vertical: 0.1), attachedTo: dynamicItemB, offsetFromCenter: .zero)

        attachmentBehavior.frequency = 2.0
        attachmentBehavior.damping = 0.1
        attachmentBehavior.length = 50
        animator.addBehavior(attachmentBehavior)
        
        let pushBehavior = UIPushBehavior(items: [dynamicItemA], mode: .instantaneous)
        
        // Change angle to determine how much height/ width should change 45° means heigh:width is 1:1
        pushBehavior.angle = 0
        
        // Larger magnitude means bigger change
        pushBehavior.magnitude = 1.0
        animator.addBehavior(pushBehavior)
        pushBehavior.active = true
        
        // Hold refrence so animator is not released
        self.animator = animator
    }
}

PlaygroundPage.current.liveView = ViewController()

//: [Next](@next)
