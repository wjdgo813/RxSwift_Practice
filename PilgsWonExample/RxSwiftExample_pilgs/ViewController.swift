//
//  ViewController.swift
//  RxSwiftExample_pilgs
//
//  Created by JHH on 01/11/2018.
//  Copyright © 2018 JHH. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
/*
 예제
 https://pilgwon.github.io/blog/2017/09/26/RxSwift-By-Examples-1-The-Basics.html
 */
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var shownCities = [String]()
    private let allCities = ["New York","London","Oslo","Warsaw","Berlin","Praga"]
    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar
            .rx.text
            .orEmpty //옵셔널이 아니도록
            .debounce(0.5, scheduler: MainScheduler.instance) //0.5초 딜레이를 갖고
            .distinctUntilChanged() //새로운 값이 이전과 같은지 비교
            .filter{ !$0.isEmpty } //값이 비어 있을때는 빈 값을 요청하지 않기 위해
            .subscribe({ [unowned self] query in 
            print("\(query.element ?? "")")
            self.shownCities = self.allCities.filter{ $0.hasPrefix(query.element ?? "")}
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}


extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownCities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityPrototypeCell", for: indexPath)
        cell.textLabel?.text = shownCities[indexPath.row]
        return cell
    }
}

