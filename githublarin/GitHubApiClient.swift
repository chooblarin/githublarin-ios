//
//  GitHubApiClient.swift
//  githublarin
//
//  Created by Sota Hatakeyama on 2016/01/31.
//  Copyright © 2016年 chooblarin. All rights reserved.
//

import Alamofire
import RxSwift
import RxCocoa

class GitHubAPIClient {

    let GitHubApiURL = "https://api.github.com"
    private let manager = Alamofire.Manager.sharedInstance

    static let sharedInstance = GitHubAPIClient()

    func request(method: Alamofire.Method = .GET, path: String) -> Observable<AnyObject> {
        let request = self.manager.request(method, self.GitHubApiURL + path).request
        if let request = request  {
            return self.manager.session.rx_JSON(request)
        } else {
            fatalError("Invalid request")
        }
    }

    func demo() -> Observable<AnyObject> {
        return request(.GET, path: "/users?since=30")
    }

    func searchRepository(searchKey: String) -> Observable<[AnyObject]> {
        return request(.GET, path: "/search/repositories?q=" + searchKey)
            .map({ responseJson -> [AnyObject] in
                guard let items = responseJson["items"] as? [AnyObject] else { throw commonError("Json parse error")  }
                return items
            })
    }
}