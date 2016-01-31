//
//  ViewController.swift
//  githublarin
//
//  Created by Sota Hatakeyama on 2016/01/28.
//  Copyright © 2016年 chooblarin. All rights reserved.
//

import UIKit
import RxSwift
import Gloss

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GitHubAPIClient.sharedInstance.searchRepository("RxJava")
            .observeOn(Dependencies.sharedDependencies.backgroundWorkScheduler)
            .subscribeNext { anyobjects -> Void in
                anyobjects.forEach({ anyobject -> () in
                    let json = anyobject as! JSON
                    let repository = Repository(json: json)
                    print(repository?.fullName)
                })
            }.addDisposableTo(self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
