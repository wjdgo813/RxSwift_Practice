//
//  ViewController.swift
//  ObservableAndTheBind.
//
//  Created by JHH on 17/01/2019.
//  Copyright © 2019 JHH. All rights reserved.
//
import ChameleonFramework
import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    var circleView : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setup()
    }
    
    private func setup(){
        self.circleView = UIView(frame: CGRect(origin: self.view.center, size: CGSize(width: 100.0, height: 100.0)))
        self.circleView.layer.cornerRadius = self.circleView.frame.width / 2.0
        self.circleView.backgroundColor = .green
        self.view.addSubview(circleView)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func circleMoved(_ recognizer : UIPanGestureRecognizer){
        let location = recognizer.location(in: self.view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }


}

