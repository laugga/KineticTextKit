//: [Previous](@previous)

import PlaygroundSupport
import UIKit
import LAUTextLayer

class ViewController : UIViewController {
    
    let pathSwitch = LAUPathSwitch()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        pathSwitch.frame = CGRect(x: 16, y: 16, width: 60, height: 16)
        pathSwitch.tintColor = .white
        pathSwitch.backgroundColor = .black
        
        view.addSubview(pathSwitch)
        self.view = view
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
}

PlaygroundPage.current.liveView = ViewController()

//: [Next](@next)
