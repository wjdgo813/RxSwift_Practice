//
//  IssueTrackerModel.swift
//  Network
//
//  Created by JHH on 21/01/2019.
//  Copyright © 2019 JHH. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper
import RxOptional
import RxSwift

struct IssueTrackerModel {
    let provider : MoyaProvider<GitHub>
    let repository : Observable<String>
    
    func trackIssue()->Observable<[Issue]>{
        
    }
    
    internal func findIssue(repository : Repository) -> Observable<Issue?>{
        return self.provider
            .rx.request(GitHub.issues(repositoryFullName: repository.fullName))
            .debug().mapOptional(to: Issue.self).
    }
    
    internal func findRepository(name:String) -> Observable<Repository?>{
        
    }
}
