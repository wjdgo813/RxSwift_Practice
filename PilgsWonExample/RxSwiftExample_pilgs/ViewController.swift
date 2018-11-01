//
//  ViewController.swift
//  RxSwiftExample_pilgs
//
//  Created by JHH on 01/11/2018.
//  Copyright © 2018 JHH. All rights reserved.
//

import UIKit

/*
 예제
 https://pilgwon.github.io/blog/2017/09/26/RxSwift-By-Examples-1-The-Basics.html
 */
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var shownCities = [String]()
    private let allCities = ["New York","London","Oslo","Warsaw","Berlin","Praga"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
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

