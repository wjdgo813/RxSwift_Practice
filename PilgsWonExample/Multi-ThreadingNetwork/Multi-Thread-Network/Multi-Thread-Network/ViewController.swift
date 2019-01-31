//
//  ViewController.swift
//  Multi-Thread-Network
//
//  Created by JHH on 31/01/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import UIKit
import ObjectMapper
import RxSwift
import RxCocoa
import Alamofire

//https://pilgwon.github.io/blog/2017/10/14/RxSwift-By-Examples-4-Multithreading.html

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBind()
    }

    private func setupBind(){
        var rx_searchBarText : Observable<String>{
            return searchBar.rx.text.orEmpty
                .filter{ $0.count > 0 }
                .throttle(0.5,scheduler:MainScheduler.instance)
                .distinctUntilChanged()
        }
        
        
    }

}

