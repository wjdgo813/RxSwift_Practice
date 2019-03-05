//
//  ViewController.swift
//  Network
//
//  Created by JHH on 21/01/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit

import Moya
import Moya_ModelMapper
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let disposeBag = DisposeBag()
    var provider : MoyaProvider<GitHub>!
    var latestRepositoryName : Observable<String>{
        return searchBar
            .rx.text
            .orEmpty
            .debounce(0.5 , scheduler: MainScheduler.instance)
            .distinctUntilChanged()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
    }

    private func setupRx(){
        provider = MoyaProvider<GitHub>()
        
        //유저가 셀을 클릭 했을 때 테이블 뷰에게 알려줌.
        //키보드가 보여주고 있다면 숨김.
        tableView
            .rx.itemSelected
            .subscribe( onNext : { indexPath in
                if self.searchBar.isFirstResponder == true{
                    self.view.endEditing(true)
                }
            }).disposed(by: disposeBag)
    }

}

