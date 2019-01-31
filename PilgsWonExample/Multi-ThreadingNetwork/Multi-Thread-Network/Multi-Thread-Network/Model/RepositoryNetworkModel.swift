//
//  RepositoryNetworkModel.swift
//  Multi-Thread-Network
//
//  Created by JHH on 31/01/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation
import Alamofire
import RxCocoa
import RxSwift

struct RepositoryNetworkModel {
    private var repositoryName : Observable<String>
    
    
    private func fetchRepositories() -> Driver<[Repository]>{
        return Observable<[Repository]>.create { observer -> Disposable in
         
            /*
             알라모파이어 통신
             */
            return Disposables.create()
        }.asDriver(onErrorJustReturn: [])
    }
}
