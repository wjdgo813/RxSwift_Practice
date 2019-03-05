//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

import RxSwift
import UIKit

class ViewController: UITableViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var progressView: UIActivityIndicatorView!
    
    var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func exJust1() {
//        Observable.just("Hello World")
//            .subscribe(onNext: { str in
//                print(str)
//            })
//            .disposed(by: disposeBag)
        
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe { event in
                switch event{
                case .next(let str):
                    print("next : \(str)")
                    break
                case .error(let error):
                    print("error : \(error.localizedDescription)")
                    break
                case .completed:
                    print("compltetd")
                    break
                }
        }
            .disposed(by: disposeBag)
        
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { s in
              print(s)
            }).disposed(by: disposeBag)
    }

    @IBAction func exJust2() {
        Observable.just(["Hello", "World"])
            .subscribe(onNext: { arr in
                print(arr)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFrom1() {
        Observable.from(["RxSwift", "In", "4", "Hours"])
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap1() {
        Observable.just("Hello") //stream
            .map { str in "\(str) RxSwift" }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap2() {
        Observable.from(["with", "곰튀김"])
            .map { $0.count }
            .subscribe(onNext: { str in
                print(str)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exFilter() {
        Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
            .filter { $0 % 2 == 0 }
            .subscribe(onNext: { n in
                print(n)
            })
            .disposed(by: disposeBag)
    }

    @IBAction func exMap3() {
        Observable.just("800x600")
//            .observeOn(ConcurrentDispatchQueueScheduler(qos: .default)) //Concurrency scheduler 실행한 순간부터 이 스케쥴러로 실행한다.
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)) //처음부터 이 스케쥴러로 실행한다.
            .map { $0.replacingOccurrences(of: "x", with: "/") } // 800/600
            .map { "https://picsum.photos/\($0)/?random" } // "https://picsum.photos/800/600/?random"
            .map { URL(string: $0) } // URL?
            .filter { $0 != nil }
            .map { $0! } //unwrapping URL!
            .map { try Data(contentsOf: $0) } // Data(contentsOf:url)
            .map { UIImage(data: $0) } // UIImage?
            .observeOn(MainScheduler.instance) //image set은 Main에서
            .do(onNext: { image in
                print("imageSize : \(image?.size)") //subscribe에서 onNext가 발생할때 나옴
            })
            .subscribe(onNext: { image in
                self.imageView.image = image
            })
            .disposed(by: disposeBag)
    }
}
