//
//  ViewController.swift
//  RxSwiftIn4Hours
//
//  Created by iamchiwon on 21/12/2018.
//  Copyright © 2018 n.code. All rights reserved.
//

//https://www.youtube.com/watch?v=w5Qmie-GbiA
//https://github.com/iamchiwon/RxSwift_In_4_Hours

import RxCocoa
import RxSwift
import UIKit

class ViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    let idValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let idInputText : BehaviorSubject<String> = BehaviorSubject(value: "")
    let pwValid : BehaviorSubject<Bool> = BehaviorSubject(value: false)
    let pwInputText : BehaviorSubject<String> = BehaviorSubject(value: "")

    override func viewDidLoad() {
        super.viewDidLoad()
//        firstBindUI()
        bindInput()
        bindOutput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        disposeBag = DisposeBag()
    }

    // MARK: - IBOutler

    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var idValidView: UIView!
    @IBOutlet var pwValidView: UIView!

    // MARK: - Bind UI
    private func bindInput(){
        //input : 아이디 입력 , 비번 입력
        idField.rx.text.orEmpty
            .bind(to:idInputText)
            .disposed(by:disposeBag)
        
        
        idInputText // idInputText == idField.rx.text.orEmpty
            .map(checkEmailValid)
            .bind(to: idValid) //id 유효값을 idValid에 저장.
            .disposed(by: disposeBag)
        
        pwField.rx.text.orEmpty
            .bind(to:pwInputText)
            .disposed(by: disposeBag)
        
        pwInputText // pwInputText == pwField.rx.text.orEmpty
            .map(checkPasswordValid)
            .bind(to: pwValid)
            .disposed(by: disposeBag)
        
    }
    
    private func bindOutput(){
        //output : 블릿, 로그인 버튼 enable
        idValid.subscribe(onNext : { b in self.idValidView.isHidden = b})
            .disposed(by: disposeBag)
        
        pwValid.subscribe(onNext: { b in self.pwValidView.isHidden = b})
            .disposed(by: disposeBag)
        
        Observable.combineLatest(idValid, pwValid, resultSelector: { $0 && $1 })
            .subscribe(onNext : { s in self.loginButton.isEnabled = s
            }).disposed(by: disposeBag)
        
        pwInputText.subscribe(onNext: { s in
            print(s)
        }).disposed(by: disposeBag)

    }
    
    
    private func firstBindUI() {
        /*
         idField.rx.text
         .filter{ $0 != nil }
         .map { $0! }
         .map(checkEmailValid)
         .subscribe(onNext:{ s in
         print(s)
         })
         .disposed(by: disposeBag)
         */
        
        
        
        idField.rx.text.orEmpty
            .map(checkEmailValid)
            .subscribe(onNext:{ s in
            print(s)
                self.idValidView.isHidden = s
        })
            .disposed(by: disposeBag)
        
        
        
        pwField.rx.text.orEmpty
            .map(checkPasswordValid)
            .subscribe(onNext : { s in
              self.pwValidView.isHidden = s
            }).disposed(by: disposeBag)
        
        /*
        pwField.rx.text.orEmpty
            .observeOn(MainScheduler.instance)
            .map(checkPasswordValid)
            .subscribe(onNext : { s in
                self.pwValidView.isHidden = s
            }).disposed(by: disposeBag)
         
         
        */
        
        pwField.rx.text.orEmpty
            .asDriver()
            .drive(onNext : {
                
            })
            .map(checkPasswordValid)
            .subscribe(onNext : { s in
                self.pwValidView.isHidden = s
            }).disposed(by: disposeBag)
        
        Observable.combineLatest(
            idField.rx.text.orEmpty.map(checkEmailValid),
            pwField.rx.text.orEmpty.map(checkPasswordValid),
            resultSelector: { s1 , s2 in s1 && s2 }
            ).subscribe(onNext : { b in
                self.loginButton.isEnabled = b
            }).disposed(by: disposeBag)
        
    }

    // MARK: - Logic

    private func checkEmailValid(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }

    private func checkPasswordValid(_ password: String) -> Bool {
        return password.count > 5
    }
}
