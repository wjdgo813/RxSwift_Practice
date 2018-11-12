//
//  ViewController.swift
//  RxObservable
//
//  Created by JHH on 12/11/2018.
//  Copyright © 2018 JHH. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private var disposeBag : DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        checkArrayObservable(items: [4,3,2,0,1]).subscribe { (event) in
            switch event{
            case .next(let value):
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("completed!")
            }
        }.disposed(by: self.disposeBag)
    }
    
    private func checkArrayObservable(items: [Int]) -> Observable<Int>{
        return Observable.create({ observer -> Disposable in
            for item in items {
                if item == 0 {
                    observer.onError(NSError(domain: "ERROR : value is zero", code: 0, userInfo: nil))
                    break
                }
                observer.onNext(item)
                sleep(1)
            }
            
            observer.onCompleted()
            return Disposables.create()
        })
    }
}

