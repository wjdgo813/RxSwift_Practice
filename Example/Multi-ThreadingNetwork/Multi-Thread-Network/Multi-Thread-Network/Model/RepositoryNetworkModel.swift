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
import ObjectMapper

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}


struct RepositoryNetworkModel {
    
    lazy var rxRepositories         : Driver<[Repository]> = self.fetchRepositories()
    private var repositoryName : Observable<String>
    
    init(withNameObservable nameObservable : Observable<String>) {
        self.repositoryName = nameObservable
        
    }
    
    private func fetchRepositories() -> Driver<[Repository]>{
        return repositoryName
            .do(onNext:{ _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest{ text in
            return Observable.create{ observer -> Disposable in
                Alamofire.request("https://api.github.com/users/\(text)/repos", method: .get).responseJSON(completionHandler: { (result) in
                    if let repos = Mapper<Repository>().mapArray(JSONObject: result.result.value) {
                        observer.onNext(repos)
                        observer.onCompleted()
                    }else{
                        observer.onError(ApiError.notFound)
                    }
                })
                return Disposables.create()
            }
            }.do(onNext:{ _ in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            })
            .asDriver(onErrorJustReturn: [])
    }
}
