//: [Previous](@previous)

import PlaygroundSupport
import UIKit
import KineticTextKit

class ViewController : UIViewController {
    
    var font: UIFont = .systemFont(ofSize: 15, weight: .semibold)
    
    let textLayer = KineticTextLayer()
    
    let fontPointSizeSlider = UISlider(frame: .init(x: 10, y: 10, width: 100, height: 100))
    
    let fontWeightSegmentedControl = UISegmentedControl(items: ["Light", "Regular", "Bold"])
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        fontWeightSegmentedControl.addTarget(self, action: #selector(didChangeFontWeightSegmentedControl(sender:)), for: .valueChanged)
        view.addSubview(fontWeightSegmentedControl)
        
        fontPointSizeSlider.frame = CGRect(x: 150, y: 200, width: 200, height: 100)
        fontPointSizeSlider.minimumValue = Float(font.pointSize)
        fontPointSizeSlider.maximumValue = 150
        fontPointSizeSlider.addTarget(self, action: #selector(didChangeFontSizeSlider(sender:)), for: .touchUpInside)
        view.addSubview(fontPointSizeSlider)
        
        textLayer.frame = CGRect(x: 150, y: 200, width: 50, height: 50)
        textLayer.text = "2.8"
        textLayer.font = font
        textLayer.textColor = .black
        //textLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        view.layer.addSublayer(textLayer)
        self.view = view
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let bounds = view.bounds
        fontWeightSegmentedControl.frame = CGRect(x: 10, y: 10, width: bounds.width-20, height: 50)
        fontPointSizeSlider.frame = CGRect(x: 10, y: fontWeightSegmentedControl.frame.origin.y+fontWeightSegmentedControl.frame.size.height, width: bounds.width-20, height: 50)
        
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @objc func didChangeFontSizeSlider(sender: UIControl) {
        font = UIFont(descriptor: font.fontDescriptor, size: CGFloat(fontPointSizeSlider.value))
        textLayer.setFont(font, animated: true)
    }
    
    @objc func didChangeFontWeightSegmentedControl(sender: UIControl) {
        
        var font = UIFont(descriptor: font.fontDescriptor, size: CGFloat(fontPointSizeSlider.value))
        
        switch fontWeightSegmentedControl.selectedSegmentIndex {
        case 0:
            font = .systemFont(ofSize: font.pointSize, weight: .ultraLight)
        case 1:
            font = .systemFont(ofSize: font.pointSize, weight: .regular)
        case 2:
            font = .systemFont(ofSize: font.pointSize, weight: .bold)
        default:
            break
        }
        
        textLayer.setFont(font, animated: true)
    }
}

PlaygroundPage.current.liveView = ViewController()

//: [Next](@next)
