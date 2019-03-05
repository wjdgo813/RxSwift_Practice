//
//  ViewController.swift
//  ObservableAndTheBind.
//
//  Created by JHH on 17/01/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

//https://pilgwon.github.io/blog/2017/10/09/RxSwift-By-Examples-2-Observable-And-The-Bind.html
import ChameleonFramework
import UIKit
import RxSwift
import RxCocoa
/*
 -Variable : BehaviorSubject
 -Observable : 선물 (관찰하고 싶은 상대)
 -Observer : 선물 받는 대상자
 */

class ViewController: UIViewController {
    
    var circleViewModel : CircleViewModel!
    var circleView : UIView!
    var disposeBag = DisposeBag()
    
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
        
        circleViewModel = CircleViewModel()
        
        //circleView의 중앙지점을 centerObservable에 묶습니다.(bind)
        circleView.rx
            .observe(CGPoint.self, "center")
            .bind(to: circleViewModel.centerVariable)
            .disposed(by: self.disposeBag)
        
        
        circleViewModel.backgroundColorObservable
            .subscribe(onNext : { [weak self] backgroundColor in
                UIView.animate(withDuration: 0.1, animations: {
                    self?.circleView.backgroundColor = backgroundColor
                })
            }).disposed(by: self.disposeBag)
        
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
